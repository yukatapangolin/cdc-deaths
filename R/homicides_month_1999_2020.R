
homicides_month <- read.csv("data/homicides/homicides_month_all_races_1999_2019.txt",
               sep = "\t") %>%
  filter(Notes != "Total" & !is.na(Year)) %>%
  mutate(Month = str_replace(Month, "\\.*, ", "")) %>%
  mutate(Yearmon = as.yearmon(Month, "%b%Y")) %>%
  mutate(Month = month(Yearmon)) %>%
  select(Yearmon, Deaths, Year, Month)

provisional_2020 <- read.csv("data/Monthly_Provisional_Counts_of_Deaths_by_Select_Causes__2020-2021.csv") %>%
  select(Year, Month, Assault..Homicide.) %>%
  rename(Deaths = Assault..Homicide.) %>%
  mutate(Yearmon = as.yearmon(str_c(Year, "-", Month), "%Y-%m"))

homicides_month <- bind_rows(homicides_month, provisional_2020)

homicides_month <- left_join(homicides_month, population_year,
                             by = c("Year")) %>%
  mutate(Population = replace_na(Population, 331449281)) %>%
  mutate(Rate = (Deaths) / Population * 10^5) %>%
  mutate(Floyd = if_else(Yearmon >= "2020-05-01", TRUE, FALSE)) %>%
  mutate(Floyd2 = if_else(Yearmon >= "2020-05-01", 1, 0)) %>%
  #mutate(floyd_mon = if_else(yearmon == "2020-05-01", TRUE, FALSE)) %>%
  mutate(n = as.numeric(Yearmon)) %>%
  na.omit()
homicides_month$Floyd2[which(homicides_month$Yearmon == "2020-05-01")] <- .25


write_csv(homicides_month, "out/homicides/homicides_month_1999_2020.csv")


ggplot(homicides_month, aes(as.Date(Yearmon), Deaths)) +
  geom_line(size = .5, alpha = .5) +
  #stat_rollapplyr(width = 12, size = 1) +
  geom_smooth(method = glm,
              formula = y ~ splines::ns(x, df = 10),
              method.args = list(family = "quasipoisson")) +
  geom_vline(xintercept = as.Date("2014-08-01"), linetype = 2) +
  xlab("date") +
  ylab("number of homicides") +
  scale_x_date(date_labels = "%b %Y") +
  #theme_glyptodon() +
  annotate("label", x = as.Date("2014-08-01"), y = 1970,
           label = "Ferguson Riots\n(Aug 2014)",
           fill = "#dddddd") +
  expand_limits(y = 0)

# Make sure I didn't screw anything up and compare with known 2019 data
stopifnot(
  all.equal(homicides_month$Deaths[241:251],
            c(1574,
              1356,
              1467,
              1444,
              1662,
              1673,
              1729,
              1639,
              1647,
              1610,
              1625)
  )
)

population <-  days_in_month(homicides_month$Month) /
                  (yday(str_c(homicides_month$Year, "-12-31")) / 12) *
  homicides_month$Population


fit1 <- mgcv::gam(Deaths ~ s(n, bs = "fs", k = 13) +
                    Floyd +
                    offset(log(population)),
                  data = homicides_month,
                  family = poisson()
)

fit2 <- mgcv::gam(Deaths ~ s(n, bs = "cr", k = 13) +
                   Floyd2 +
                   offset(log(population)),
                 data = homicides_month,
                 family = poisson()
)


fit3 <- mgcv::gam(Deaths ~ s(n, bs = "cr", k = 13) +
                   Floyd2  +
                   offset(log(population)),
                 data = homicides_month,
                 knots = list(n = c(seq(1999.333, 2019.333, length = 12),
                                    2020.333)),
                 family = poisson())
anova(fit1, fit2, fit3)
AIC(fit1)
AIC(fit2)
AIC(fit3)
appraise(fit1)
gam.check(fit1)
summary(fit)


new <- homicides_month
new$population <- 10^5
homicides_month$s <- exp(predict(fit1, new))

ggplot(homicides_month, aes(as.Date(Yearmon), Rate)) +
  geom_line(aes(as.Date(Yearmon), s), color = "blue1", alpha = .5) +
  geom_point() +
  expand_limits(y = 0) +
  theme_bw() +
  labs(title ="Monthly homicide rates in the United States and trend (Jan 1999 to Nov 2020)", 
                 subtitle = "All assault (homicide) deaths data for 2020 is provisional and may be incomplete. Deaths with ICD 10 codes of U01-U02 (terrorism related homicides)\nwere omitted from Sep 2001 to avoid showing 9/11 deaths",
                 caption = "Source: 1999-2019 from Underlying Cause of Death on CDC WONDER Online Database. 2020 from Monthly Provisional Counts of Deaths by Select Causes, 2020-2021") +
  xlab("date") +
  ylab("rate per 100,000 person-months")
ggsave("chart.png", width = 14, heigh = 7, dpi = 72)
