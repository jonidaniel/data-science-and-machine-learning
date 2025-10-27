# title: "Water Quality at Sydney Beaches – Tidy Tuesday 2025/05/20"
# author: "Joni Mäkinen"
# date: "2025-10-26"

# Data analysis on Sydney's beaches' water qualities. Inspired by Tidy Tuesday's publication from May 20, 2025.

# Beachwatch's water quality data will be used as base data for this analysis.
# The data contains water quality measurement results from 79 different beaches in Sydney area since 1991 until present day. There are over 123 thousand data points in total.

# When exploring the data, I found two interesting relationships and decided to focus on them:
# by comparing water qualities of all Sydney beaches (part 1)
# by examining overall water quality of Sydney beaches year by year (part 2)

# Separate bar plots will be drawn for both relationships:
# Water Quality Comparison of Sydney Beaches (1991–present) (part 1)
# Overall Water Quality of Sydney Beaches (1993–present) (part 2)

# The goal is to produce two descriptive charts, one for either relationship. One should be able to easily identify beaches with the lowest and highest water qualities, and also see overall Sydney water quality progressions over time.



### Install packages

# Install packages if required
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("ggthemes")) install.packages("ggthemes")
if (!require("tidytuesdayR")) install.packages("tidytuesdayR")



### Import packages and load data

# Import packages
library(ggplot2)
library(dplyr)
library(ggthemes)

# Load Water Quality at Sydney Beaches data from Tidy Tuesday (orig. Beachwatch)
tuesdata <- tidytuesdayR::tt_load("2025-05-20")

# Set one of the tuesdata tibbles (data frames) into a variable
water_quality <- tuesdata$water_quality



##### PART 1: Compare water qualities of all Sydney beaches

### Start by wrangling the data

# Initiate vectors where mean bacteria concentrations by beach and observations counts by beach will be gathered
concentrations_by_beach <- c()
observations_counts <- c()

# Gather all 79 beaches
beaches <- unique(water_quality$swim_site)

# Iterate over all beaches
for (beach in beaches) {
  # Gather all observations (rows) of a beach
  observations <- water_quality[water_quality$swim_site == beach,]
  # Calculate mean bacteria concentration for the beach (omit NA values)
  enterococci_cfu_100ml_mean <- mean(observations$enterococci_cfu_100ml, na.rm = TRUE)
  # Append the mean bacteria concentration and observations count to respective vectors
  concentrations_by_beach <- c(concentrations_by_beach, enterococci_cfu_100ml_mean)
  observations_counts <- c(observations_counts, count(observations))
}



### Then, form a data frame to be plotted

# Form a data frame from beaches, and from their mean bacteria concentrations and observation counts (i.e. measurement counts)
beaches_df <- data.frame(beach = beaches,
                         concentration = concentrations_by_beach,
                         count = observations_counts)

# Order the data frame by its concentration column
beaches_df <- arrange(beaches_df, desc(concentration))
# Alter the concentration column (from character to factor)
beaches_df <- mutate(beaches_df, beach = factor(beach, levels = beach))



### Finally, plot the data frame as a bar chart

