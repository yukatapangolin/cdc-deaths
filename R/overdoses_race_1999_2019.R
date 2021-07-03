over <- read.csv("data/overdoses/overdoses_race_1999-2019.txt", sep = "\t") %>%
  filter(Notes != "Total" & !is.na(Year)) %>%
  mutate(Month = str_replace(Month, "\\.*, ", "")) %>%
  mutate(Yearmon = as.yearmon(Month, "%b%Y")) %>%
  mutate(Race = case_when(
    Race == "White" & Hispanic.Origin == "Hispanic or Latino" ~ "Hispanic",
    Race == "White" & Hispanic.Origin == "Not Hispanic or Latino" ~ "White",
    Race == "Black or African American" &
      Hispanic.Origin == "Not Hispanic or Latino" ~ "Black",
  )) %>%
  filter(!is.na(Race)) %>%
  select(Year, Month, Yearmon, Deaths, Race)

over <- left_join(over, population_race, by = c("Year", "Race"))
over$Rate <-  over$Deaths / over$Population * 10^5
over$n <- as.numeric(over$Yearmon)
over$Month <-  month(over$Yearmon)
over$Race <- as.factor(over$Race)


write_csv(over, "out/overdoses/overdoses_month_race_1999-2019.csv")
