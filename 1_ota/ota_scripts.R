library(tidyverse)



ota_commissions <- data.frame(
  scenario = c(1, 2, 3, 1, 2, 3),
  year = c(2025, 2025, 2025, 2028, 2028, 2028),
  value = c(346, 210, 84, 1388, 664, -190)
)
view(ota_commissions)

ota_commissions <- read_csv("1_ota/data/ota_commissions_tidy.csv")
ggplot(ota_commissions, aes(x = year, y = value, color = factor(scenario))) +
  geom_line() +
  labs(x = "Year", y = "Value", title = "Scenarios Over Time") +
  scale_color_manual(values = c("red", "blue", "green", "purple")) # optional: custom color palette

# Create a dataframe from the provided data
data <- data.frame(
  scenario = c(1, 2, 3),  # Scenarios
  year_2025 = c(346, 210, 84),  # Values for 2025
  year_2028 = c(1388, 664, -190)  # Values for 2028
)

# Print the dataframe
print(data)

# Load the tidyr package
library(tidyr)

# Reshape the data into a tidy format
tidy_data <- gather(data, key = "year", value = "value", -scenario)

# Print the tidy dataframe
print(tidy_data)

write.csv(ota_commissions, file = paste0("1_ota/data/", "ota_commissions_tidy.csv"), row.names = FALSE)


ota_revenue <- read_csv("1_ota/data/ota_revenue.csv")
View(ota_revenue)

# Load the required packages
library(tidyr)
library(dplyr)

# Assuming your data is in a data frame called 'data'
ota_revenue_tidy <- data.frame(
  company = c("Booking Holdings", "Expedia Group", "Airbnb", "Trip.com Group", "Tripadvisor", "eDreams Odigeo¹", "Despegar", "Trivago", "MakeMyTrip¹", "Lastminute.com Group", "On the Beach Group"),
  X2019 = c(15.066, 12.067, 4.805, 5.129, 1.560, 633, 525, 942, 527, 392, 194),
  X2020 = c(6.796, 5.199, 3.378, 2.809, 604, 241, 131, 304, 189, 128, 97),
  X2021 = c(10.958, 8.598, 5.992, 3.143, 902, 334, 323, 412, 295, 163, 42),
  X2022 = c(17.090, 11.667, 8.399, 2.909, 1.492, 577, 538, 574, 533, 316, 174)
)

# Reshape the data into tidy format
ota_revenue_tidy <- ota_revenue_tidy %>%
  pivot_longer(cols = starts_with("X"), names_to = "year", values_to = "value") %>%
  mutate(year = substring(year, 2))

# Display the tidy data
view(ota_revenue_tidy)
write.csv(ota_revenue_tidy, file=paste0("1_ota/data/", "ota_revenue_tidy.csv"), row.names = FALSE)




####

season <- c("Autunno 2022", "Estate 2023", "Autunno 2023", "Media UE (autunno 2023)")
less <- c(18, 16, 6, 9)
same <- c(55, 53, 80, 78)
more <- c(28, 29, 11, 12)
not_sure <- c(0, 3, 3, 2)

library(ggplot2)
library(dplyr)
library(scales)

# Create a data frame
data <- data.frame(season, less, same, more, not_sure)

# Reshape the data from wide to long format
data_long <- pivot_longer(data, cols = c("less", "same", "more", "not_sure"), 
                          names_to = "intention", values_to = "value")

# Plot the data



library(dplyr)
library(tidyr)

tidy_data <- data.frame(
  season = rep(c("Autunno 2022", "Estate 2023", "Autunno 2023", "Media UE (autunno 2023)"), each = 4),
  intention = rep(c("less", "same", "more", "not_sure"), times = 4),
  value = c(18, 55, 28, 0, 16, 53, 29, 3, 6, 80, 11, 3, 9, 78, 12, 2)
)

# Write the tidy data to a CSV file
write.csv(tidy_data, file=paste0("2_accbus/data/", "ts_digital_investments.csv"), row.names = FALSE)
write.csv(tidy_data, file = "", row.names = FALSE)

ggplot(data, aes(x = season, y = value, fill = intention)) +
  geom_col(position = "fill") +
  geom_text(aes(label = value), 
            position = position_fill(vjust = 0.5), size = 3) +
  scale_fill_manual(values = c("#0072B2", "#D55E00", "#CC79A7", "#999999"),
                    labels = c("Intenzione di investire di meno rispetto agli ultimi 6 mesi",
                               "Intenzione di investire circa lo stesso",
                               "Intenzione di investire di più rispetto agli ultimi 6 mesi",
                               "Non so"),
                    name = "Piani di investimento nella trasformazione digitale per i prossimi 6 mesi") +
  scale_y_continuous(labels = percent_format()) +
  labs(x = NULL, y = NULL, title = "Piani di investimento nella trasformazione digitale per i prossimi 6 mesi") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.y = element_text(size = 10),
        legend.position = "bottom",
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 8))


data <- tidy_data

# Swap "Estate 2023" with "Autunno 2023"
data$season <- ifelse(data$season == "Estate 2023", "Autunno 2023", data$season)

# Calculate percentages within each season
data <- data %>%
  group_by(season) %>%
  mutate(percent = value / sum(value) * 100) %>%
  ungroup()

# Plot
ggplot(data, aes(x = intention, y = percent, fill = intention)) +
  geom_bar(stat = "identity") +
  facet_wrap(~season, nrow = 1) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(x = "Intention", y = "Percentage", fill = "Intention") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Investment Plans in Digital Transformation")

library(ggplot2)
library(dplyr)
library(tidyr)

