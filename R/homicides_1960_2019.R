
historical_homicides <- function() {
  df68 <- read.csv("data/homicides/homicides_1968-1978.txt", sep = "\t") %>%
    filter(Notes != "Total" & !is.na(Year)) %>%
    select(Year, Deaths, Population, Crude.Rate)

  df79 <- read.csv("data/homicides/homicides_1979-1998.txt", sep = "\t") %>%
    filter(Notes != "Total" & !is.na(Year)) %>%
    select(Year, Deaths, Population, Crude.Rate)

  df99 <- read.csv("data/homicides/homicides_1999-2019.txt", sep = "\t") %>%
    filter(Notes != "Total" & !is.na(Year)) %>%
    select(Year, Deaths, Population, Crude.Rate)

  # Old homicde data from
  # https://www.cdc.gov/nchs/data/dvs/lead1900_98.pdf
  df60 <- tibble(Year = 1960:1967,
                 Deaths = c(8464, 8578, 9013, 9225, 9814,
                            10712, 11606, 13425),
                 Crude.Rate = c(4.7, 4.7, 4.9, 4.9, 5.1, 5.5, 5.9, 6.8),
                 Population = Deaths * 10^5 / Crude.Rate)

  bind_rows(df60, df68, df79, df99) %>%
    rename(Rate = Crude.Rate)
}

homicides_historical <- historical_homicides()
write_csv(homicides_historical, "out/homicides/homicides_1960_2019.csv")