# Plot a ggplot2 chart displaying water quality by beach in Sydney
beaches_df %>%
  ggplot(aes(x = beach, y = concentration)) +
  # Use a bar chart
  # Skip y aggregation by defining stat as "identity" (i.e. you'll provide y values)
  geom_bar(stat = "identity") +
  # Use a theme from ggthemes
  theme_fivethirtyeight() +
  # The previous theme disables axis titles, restore them
  # Also set x axis texts as vertical
  theme(axis.title = element_text(),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  # Set labels
  labs(title = "Water Quality Comparison of Sydney Beaches (1991–present)",
       subtitle = "Mean bacteria concentration for each beach",
       x = "Location",
       y = "Mean enterococci concentration (CFU/100 ml)")



##### PART 2: Examine overall water quality of Sydney beaches year by year

### Start by wrangling the data

# Initiate vectors where overall mean bacteria concentration and dates of a year counts by beach will be gathered
concentration_overall <- c()
years_counts <- c()

# Create a data frame from dates and bacteria concentrations
df <- data.frame(date = water_quality$date,
                 concentration = water_quality$enterococci_cfu_100ml)

# Trim last 6 characters from all dates
dates_modified <- gsub('.{6}$', '', df$date)
# Gather all unique years (1991–present)
unique_years <- unique(dates_modified)

# Remove invalid years with too few data points
unique_years_modified <- c()
for (i in unique_years) {
  if (!(i == "1991" | i == "1992")) {
    unique_years_modified <- c(unique_years_modified, i)
  } 
}

# Iterate over the years
for (year in unique_years_modified) {
  # Gather data of a year
  data_of_year <- df %>%
    filter(between(date, as.Date(paste0(year, "-01-01")), as.Date(paste0(year, "-12-31"))))
  # Calculate mean bacteria concentration of a year
  mean_of_year <- mean(data_of_year$concentration, na.rm = TRUE)
  # Append the mean bacteria concentration and data of a year count to respective vectors
  concentration_overall <- c(concentration_overall, mean_of_year)
  years_counts <- c(years_counts, count(data_of_year))
}



### Then, form a data frame to be plotted

# Form a data frame from unique years and overall mean bacteria concentrations of those years
years_df <- data.frame(year = unique_years_modified,
                       mean_concentration = concentration_overall)



### Finally, plot the data frame as a bar chart

# Plot a ggplot2 chart displaying combined water quality at Sydney beaches
years_df %>%
  ggplot(aes(x = year, y = mean_concentration)) +
  # Use a bar chart
  # Skip y aggregation by defining stat as "identity" (i.e. you'll provide y values)
  geom_bar(stat = "identity") +
  # Use a theme from ggthemes
  theme_fivethirtyeight() +
  # The previous theme disables axis titles, restore them
  # Also set x axis texts as vertical
  theme(axis.title = element_text(),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  # Set labels
  labs(title = "Overall Water Quality of Sydney Beaches (1993–present)",
       subtitle = "Yearly mean bacteria concentration, all beaches included",
       x = "Year",
       y = "Mean enterococci concentration (CFU/100 ml)")



##### RESULTS

# Descriptive bar charts were successfully produced in both parts of the analysis.
# Here I take the opportunity to evaluate the validity and reliability of both bar charts.

# A couple points of interest arose during the analysis:
# Some years over the span of the water quality measurement history had very few data points,
# which decreased the scientific validity of using those time periods in an analysis.
# Also, some beach locations had so few measurements taken over the years,
# so that their mean bacteria concentration values weren't as reliable as I would've wanted.
# Some of these caveats I dealt with by omitting them from the analysis altogether,
# some of them I decided to include – and will discuss about them in a moment.

### Part 1:

# From the first chart (Water Quality Comparison of Sydney Beaches (1991–present)),
# we can easily identify the beaches with the lowest water quality (Tambourine Bay, Woolwich Baths, Woodford Bay)
# and the highest water quality (Whale Beach, Turimetta Beach, Avalon Beach) for the measurement period.
# The results are acceptable and somewhat valid and reliable since the data point counts for each beach weren't at least exceptionally low,
# each of them falling between 51–2508.
# 5 of the lowest water quality beaches had 124, 1538, 1553, 1378, and 123 data points,
# and 5 of the highest water quality beaches had 787, 968, 803, 110, and 183 data points.
# So the beaches in both extremes have at least a hundred data points each.
# One could argue that some of the beaches should've been omitted from the analysis due to lack of reliability,
# but I decided not to do it. I still try to present this matter as transparently as I can.

### Here are the numbers of water quality measurements for each beach location:
# Plot a ggplot2 chart displaying water quality by beach in Sydney
beaches_df %>%
  ggplot(aes(x = beach, y = concentration)) +
  # Use a bar chart
  # Skip y aggregation by defining stat as "identity" (i.e. you'll provide y values)
  geom_bar(stat = "identity") +
  # Add measurement counts to bars' tips
  geom_text(aes(label = observations_counts), angle = 90, hjust = 0.5, vjust = 0.5) +
  # Use a theme from ggthemes
  theme_fivethirtyeight() +
  # Set x axis texts as vertical, also remove y axis title, text, and ticks
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  # Set title and subtitle
  labs(title = "Water Quality Comparison of Sydney Beaches (1991–present)",
       subtitle = "Number of water quality measurements for each beach")

### Part 2:

# The second chart (Overall Water Quality of Sydney Beaches (1993–present))
# fulfills its purpose also as it clearly demonstrates the progressions on Sydney's overall water quality over the decades.
# Throughout the measurement history, the mean enterococci concentrations have stayed at around 25–150 CFU/100 ml,
# with few exceptions in the late 1990's when it was higher – the most eye-catching value being the huge spike in 1998,
# when the value was over 1100 CFU/100 ml.
# In general, the 1990's seem to have slightly higher measurement results than the 2000's, 2010's, or 2020's.

### Here are the yearly numbers of water quality measurements:
# Plot a ggplot2 chart displaying combined water quality at Sydney beaches
years_df %>%
  ggplot(aes(x = year, y = concentration_overall)) +
  # Use a bar chart
  # Skip y aggregation by defining stat as "identity" (i.e. you'll provide y values)
  geom_bar(stat = "identity") +
  # Add measurement counts to bars' tips
  geom_text(aes(label = years_counts), angle = 90, hjust = 0.5, vjust = 0.5) +
  # Use a theme from ggthemes
  theme_fivethirtyeight() +
  # The previous theme disables axis titles, restore them
  # Set x axis texts as vertical, also remove y axis title, text, and ticks
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  # Set title and subtitle
  labs(title = "Overall Water Quality of Sydney Beaches (1993–present)",
       subtitle = "Number of water quality measurements for each year")

# I made the decision to remove some data from the used dataset during wrangling:
# years 1991 and 1992 had so few data points (only 2 in total) that I didn't consider them as valid to be used in the analysis.
# The results are valid and reliable since the data point counts were high for every year that was examined,
# including the spike of 1998, falling between 1288–6234.

### The analysis' goal of producing two descriptive charts was completely satisfied.
