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
names(raw_data1)

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

reduced_data1_new <- reduced_data1 %>% filter(inctot < 9999999) %>% 
  filter(race != "two major races", race != "three or more major races",
         age >= 18) %>% 
  mutate(age_groups = case_when(
    age <= 35 ~ "18-35",
    age <= 50 ~ "36-49",
    age <= 65 ~ "50-65",
    age >= 65 ~ "65+"
  ),
  education_level = case_when(
    educd == "nursery school, preschool" ~ "High school or lower",
    educd == "kindergarten" ~ "High school or lower",
    educd == "grade 1" ~ "High school or lower",
    educd == "grade 2" ~ "High school or lower",
    educd == "grade 3" ~ "High school or lower",
    educd == "grade 4" ~ "High school or lower",
    educd == "grade 5" ~ "High school or lower",
    educd == "grade 6" ~ "High school or lower",
    educd == "grade 7" ~ "High school or lower",
    educd == "grade 8" ~ "High school or lower",
    educd == "grade 9" ~ "High school or lower",
    educd == "grade 10" ~ "High school or lower",
    educd == "grade 11" ~ "High school or lower",
    educd == "12th grade, no diploma" ~ "High school or lower",
    educd == "regular high school diploma" ~ "High school or lower",
    educd == "ged or alternative credential" ~ "High school or lower",
    educd == "some college, but less than 1 year" ~ "Some post secondary",
    educd == "1 or more years of college credit, no degree" ~ "Some post secondary",
    educd == "associate's degree, type not specified" ~ "Post Secondary or Higher",
    educd == "bachelor's degree" ~ "Post Secondary or Higher",
    educd == "master's degree" ~ "Post Secondary or Higher",
    educd == "professional degree beyond a bachelor's degree" ~ "Post Secondary or Higher",
    educd == "doctoral degree" ~ "Post Secondary or Higher",
    educd == "no schooling completed" ~ "High school or lower"
  ),
  races = ifelse(race == "white", "white",
                 ifelse(race == "black/african american/negro", "black",
                        ifelse(race == "other race, nec", "other race, nec", "asian"))),
  hispanic = ifelse(hispan == "not hispanic", "not hispanic", "hispanic")
  )


reduced_data1_new$education_level <- as.factor(reduced_data1_new$education_level)
reduced_data1_new$races <- as.factor(reduced_data1_new$races)
reduced_data1_new$hispanic <- as.factor(reduced_data1_new$hispanic)

write_rds(reduced_data1_new, "outputs/paper/post_strat.rds")



         