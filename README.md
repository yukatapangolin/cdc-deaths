<!-- badges: start -->
  [![R-CMD-check](https://github.com/yukatapangolin/cdc-deaths/workflows/R-CMD-check/badge.svg)](https://github.com/yukatapangolin/cdc-deaths/actions)
<!-- badges: end -->
# CDC Homicide, Drug Overdose, and Transport-Related Death Data

![homicide chart](https://github.com/yukatapangolin/cdc-deaths/blob/master/chart.png?raw=true)

This repository cleans and bundles datasets related to the increase in homicides, drug overdoses and transport related deaths after the COVID-19 pandemic. The datasets were last updated on July 1, 2020. 


The data is located in the `out` directory

## Special Note

ICD 10 codes of U01-U02 (terrorism related homicides) were not included in the deaths during the month of September 2001 in the case of monthly data and during all of 2001 in the case of yearly data.

### Racial Recodes

Non-Hispanic Blacks or African Americans were recoded as Black for clarity, Non-Hispanic Whites as White, Hispanic Whites as Hispanic, Non-Hispanic Asian or Pacific Islander as Asian, and Non-Hispanic American Indian or Alaska Native as Indian.

## Sources

- [Monthly Provisional Counts of Deaths by Select Causes, 2020-2021](
https://data.cdc.gov/NCHS/Monthly-Provisional-Counts-of-Deaths-by-Select-Cau/9dzk-mvmi)
- [Weekly Provisional Counts of Deaths by State and Select Causes, 2020-2021](
https://data.cdc.gov/NCHS/Weekly-Provisional-Counts-of-Deaths-by-State-and-S/muzy-jte6)
- [Early Model-based Provisional Estimates of Drug Overdose, Suicide, and Transportation-related Deaths](https://data.cdc.gov/NCHS/Early-Model-based-Provisional-Estimates-of-Drug-Ov/v2g4-wqg2)
- [Underlying Cause of Death, 1999-2019](https://wonder.cdc.gov/ucd-icd10.html)
