# Install plotly package if not installed
# install.packages("plotly")
library(plotly)

# Create data frame
data <- data.frame(
  Company = c("ASAPP", "Moveworks", "Poe by Quora", "Observe.ai", "Ada", "Cresta", "Woebot Health", "Forethought", "Ushur", "Kasisto"),
  Funding = c(380, 305, 226, 214, 190.6, 151, 123.3, 92, 92, 81.5)
)

# Sort data frame by Funding in descending order
data <- data[order(data$Funding), ]

# Darken the longest bar
max_funding <- max(data$Funding)
colors <- ifelse(data$Funding == max_funding, "#000000", "#636EFA")

# Create bar chart with plotly
fig <- plot_ly(data, y = factor(data$Company, levels = data$Company), x = ~Funding, type = "bar", marker = list(color = colors))
fig <- fig %>% layout(yaxis = list(tickangle = -45, tickfont = list(size = 10)), xaxis = list(title = "Funding in million U.S. dollars"))

# Display chart
fig
