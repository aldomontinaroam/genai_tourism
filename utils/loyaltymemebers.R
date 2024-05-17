# Load required library
library(ggplot2)

# Define data frames
data1 <- data.frame(
  Satisfaction = c("Very dissatisfied", "Dissatisfied", "Neutral", "Satisfied", "Very satisfied"),
  Satisfaction_Percentage = c(2, 1, 11, 41, 46)
)

data2 <- data.frame(
  Recommendations_Booked = c("None of its recommendations", "A minority of its recommendations", "Neutral", "Most of its recommendations", "All of its recommendations"),
  Recommendations_Percentage = c(5, 5, 27, 35, 29)
)

# Define order of categories
satisfaction_order <- c("Very dissatisfied", "Dissatisfied", "Neutral", "Satisfied", "Very satisfied")
recommendations_order <- c("None of its recommendations", "A minority of its recommendations", "Neutral", "Most of its recommendations", "All of its recommendations")

# Convert Satisfaction and Recommendations_Booked to factor with defined order
data1$Satisfaction <- factor(data1$Satisfaction, levels = satisfaction_order)
data2$Recommendations_Booked <- factor(data2$Recommendations_Booked, levels = recommendations_order)

# Find the highest percentage for each plot
max_satisfaction <- max(data1$Satisfaction_Percentage)
max_recommendations <- max(data2$Recommendations_Percentage)

# Plot for Satisfaction
plot_satisfaction <- ggplot(data1, aes(x = Satisfaction_Percentage, y = Satisfaction)) +
  geom_bar(stat = "identity", fill = ifelse(data1$Satisfaction_Percentage == max_satisfaction, "#00a6a6", "#bbdef0")) +
  labs(title = "Satisfaction",
       x = "Percentage") +
  theme_minimal() + 
  theme(axis.line = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

# Plot for Recommendations
plot_recommendations <- ggplot(data2, aes(x = Recommendations_Percentage, y = Recommendations_Booked)) +
  geom_bar(stat = "identity", fill = ifelse(data2$Recommendations_Percentage == max_recommendations, "#f49f0a", "#efca08")) +
  labs(title = "Recommendations",
       x = "Percentage") +
  theme_minimal() + 
  theme(axis.line = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

# Display plots
plot_satisfaction
plot_recommendations
