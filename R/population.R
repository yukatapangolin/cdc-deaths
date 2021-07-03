
population_year <- read.csv("data/population_year.txt", sep = "\t") %>%
  filter(Notes != "Total") %>%
  select(Population, Year) %>%
  na.omit() %>%
  # Add the April 2020 census population
  bind_rows(tibble(Population = 331449281,
                     Year = 2020))
write_csv(population_year, "out/population.csv")


population_race <- read.csv("data/population_race_year.txt", sep = "\t") %>%
  filter(Notes != "Total" & !is.na(Year)) %>%
  mutate(Race = case_when(
    Race == "White" & Hispanic.Origin == "Hispanic or Latino" ~ "Hispanic",
    Race == "White" & Hispanic.Origin == "Not Hispanic or Latino" ~ "White",
    Race == "Black or African American" &
      Hispanic.Origin == "Not Hispanic or Latino" ~ "Black",
    Race == "Asian or Pacific Islander" &
      Hispanic.Origin == "Not Hispanic or Latino" ~ "Asian",
    Race == "American Indian or Alaska Native" &
      Hispanic.Origin == "Not Hispanic or Latino" ~ "Indian",
  )) %>%
  filter(!is.na(Race)) %>%
  mutate(Population = as.numeric(Population)) %>%
  select(Year, Population, Race)
write_csv(population_year, "out/population_by_race.csv")