# Your data
data <- data.frame(
  season = c("Autunno 2022", "Autunno 2022", "Autunno 2022", "Autunno 2022", 
             "Estate 2023", "Estate 2023", "Estate 2023", "Estate 2023", 
             "Autunno 2023", "Autunno 2023", "Autunno 2023", "Autunno 2023", 
             "Media UE (autunno 2023)", "Media UE (autunno 2023)", "Media UE (autunno 2023)", "Media UE (autunno 2023)"),
  intention = c("less", "same", "more", "not_sure", "less", "same", "more", "not_sure",
                "less", "same", "more", "not_sure", "less", "same", "more", "not_sure"),
  value = c(18, 55, 28, 0, 16, 53, 29, 3, 6, 80, 11, 3, 9, 78, 12, 2)
)

# Swap "Estate 2023" with "Autunno 2023"
data$season <- ifelse(data$season == "Estate 2023", "temp", data$season)
data$season <- ifelse(data$season == "Autunno 2023", "Estate 2023", data$season)
data$season <- ifelse(data$season == "temp", "Autunno 2023", data$season)

# Calculate percentages within each season
data <- data %>%
  group_by(season) %>%
  mutate(percent = value / sum(value) * 100) %>%
  ungroup()

# Reorder the seasons
data$season <- factor(data$season, levels = c("Autunno 2022", "Estate 2023", "Autunno 2023", "Media UE (autunno 2023)"))

# Pivot data to wide format
data_wide <- pivot_wider(data, names_from = season, values_from = percent)

# Plot



ggplot(data, aes(x = season, y=value, fill=intention)) +
  geom_bar(position = "fill", stat = "identity") +
  geom_text(aes(label = value)) +
  scale_fill_manual(values = c("#0072B2", "#D55E00", "#CC79A7", "#999999")) +
  labs(x = "Intention", y = "Percentage", fill = "Season") +
  theme_minimal() +
  ggtitle("Investment Plans in Digital Transformation")

####################


data <- read_csv("2_accbus/data/acc_bus_ai_interest.csv")

data <- data %>%
  arrange(value) %>%
  mutate(intention = factor(intention, levels=c("use", "planned", "no", "not_know"))) %>%
  mutate(season = factor(season, levels=c("Summer 2023", "Autumn 2023", "Average EU (Autumn 2023)")))


write.csv(data, file = paste0("2_accbus/data/", "acc_bus_digital_investments.csv"), row.names = FALSE)

view(data)



  ggplot(data, aes(x = season, y = value, fill = intention)) +
  geom_col(position="fill") +
  geom_text(aes(label = value), 
            position = position_fill(vjust = 0.5), size = 3) +
  scale_fill_manual(values = c("#0072B2", "#D55E00", "#CC79A7", "#999999"),
                    labels = c("use",
                               "planned",
                               "no",
                               "not_know"),
                    name = "Piani di investimento in AI") +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "Piani di investimento") +
  theme_minimal()+
  theme(legend.position = "bottom")

##########
  
  data <- read_csv("2_accbus/data/acc_bus_digital_investments.csv")
  
  ggplot(data, aes(x = season, y = value, fill = intention)) +
    geom_col(position = "fill", color = "black") +
    coord_flip() +
    scale_fill_manual(values = c("not_sure" = "gray", "less" = "red", "more" = "green", "same" = "blue")) +
    labs(title = "Stacked Bar Chart", x = "Season", y = "Percentage", fill = "Intention") +
    theme_minimal()

  library(ggrepel)
  
  ggplot(data, aes(x = intention, y = value, fill = season)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Intention vs. Value by Season",
         x = "Intention",
         y = "Value",
         fill = "Season") +
    theme_minimal() +
    theme(legend.position = "bottom") +
    scale_fill_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c"))

  ######
  
  data <- read_csv("2_accbus/data/accbus_digital_topics.csv")
  
  ggplot(data, aes(x = fct_reorder(topic, value[season == "Italy"], .desc = TRUE), y = value, fill = season)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Most important digital trasformation topics",
         x = "Topics",
         y = "Italy vs EU",
         fill = "Season") +
    coord_flip() +
    theme_minimal() +
    theme(legend.position = "top") +
    scale_fill_manual(values = c("#1f77b4", "#ff7f0e"))



####
  
  italian_ta <- read.csv("1_ota/data/italy_ta_istat.csv")
  
  ggplot(italian_ta, aes(x = as.factor(year), y = value, fill = select)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(x = "Year", y = "Value", fill = "Select") +
    theme_minimal() +
    theme(legend.position = "bottom")
  
  ###
  
  library(ggplot2)
  library(dplyr)
  
  # Sample data
  use_genai <- data.frame(
    answer = c("Yes", "No"),
    value = c(40, 60)
  )
  
  # Customizable color palette
  custom_palette <- c("#66c2a5", "#fc8d62")
  
  # Plot
  ggplot(use_genai, aes(x=answer, y=value, fill=answer)) +
    geom_col(stat="identity", width=0.8, color="black") +
    coord_flip() +
    scale_fill_manual(values=custom_palette) +
    labs(x = "", y = "", title = "Recently used Generative AI for travel inspiration, planning, or booking") +
    ggtitle("Share of leisure travelers who recently used generative artificial intelligence (AI) for travel inspiration, planning, or booking in the United States and Canada as of August 2023") +
    theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
      plot.subtitle = element_text(hjust = 0.5, size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.text.y = element_text(face = "bold"),
      legend.position = "none",
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank()
    ) +
    geom_text(aes(label = paste0(value, "%")), position = position_stack(vjust = 0.5), size = 5, color = "white")
  
  
  
  
  
  
  
  
  
  
  


