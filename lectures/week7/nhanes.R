library(tidyverse)

# Recode according to the NHANES codebook for DPQ_E and give variables interpretable names
recode_dep_df <- function(df) {
  df %>% mutate(
    depression_level = factor(DPQ010, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know")),
    depression_frequency = factor(DPQ020, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know")),
    sleep_issue = factor(DPQ030, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know")),
    feeling_tired = factor(DPQ040, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know")),
    poor_appetite = factor(DPQ050, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know")),
    feeling_bad_about_self = factor(DPQ060, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know")),
    trouble_concentrating = factor(DPQ070, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know")),
    moving_or_speaking_slowly = factor(DPQ080, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know")),
    thoughts_of_death = factor(DPQ090, levels = c(0, 1, 2, 3, 7, 9), labels = c("Not at all", "Several days", "More than half the days", "Nearly every day", "Refused", "Don't know"))
    # Continue for other variables as needed based on the codebook
  ) %>% 
  select(SEQN, depression_level:thoughts_of_death)
}

# Rename and recode variables
recode_demo_df <- function(df) {
  if ("DMDBORN2" %in% colnames(df)) {
    cob <- factor(df$DMDBORN2, levels = c(1, 2, 4, 5, 7, 9), labels = c("USA", "Mexico", "Other Spanish speaking country", "Other non-Spankish speaking country", "Refused", "Don't know"))
    af <- factor(df$DMQMILIT, levels = c(1, 2, 7, 9), labels = c("Yes", "No", "Refused", "Don't know"))
  } else {
    cob <- factor(df$DMDBORN4, levels = c(1, 2, 77, 99), labels = c("USA", "Other", "Refused", "Don't know"))
    af <- factor(df$DMQMILIZ, levels = c(1, 2, 7, 9), labels = c("Yes", "No", "Refused", "Don't know"))
  }
  df %>% mutate(
    Gender = factor(RIAGENDR, levels = c(1, 2), labels = c("Male", "Female")),
    Age_at_Screening = RIDAGEYR,
    Age_in_Months_at_Screening = RIDAGEMN,
    Race_Ethnicity = factor(RIDRETH1, levels = c(1, 2, 3, 4, 5),
                            labels = c("Mexican American", "Other Hispanic", "Non-Hispanic White", "Non-Hispanic Black", "Other Race - Including Multi-Racial")),
    Served_in_Armed_Forces = af,
    Country_of_Birth = cob,
    Citizenship_Status = factor(DMDCITZN, levels = c(1, 2, 7, 9), labels = c("Citizen by birth or naturalization", "Not a citizen", "Refused", "Don't know")),
    Length_of_time_in_US = DMDYRSUS,
    Education_Level_Adults = factor(DMDEDUC2, levels = c(1:5, 7, 9), labels = c("Less than 9th grade", "9-11th grade (Includes 12th grade with no diploma)", "High school graduate/GED or equivalent", "Some college or AA degree", "College graduate or above", "Refused", "Don't know")),
    Marital_Status = factor(DMDMARTL, levels = c(1:6, 77, 99), labels = c("Married", "Widowed", "Divorced", "Separated", "Never married", "Living with partner", "Refused", "Don't know")),
    Total_people_in_Household = DMDHHSIZ,
    Total_people_in_Family = DMDFMSIZ,
    Annual_Household_Income = factor(INDHHIN2, levels = c(1:10, 12:15, 77, 99), labels = c("0-4,999", "5,000-9,999", "10,000-14,999", "15,000-19,999", "20,000-24,999", "25,000-34,999", "35,000-44,999", "45,000-54,999", "55,000-64,999", "65,000-74,999", "Over $20,000", "Under $20,000", "$75,000 to $99,999", "$100,000 and over",  "Refused", "Don't know"))
  ) %>% 
  select(SEQN, WTINT2YR, Gender:Annual_Household_Income)
}

recode_paq_df <- function(df) {
  df %>% mutate(
    # PAQ665 - Moderate recreational activities
    Moderate_Recreational_Activities = recode(PAQ665, `1` = "Yes", `2` = "No", `7` = "Refused", `9` = "Don't know", .default = NA_character_),
    
    # PAQ670 - Days of moderate recreational activities
    Days_Moderate_Recreational = as.numeric(PAQ670),
    
    # PAD615 - Minutes vigorous-intensity work
    Minutes_Vigorous_Work = case_when(
      PAD615 >= 10 & PAD615 <= 840 ~ as.numeric(PAD615),
      PAD615 == 7777 ~ NA_real_,
      PAD615 == 9999 ~ NA_real_,
      TRUE ~ NA_real_
    ),
    Minutes_ModerateActivities = case_when(
      PAD675 >= 10 & PAD675 <= 540 ~ as.numeric(PAD675),
      PAD675 == 7777 ~ NA_real_,
      PAD675 == 9999 ~ NA_real_,
      TRUE ~ NA_real_
    ),
    Minutes_SedentaryActivity = case_when(
      PAD680 >= 10 & PAD680 <= 840 ~ as.numeric(PAD680),
      PAD680 == 7777 ~ NA_real_,
      PAD680 == 9999 ~ NA_real_,
      TRUE ~ NA_real_
    ),
    Walk_or_Bicycle = recode(PAQ635, `1` = "Yes", `2` = "No", `7` = "Refused", `9` = "Don't know", .default = NA_character_),
  ) %>%
  select(SEQN, Moderate_Recreational_Activities:Walk_or_Bicycle)
}
