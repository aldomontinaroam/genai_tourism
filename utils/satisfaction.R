library(ggplot2)

# Define the data
satisfaction <- data.frame(
  Category = c("Very dissatisfied", "Dissatisfied", "Neutral", "Satisfied", "Very satisfied"),
  Percentage = c(1, 1, 14, 45, 39)
)

# Find the maximum percentage value
max_percentage <- max(satisfaction$Percentage)

# Create a new column for fill color
satisfaction$Fill <- ifelse(satisfaction$Percentage == max_percentage, "#00a6a6", "#bbdef0")

# Plot
ggplot(satisfaction, aes(x = reorder(Category, -Percentage), y = Percentage, fill = Fill)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +  # Use identity scale for fill
  labs(title = "Satisfaction with Generative AI's recommendation quality",
       subtitle = "% of leisure travelers with prior Generative AI use",
       x = NULL, y = NULL) +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "none",  # Remove legend
        panel.grid.major = element_blank(),  # Remove major gridlines
        panel.grid.minor = element_blank())  # Remove minor gridlines
