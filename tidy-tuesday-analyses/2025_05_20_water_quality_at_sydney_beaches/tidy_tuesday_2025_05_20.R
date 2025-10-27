# Install needed packages
install.packages("tidyverse")
install.packages("ggthemes")
install.packages("tidytuesdayR")

# Import needed packages
library(ggplot2)
library(dplyr)
library(ggthemes)

# Load Water Quality at Sydney Beaches data
tuesdata <- tidytuesdayR::tt_load('2025-05-20')

# Set them to variables
water_quality <- tuesdata$water_quality
weather <- tuesdata$weather

# Gather all unique beaches in a variable (still a vector)
beaches <- unique(water_quality$swim_site)

# Initiate means and counts vectors
# for mean bacteria concentrations by beach and observations count by beach will be gathered
means <- c()
counts <- c()

# Iterate through all unique beaches
for (beach in beaches) {
  # Gather all observations (rows) of a particular beach
  obs <- water_quality[water_quality$swim_site == beach,]
  # Calculate mean bacteria concentration for that beach (omit NA values)
  enterococci_cfu_100ml_mean <- mean(obs$enterococci_cfu_100ml, na.rm = TRUE)
  # Append the concentration and count to respective vectors
  means <- c(means, enterococci_cfu_100ml_mean)
  counts <- c(counts, count(obs))
}

# Use a helper vector to gather counts again in proper form
helper <- c()
for (i in counts) {
  helper <- c(helper, i)
}

helper

# Form a data frame from beach names, mean bacteria concentrations, and concentration counts
df <- data.frame(beach = beaches,
                concentration = means,
                count = helper)

# Order the data frame by concentration column
df <- arrange(df, desc(concentration))

# Mutate concentration column (from chr to fct)
df <- mutate(df, beach = factor(beach, levels = beach))

# Plot a bar chart
# (i.e. Water Quality by Beach in Sydney (1991–present) graph)
df %>%
  ggplot(aes(x = beach, y = concentration)) +
  geom_bar(stat = "identity") +
  # Use a theme from ggthemes
  theme_fivethirtyeight() +
  # The previous theme disables axis titles, restore them
  theme(axis.title = element_text()) +
  # Set x axis text as vertical
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  # Set labels
  labs(title = "Water Quality by Beach in Sydney (1991–present)",
       subtitle = "Mean bacteria concentration for each beach",
       x = "Location",
       y = "Mean enterococci concentration (CFU/100 ml)")

# Create a data frame out of date column
samples <- data.frame(date = water_quality$date,
                      concentration = water_quality$enterococci_cfu_100ml)

years <- c("1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999",
         "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009",
         "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019",
         "2020", "2021", "2022", "2023", "2024", "2025")
mean_concentration <- c()
for (year in years) {
  # Gather all dates by year
  current_year <- samples %>%
    filter(between(date, as.Date(paste0(year, "-01-01")), as.Date(paste0(year, "-12-31"))))
  # Calculate mean for each year
  mean <- mean(current_year$concentration, na.rm = TRUE)
  # Append to mean_concentration
  mean_concentration <- c(mean_concentration, mean)
}

# Form a data frame
mean_df <- data.frame(year = years,
                      mean_concentration = mean_concentration)

# Plot a bar chart
# (i.e. Water Quality at Sydney Beaches (1991–present) graph)
mean_df %>%
  ggplot(aes(x = year, y = mean_concentration)) +
  #geom_smooth() +
  geom_bar(stat = "identity") +
  # Use a theme from ggthemes
  theme_fivethirtyeight() +
  # The previous theme disables axis titles, restore them
  theme(axis.title = element_text()) +
  # Set x axis text as vertical
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  # Set labels
  labs(title = "Water Quality at Sydney Beaches (1991–present)", subtitle = "Smoothed mean bacteria concentration, all beaches included", x = "Date", y = "Enterococci concentration (CFU/100 ml)")
