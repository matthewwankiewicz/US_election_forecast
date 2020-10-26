#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from Voter Study Group
# Author: Alen Mitrovski, Xiaoyan Yang and Matthew Wankiewicz
# Data: 22 October 2020
# Contact: matthew.wankiewicz@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data from Voter Group Webste after requesting access
# and save the folder that you're interested in to inputs/data
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data (You might need to change this if you use a different dataset)
raw_data <- read_dta("inputs/data/ns20200625/ns20200625.dta")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables
reduced_data <- 
  raw_data %>% 
  select(interest,
         registration,
         vote_2016,
         vote_intention,
         vote_2020,
         ideo5,
         employment,
         foreign_born,
         gender,
         census_region,
         hispanic,
         race_ethnicity,
         household_income,
         education,
         state,
         congress_district,
         age)


#### What else???? ####
# Maybe make some age-groups?
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?


names_matcher <- tibble(stateicp = state.name, state = state.abb)

# group voter ages by intervals of 10 years or so
# filter out people that are undecided or who will vote someone else, then create a variable called
# vote_biden gives a 1 if they vote for Biden, 0 for Trump

reduced_data_new <- reduced_data %>% filter(vote_2020 == "Joe Biden" | vote_2020 == "Donald Trump") %>% 
  mutate(age_groups = case_when(
    age <= 29 ~ "18-29",
    age <= 39 ~ "30-39",
    age <= 49 ~ "40-49",
    age <= 59 ~ "50-59",
    age <= 69 ~ "60-69",
    age > 69 ~ "70+"
  ),
  vote_biden = ifelse(vote_2020 == "Joe Biden", 1, 0),
  sex = ifelse(gender == "Female", "female", "male"),
  race = case_when(
    race_ethnicity == "White" ~ "white",
    race_ethnicity == "Black, or African American" ~ "black/african american/negro",
    race_ethnicity == "American Indian or Alaska Native" ~ "american indian or alaska native",
    race_ethnicity == "Asian (Chinese)" ~ "chinese",
    race_ethnicity == "Asian (Japanese)" ~ "japanese",
    race_ethnicity == "Asian (Asian Indian)" ~ "other asian or pacific islander",
    race_ethnicity == "Asian (Filipino)" ~ "other asian or pacific islander",
    race_ethnicity == "Asian (Korean)" ~ "other asian or pacific islander",
    race_ethnicity == "Asian (Vietnamese)" ~ "other asian or pacific islander",
    race_ethnicity == "Asian (Other)" ~ "other asian or pacific islander",
    race_ethnicity == "Pacific Islander (Native Hawaiian)" ~ "other asian or pacific islander",
    race_ethnicity == "Pacific Islander (Guamanian)" ~ "other asian or pacific islander",
    race_ethnicity == "Pacific Islander (Samoan)" ~ "other asian or pacific islander",
    race_ethnicity == "Pacific Islander (Other)" ~ "other asian or pacific islander",
    race_ethnicity == "Some other race" ~ "other race, nec"
  )
  )

# format state names so the whole state name is written out, to match IPUMS data

reduced_data_new <-
  reduced_data_new %>%
  left_join(names_matcher)

# make lowercase to match IPUMS data

reduced_data_new <- reduced_data_new %>% 
  mutate(stateicp = tolower(stateicp))

# replace NA's with DC, makes sense to replace because it may not have been listed in survey
reduced_data_new$stateicp <- replace_na(reduced_data_new$stateicp, "district of columbia")

# change format of columns to match post-strat formats

reduced_data_new$sex <- as.factor(reduced_data_new$sex)
reduced_data_new$race <- as.factor(reduced_data_new$race)
reduced_data_new$stateicp <- as.factor(reduced_data_new$stateicp)


write_rds(reduced_data_new, "outputs/paper/polling_data.rds")