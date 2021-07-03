
homicide_race <- read.csv("data/homicides/homicides_month_race_no911_1999-2019.txt",
                    sep = "\t") %>%
  filter(Notes != "Total" & !is.na(Year)) %>%
  mutate(Month = str_replace(Month, "\\.*, ", "")) %>%
  mutate(Yearmon = as.yearmon(Month, "%b%Y")) %>%
  mutate(Race = case_when(
    Race == "White" & Hispanic.Origin == "Hispanic or Latino" ~ "Hispanic",
    Race == "White" & Hispanic.Origin == "Not Hispanic or Latino" ~ "White",
    Race == "Black or African American" &
      Hispanic.Origin == "Not Hispanic or Latino" ~ "Black",
    Race == "Asian or Pacific Islander" &
      Hispanic.Origin == "Not Hispanic or Latino" ~ "Asian",
    Race == "American Indian or Alaska Native" &
      Hispanic.Origin == "Not Hispanic or Latino" ~ "Indian"
  )) %>%
  filter(!is.na(Race)) %>%
  select(Year, Month, Yearmon, Deaths, Race)

homicide_race <- left_join(homicide_race, population_race,
                           by = c("Year", "Race"))
homicide_race$Rate <-  homicide_race$Deaths / homicide_race$Population * 10^5
homicide_race$n <- as.numeric(homicide_race$Yearmon)
homicide_race$Month <-  month(homicide_race$Yearmon)
homicide_race$Race <- as.factor(homicide_race$Race)

write_csv(homicide_race, "out/homicides/homicides_month_race_1999-2019.csv")
