library(plotly)
library(dplyr)

# Create the data frame
data <- data.frame(
  Capability = c("Simplified building/facility repairs or extensions via intelligent infrastructure (pipes, power lines) documentation",
                 "Predictive utilization planning (e.g., for F&B outlets and spaces)",
                 "Predictive materials procurement",
                 "Predictive staff allocation/human resources planning via intelligent forecasting",
                 "Automated room assignment (e.g. to avoid extensive wear of inventory, to avoid early renovations)",
                 "Maintenance cost reduction via predictive techniques",
                 "Predictive modeling for environmental protection using energy, water, and waste-monitoring tools"),
  Percentage = c(60, 64, 67, 67, 72, 76, 77)
)

# Reorder the rows based on Percentage
data <- data %>%
  mutate(Capability = reorder(Capability, Percentage))

# Create the color vector
colors <- ifelse(data$Percentage == max(data$Percentage), "#1F77B4", "#CCCCCC")

# Create the bar chart with labels on bars
plot_ly(data, x = ~Percentage, y = ~Capability, type = "bar", orientation = "h", 
        marker = list(color = colors, line = list(color = '#FFFFFF', width = 0.5), 
                      line = list(width = 1, color = "#FFFFFF"),
                      text = paste(data$Percentage, "%")), 
        textposition = "outside") %>%
  layout(title = "Predictive modeling for environmental protection using energy, water, and waste-monitoring tools",
         xaxis = list(title = "Share of respondents"),
         yaxis = list(title = NULL),
         barmode = "stack")
