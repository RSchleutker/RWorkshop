## =============================================================================
## A descriptive analysis of the SARS-CoV-2 pandemy in 2020
## =============================================================================

library("openxlsx")


# ------------------------------------------------------------------------------
# The data consists of CSV file. Each gives a daily report of the number of
# infections, deaths, and so on. They will be read in in the following and
# pre-processed to a single data frame.
# ------------------------------------------------------------------------------

# Read single date from file.
data_20200318 <- read.csv("./data/raw/03-18-2020.csv", stringsAsFactors = FALSE)

# Convert Last.Update column from string to date. Daytime is dropped.
data_20200318$Last.Update <- as.Date(data_20200318$Last.Update, "%Y-%m-%d")

# Sum cases for all regions of one country.
sum_country <- aggregate(
  cbind(Confirmed, Deaths, Recovered) ~ Country.Region,
  data = data_20200318,
  sum
)

# Select the latest date of update of all regions of one country as the date of
# last update for the whole country.
update_country <- aggregate(
  Last.Update ~ Country.Region,
  data = data_20200318,
  max
)

# Create final processed data frame and ovwerwrite the raw data.
data_20200318 <- merge(sum_country, update_country)


# ------------------------------------------------------------------------------
# The pre-processed data is written to a file.
# ------------------------------------------------------------------------------

# Write to a CSV file.
write.csv(
  data_20200318,
  "./data/processed/processed_data.csv",
  row.names = FALSE
)

# Write to an Excel file.
write.xlsx(data_20200318, "./data/processed/processed_data.xlsx")
