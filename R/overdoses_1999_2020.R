
overdoses_2020 <- read.csv("data/Monthly_Provisional_Counts_of_Deaths_by_Select_Causes__2020-2021.csv") %>%
  select(Year, Month, Drug.Overdose) %>%
  rename(Deaths = Drug.Overdose) %>%
  mutate(Yearmon = as.yearmon(str_c(Year, "-", Month), "%Y-%m")) %>%
  select(Year, Yearmon, Deaths)

overdoses_2020 <- bind_rows(read.csv("data/overdoses/overdoses_1999-2019.txt",
                                     sep = "\t") %>%
                       filter(Notes != "Total" & !is.na(Year)) %>%
                       mutate(Month = str_replace(Month, "\\.*, ", "")) %>%
                       mutate(Yearmon = as.yearmon(Month, "%b%Y")) %>%
                       select(Year, Yearmon, Deaths),
                       overdoses_2020
)
write_csv(overdoses_2020, "out/overdoses/overdoses_month_1999_2020.csv")

ggplot(overdoses_2020, aes(Yearmon, Deaths)) +
  geom_line() +
  geom_vline(xintercept = as.yearmon("2020-02-01"), linetype = 2, alpha = .7)
