#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from IPUMS USA website
# Author: Alen Mitrovski, Xiaoyan Yang and Matthew Wankiewicz
# Data: 22 October 2020
# Contact: matthew.wankiewicz@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data. 
raw_data1 <- read_dta("inputs/data/usa_00001.dta"
)
# Add the labels
raw_data1 <- labelled::to_factor(raw_data1)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
names(raw_data)

reduced_data1 <- 
  raw_data1 %>% 
  select(region,
         stateicp,
         sex, 
         age, 
         race, 
         hispan,
         marst, 
         bpl,
         citizen,
         educd,
         language,
         labforce,
         inctot,
         empstatd,
         vetstat)
rm(raw_data1)


#### What's next? ####

reduced_data1$age <- as.numeric(reduced_data1$age)

# format IPUMS data set so it can match the survey data we have
# must drop NAs because majority of them are just Alabama State and 
# people under 18

# professional degree beyond a bachelor's degree was included with masters degree

# filter out income total of 9999999, many responses were left blank for these
# respodents

reduced_data1_new <- reduced_data1 %>% filter(educd != "n/a", inctot < 9999999) %>% 
  mutate(age_groups = case_when(
    age <= 29 ~ "18-29",
    age <= 39 ~ "30-39",
    age <= 49 ~ "40-49",
    age <= 59 ~ "50-59",
    age <= 69 ~ "60-69",
    age > 69 ~ "70+"
  ),
  education_level = case_when(
    educd == "nursery school, preschool" ~ "3rd Grade or less",
    educd == "kindergarten" ~ "3rd Grade or less",
    educd == "grade 1" ~ "3rd Grade or less",
    educd == "grade 2" ~ "3rd Grade or less",
    educd == "grade 3" ~ "3rd Grade or less",
    educd == "grade 4" ~ "Middle School - Grades 4 - 8",
    educd == "grade 5" ~ "Middle School - Grades 4 - 8",
    educd == "grade 6" ~ "Middle School - Grades 4 - 8",
    educd == "grade 7" ~ "Middle School - Grades 4 - 8",
    educd == "grade 8" ~ "Middle School - Grades 4 - 8",
    educd == "grade 9" ~ "Completed some high school",
    educd == "grade 10" ~ "Completed some high school",
    educd == "grade 11" ~ "Completed some high school",
    educd == "12th grade, no diploma" ~ "Completed some high school",
    educd == "regular high school diploma" ~ "High school graduate",
    educd == "ged or alternative credential" ~ "Other post high school vocational training",
    educd == "some college, but less than 1 year" ~ "Completed some college, but no degree",
    educd == "1 or more years of college credit, no degree" ~ "Completed some college, but no degree",
    educd == "associate's degree, type not specified" ~ "Associate Degree",
    educd == "bachelor's degree" ~ "College Degree (such as B.A., B.S.)",
    educd == "master's degree" ~ "Masters degree",
    educd == "professional degree beyond a bachelor's degree" ~ "Masters degree",
    educd == "doctoral degree" ~ "Doctorate degree",
    educd == "no schooling completed" ~ "3rd Grade or less"
  ),
  income_group = case_when(
    inctot < 14999 ~ "Less than $14,999",
    inctot < 19999 ~ "$15,000 to $19,999",
    inctot < 24999 ~ "$20,000 to $24,999",
    inctot < 29999 ~ "$25,000 to $29,999",
    inctot < 34999 ~ "$30,000 to $34,999",
    inctot < 39999 ~ "$35,000 to $39,999",
    inctot < 44999 ~ "$40,000 to $44,999",
    inctot < 49999 ~ "$45,000 to $49,999",
    inctot < 55999 ~ "$50,000 to $54,999",
    inctot < 59999 ~ "$55,000 to $59,999",
    inctot < 64999 ~ "$60,000 to $64,999",
    inctot < 69999 ~ "$65,000 to $69,999",
    inctot < 74999 ~ "$70,000 to $74,999",
    inctot < 79999 ~ "$75,000 to $79,999",
    inctot < 84999 ~ "$80,000 to $84,999",
    inctot < 89999 ~ "$85,000 to $89,999",
    inctot < 94999 ~ "$90,000 to $94,999",
    inctot < 99999 ~ "$95,000 to $99,999",
    inctot < 124999 ~ "$100,000 to $124,999",
    inctot < 149999 ~ "$125,000 to $149,999",
    inctot < 174999 ~ "$150,000 to $174,999",
    inctot < 199999 ~ "$175,000 to $199,999",
    inctot < 224999 ~ "$200,000 to $249,999",
    inctot >= 225000 ~ "$250,000 and above",
  )
  )


reduced_data1_new$income_group <- as.factor(reduced_data1_new$income_group)
reduced_data1_new$education_level <- as.factor(reduced_data1_new$education_level)

write_rds(reduced_data1_new, "outputs/paper/post_strat.rds")



         