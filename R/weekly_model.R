
transport <- read_csv("data/transportation/Early_Model-based_Provisional_Estimates_of_Drug_Overdose__Suicide__and_Transportation-related_Deaths.csv",
                      col_types = cols(
                        `Week Ending Date` = col_character(),
                        State = col_character(),
                        `State Abbreviation` = col_character(),
                        `Median Number` = col_double(),
                        `Lower Bound` = col_double(),
                        `Upper Bound` = col_double(),
                        Outcome = col_character(),
                        `MMWR Year` = col_double(),
                        `MMWR Week` = col_double(),
                        `Rolling 4-Week Mean` = col_double(),
                        `Rolling 4-Week Lower` = col_double(),
                        `Rolling 4-Week Upper` = col_double()
                      ))
cols <- c(rev(c("#000000", "#252525", "#525252", "#737373")), "#e34a33")
names(cols) <- 2016:2020


ggplot(filter(transport, `State Abbreviation` == "US" &
                Outcome == "Transportation-related" &
                `MMWR Year` < 2021),
       aes(`MMWR Week`, `Median Number`, group = `MMWR Year`
       )) +
  geom_line(aes(color = as.factor(`MMWR Year`)), size = .6) +
  geom_vline(xintercept = 22, linetype = 2, alpha = .3)+
  geom_vline(xintercept = 11, linetype = 2, alpha = .7) +
  scale_color_manual(name= "year",
                     values = cols,
                     breaks = c(2016, 2020),
                     labels = c("2015-2019", "2020")) +
  xlab("week") +
  ylab("median number of expected deaths") +
  annotate("label", x = 11, y = 1080, label = "Some states start\nissuing stay-at-home\norders", 
           fill = "#eeeeee") +
  annotate("label", x = 22, y = 1100, label = "Minneapolis Riots\n(Week 22)", 
           fill = "#eeeeee") +
  labs(title = "Expected Number of Transport-Related Deaths",
       subtitle = "Data based on provisional estimates of the weekly numbers of drug overdose, suicide, and transportation-related deaths using “nowcasting” methods\nto account for the normal lag between the occurrence and reporting of these deaths.",
       caption = "https://data.cdc.gov/NCHS/Early-Model-based-Provisional-Estimates-of-Drug-Ov/v2g4-wqg2")



transport2 <- transport %>%
  filter(`MMWR Week` != 53) %>%
  filter(`MMWR Year` != 2015) %>%
  filter(Outcome == "Drug Overdose") %>%
  group_by(State, Outcome, `MMWR Week`) %>%
  mutate(diff = `Median Number`[which(`MMWR Year` == 2020)]- 
           `Rolling 4-Week Mean`[which(`MMWR Year` == 2019)]) %>%
  ungroup() %>%
  group_by(State, Outcome, `MMWR Year`) %>%
  mutate(s = sum(`Median Number`, na.rm = TRUE)) %>%
  ungroup() %>%
  group_by(State, Outcome, `MMWR Week`) %>%
  mutate(diffs = s[which(`MMWR Year` == 2020)] / 
           s[which(`MMWR Year` == 2019)]) %>%
  ungroup() 


ggplot(filter(transport2, `State Abbreviation` == "US" &
                Outcome == "Drug Overdose" &
                `MMWR Year` == 2020),
       aes(`MMWR Week`, `diff`)) +
  geom_line() +
  geom_vline(xintercept = 12, linetype = 2, alpha = .7) +
  ylab("difference in overdoses") +
  xlab("week") +
  labs(title = "Weekly drug overdoses in 2020, relative to the 4 week rolling mean in 2019")


ggplot(filter(transport2, `State` %in% c("Alabama",
                                    "Arizona",
                                    "California",
                                    "Colorado",
                                    "Florida",
                                    "Georgia",
                                    "Illinois",
                                    "Indiana",
                                    "Kentucky",
                                    "Louisiana",
                                    "Maryland",
                                    "Michigan",
                                    "Minnesota",
                                    "Missouri",
                                    "Nevada",
                                    "New York",
                                    "New York City",
                                    "Ohio",
                                    "Oregon",
                                    "South Carolina",
                                    "Tennessee",
                                    "Texas",
                                    "Virginia",
                                    "West Virginia",
                                    "Washington",
                                    "Wisconsin") &
                Outcome == "Drug Overdose" &
                `MMWR Year` == 2020),
       aes(`MMWR Week`, `diff`)) +
  geom_line() +
  #geom_vline(xintercept = 12, linetype = 2, alpha = .7) +
  ylab("difference in overdoses") +
  xlab("week") +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 3)) +
  geom_hline(yintercept = 0) +
  facet_wrap(~ fct_reorder(State, diffs, .desc = TRUE), scales = "free_y")+
  labs(title = "Expected weekly drug overdoses in 2020, relative to the 4 week rolling mean in 2019",
       subtitle = "The dotted vertical lines indicate the effective date of the stay-at-home orders in each state.\nData based on provisional estimates of the weekly numbers of drug overdose, suicide, and transportation-related deaths using “nowcasting” methods\nto account for the normal lag between the occurrence and reporting of these deaths. Weeks with less than 10 deaths are suppresed.",
       caption = "Source: https://data.cdc.gov/NCHS/Early-Model-based-Provisional-Estimates-of-Drug-Ov/v2g4-wqg2")


