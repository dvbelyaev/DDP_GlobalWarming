# Source: https://www.kaggle.com/berkeleyearth/climate-change-earth-surface-temperature-data

library(lubridate)
library(dplyr)

# Data loading and NA removing
data_raw <- read.csv("./GlobalLandTemperatures/GlobalLandTemperaturesByCountry.csv")
data_raw <- na.omit(data_raw)

# Calculating average temperatire by country-year
data_raw$Year <- year(as.Date(data_raw$dt, "%Y-%m-%d"))

data <- data_raw %>%
        group_by(Country, Year) %>%
        summarise(avgTemp = mean(AverageTemperature))

# Writing tidy data
write.csv(data, "./GlobalWarming/data/TemperaturesByCountry.csv")
