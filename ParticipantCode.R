# *********************************************************************
# OVERVIEW ###########
# *********************************************************************
# ParticipantCode.R
# Code to use in demonstrations in slides
# 
# NAME:
# Created on: 

# *********************************************************************
# PACKAGES AND FUNCTIONS ###########
# *********************************************************************

library(dplyr)
library(readr)
library(ggplot2)

# *********************************************************************
# DATA ###########
# *********************************************************************

# Load Data
CCES_2018 <- read_csv(here::here("CCES18_subset.csv"))


# *********************************************************************
# DPLYR EXERCISES ###########
# *********************************************************************

# We are interested in approval to a political institution. Think about the 
# institution you want to focus on (and a second) and do the following:

# DPLYR EXERCISE 1 ##

# 1. Select the state, region, party, and two approval variables of choice 
# (Congress, President, Supreme Court)



# 2. Filter out the NA values on state and party variables.
# Hint: use `is.na()` and `!`.



# DPLYR EXERCISE 2 ##

# In the data frame that you previously created that took 
# out region, state, party, and approval variables, create 
# a summary table that describes the precent of people in 
# each state-party-region combination that approves your 
# institution of choice. Use mutate and `case_when()` to 
# recode your region variable so that 1 = Northeast, 
# 2 = Midwest, 3 = South and 4 = West.

# HINT - You can put multiple variables in the 
# `group_by()` command

# HINT - To create a proportion variable, use can use the 
# following function in the summarise environment. 
# NOTE how the approval variables are coded (1 = approve, 
# 2 = disapprove)
# 
# sum(appVar == 1, na.rm = TRUE)/length(appVar)




# When solutions are revealed in the session, insert it here
# or run the `dplry_solutions.R` which will be sent to the zoom
source("dplyr_solutions.R")

# *********************************************************************
# GGPLOT EXERCISES ###########
# *********************************************************************

# GGPLOT EXERCISE 1  ##

# Using the data frame that you created (or `state_party_Congress`), 
# create a very basic graph like the demos above. Take some time 
# to play around with the possible graphs in ggplot. The goal 
# is to get you to feel comfortable with the data and the plot layers.



# GGPLOT EXERCISE 2  ##

# Using the plot that you created in the previous exercise, 
# do the following

# 1. Add a title, x and y axis labels



# 2. Edit the legend to fit your graph


# 3. Change the theme


# For Reference, here is the demo code:

ggplot(state_party_Congress, aes(x = pctCongAppv, y = pctPresAppv, group = pid3))+
  geom_point(color = 'blue')+
  geom_point(aes(color = pid3))+
  xlab("Approval of Congress")+
  ylab("Approval of President Trump")+
  ggtitle("Approval of American Institutions")+
  scale_color_manual(
    name = "Party",
    breaks = c("Republican", "Democrat", "Independent"),
    values = c("Republican" = "red", "Democrat" = "blue", "Independent" = "grey50")
  )+
  theme_bw()+
  theme(
    legend.position = 'bottom'
  )+
  facet_grid(~region)

# *********************************************************************
# DATE DEMOS ###########
# *********************************************************************

# There are no exercises for the dates discussion, bit here are the 
# code used in the slides

library(lubridate)

Hour <- CCES_2018 %>% 
  mutate(
    hour = hour(starttime)
  ) %>% 
  group_by(hour) %>% 
  summarise(
    n = n(),
    .groups = 'keep'
  )

ggplot(Hour, aes(x = hour, y = n))+
  geom_line()

# *********************************************************************
# MAP EXERCISES ###########
# *********************************************************************

# Load Map packages

library(tigris)
library(sf)

# MAPS EXERCISE 1 ##

# The CCES has data for respondents from nearly every state.

# Pick a state (not Illinois) and do the following:

# 1. Get the state's county shape files with `tigris`.
# DEMO: IL_county <- counties("Illinois", cb = TRUE)




# 2. Adopt the following code to your state to find 
# the number of people who respond to the CCES by county, 
# identified with `countyfips`
# IL <- CCES_2018 %>% filter(state == "IL") %>% 
#   group_by(countyfips) %>% 
#   summarise(
#     n = n(),
#     .groups = 'keep'
#   ) 



# MAPS EXERCISE 2 ##

# Take the mapping code and adjust it to your data
# Refer to the demo below: 

IL_county <- counties("Illinois", cb = TRUE)

IL <- CCES_2018 %>% 
  filter(state == "IL") %>% 
  group_by(countyfips) %>% 
  summarise(
    n = n(),
    .groups = 'keep'
  ) 

IL_respondents <- left_join(
  IL_county,
  IL,
  by = c("GEOID" = "countyfips")
) %>% 
  mutate(
    respondents = ifelse(is.na(n), 0, n)
  )

ggplot()+
  geom_sf(data = IL_respondents, aes(fill = respondents))+
  scale_fill_gradient(
    low = "gray100",
    high = "gray0",
    na.value = "black", 
    limits   = c(0, 100)
  )+
  theme_void()

# While you are at it, add a title and see what happens 
# when you change the limits under `scale_fill_gradient()`









