# Overview of the Project

This repo contains code and data for forecasting the US 2020 presidential election. It was created by Matthew Wankiewicz, Xiaoyan Yang and Alen Mitrovski. The purpose is to create a report that summarises the results of a statistical model that we built. Some data is unable to be shared publicly. We detail how to get that below. The sections of this repo are: inputs, outputs, scripts.

Inputs contain data that are unchanged from their original. We use two datasets, we cannot share these files but the steps we took to obtain them are documented below: 

- Survey Data from Voter Study Group.
    - In order to obtain this data, visit https://www.voterstudygroup.org/publication/nationscape-data-set and scroll to the bottom of the page and enter your first and last name and your email. After completing this, you will receive an email, it may come quickly but it also may take a couple days (you've been warned!). After you get the email from the Voter Study Group, you will click the link that says "Download the .dta file". After completing this task, you will download a .zip file which contains many different weeks of survey data. The week that was chosen for this report was called "ns20200625". After completing these steps, you will have the data we used.

- ACS Data from IPUMS USA.
    - In order to obtain the ACS data, visit https://usa.ipums.org/usa/index.shtml. First, you must create an account, you need to fill out information such as name, organization, email and why you plan to use the data. After creating an account, go back to the original link and click "Get Data" in the middle of the page. First, you must select a sample (year), we used the 2018 1 year ACS. After completing this step, you can choose a variety of variables inlcuding Age, Gender, Race to name a few. For our report we selected "age", "sex", "hispan", "educd", "races", and "stateicp" among other variables. After selecting your variables, click on "View Data Cart", then click "Create Data Extract". You will then see a page with information about your data, for your "Data Format" (3rd row), select STATA or .dta. After completing this you can either cut down on your file size by choosing a smaller sample or describe your extract and click submit. For our report, we chose a sample size of 2,217,000 persons. After this is done, you will receive an email when the data is processed.

Outputs contain data that are modified from the input data, the report and supporting material.

- references.bib contains all of our references, from libraries in R to articles from the internet.
- my_header.tex contains some formatting, necessary for making sure the knitted pdf is clean.
- forecasting_us_election.pdf and forecasting_us_election.rmd are our final report in pdf and rmd form.
- There is another .tex and a .log file which are used to compile the report.
- Data folder, which contains:
  - electoral_colleges.csv contains information about the states of the US and the number of electoral colleges that state has.
  - post_strat.rds is the cleaned version of the ACS data from IPUMS using our data cleaning script. 
  - polling_data.rds is the cleaned version of the Voter Study Group using the other data cleaning script.

Scripts contain R scripts that take inputs and outputs and produce outputs. These are:

- 01_data_cleaning-survey.R to clean our polling data
- 01_data_cleaning-post-strat.R to clean our post-stratification data