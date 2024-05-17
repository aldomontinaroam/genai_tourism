# Install and load the plotly package
library(plotly)

# Create the data frame
data <- data.frame(
  Capability = c("Intuitive user experience", "Access to user review data",
                 "Robust security/data privacy protections", "Ability to book vacation packages",
                 "Ability to search for pricing/pay in cash or loyalty currency",
                 "Ability to integrate with loyalty programs", "Ability to book all trip elements in one place",
                 "Comparative pricing"),
  Percentage = c(17, 21, 23, 32, 40, 41, 50, 76)
)

# Order the data frame by Percentage in descending order
data <- data[order(data$Percentage, decreasing = TRUE), ]

# Convert Capability to a factor to retain the order in the plot
data$Capability <- factor(data$Capability, levels = data$Capability)

# Define colors: darker color for the highest percentage, lighter for the rest
colors <- ifelse(data$Percentage == max(data$Percentage), "rgba(31, 119, 180, 1)", "rgba(31, 119, 180, 0.6)")

# Create the bar chart
plot_ly(data, x = ~Percentage, y = ~Capability, type = "bar", orientation = "h",
        marker = list(color = colors)) %>%
  layout(title = "Relative importance of Generative AI capabilities",
         xaxis = list(title = "% of leisure travelers who ranked capability top 3 in importance*"),
         yaxis = list(title = NULL),
         barmode = "stack")
