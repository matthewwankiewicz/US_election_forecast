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
         age,
         language)


# add this in order to clean state names to match the IPUMS data

names_matcher <- tibble(stateicp = state.name, state = state.abb)

# filter out people that are undecided or who will vote someone else, then create a variable called
# vote_biden gives a 1 if they vote for Biden, 0 for Trump
# group ages into four groups; under 35, 36-49, 50-65 and 65+
# reformat the sex variable, rename it and make responses lowercase
# group education levels into 3 groups; high school or lower, some post-secondary and
# post-secondary or higher. Demographics were grouped into these 3 groups because 
# the model was messy when more groups were included and because the tendenices between
# these groups were similar.
# group races into four categories, many races in the asian category had very few observations
# made our results cleaner to just divide them into four
# lastly, make hispanic a binary variable, because once again many groups were present

reduced_data_new <- reduced_data %>% filter(vote_2020 == "Joe Biden" | vote_2020 == "Donald Trump") %>% 
  mutate(age_groups = case_when(
    age <= 35 ~ "18-35",
    age <= 50 ~ "36-49",
    age <= 65 ~ "50-65",
    age >= 65 ~ "65+"
  ),
  vote_biden = ifelse(vote_2020 == "Joe Biden", 1, 0),
  sex = ifelse(gender == "Female", "female", "male"),
  races = case_when(
    race_ethnicity == "White" ~ "white",
    race_ethnicity == "Black, or African American" ~ "black",
    race_ethnicity == "American Indian or Alaska Native" ~ "other race, nec",
    race_ethnicity == "Asian (Chinese)" ~ "asian",
    race_ethnicity == "Asian (Japanese)" ~ "asian",
    race_ethnicity == "Asian (Asian Indian)" ~ "asian",
    race_ethnicity == "Asian (Filipino)" ~ "asian",
    race_ethnicity == "Asian (Korean)" ~ "asian",
    race_ethnicity == "Asian (Vietnamese)" ~ "asian",
    race_ethnicity == "Asian (Other)" ~ "asian",
    race_ethnicity == "Pacific Islander (Native Hawaiian)" ~ "asian",
    race_ethnicity == "Pacific Islander (Guamanian)" ~ "asian",
    race_ethnicity == "Pacific Islander (Samoan)" ~ "asian",
    race_ethnicity == "Pacific Islander (Other)" ~ "asian",
    race_ethnicity == "Some other race" ~ "other race, nec"
  ),
  hispanic = ifelse(hispanic == "Not Hispanic", "not hispanic", "hispanic"),
  education_level = case_when(
    education == "3rd Grade or less" ~ "High school or lower",
    education == "Middle School - Grades 4 - 8" ~ "High school or lower",
    education == "Completed some high school" ~ "High school or lower",
    education == "High school graduate" ~ "High school or lower",
    education == "Other post high school vocational training" ~ "High school or lower",
    education == "Completed some college, but no degree" ~ "Some post secondary",
    education == "Associate Degree" ~ "Post Secondary or Higher",
    education == "College Degree (such as B.A., B.S.)" ~ "Post Secondary or Higher",
    education == "Completed some graduate, but no degree" ~ "Post Secondary or Higher",
    education == "Masters degree" ~ "Post Secondary or Higher",
    education == "Doctorate degree" ~ "Post Secondary or Higher",
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
reduced_data_new$races <- as.factor(reduced_data_new$races)
reduced_data_new$stateicp <- as.factor(reduced_data_new$stateicp)
reduced_data_new$education_level <- as.factor(reduced_data_new$education_level)
reduced_data_new$hispanic <- as.factor(reduced_data_new$hispanic)

# write our new data set into our outputs folder under polling_data.rds

write_rds(reduced_data_new, "outputs/paper/data/polling_data.rds")
