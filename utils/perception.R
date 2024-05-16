# Load the required package
library(ggplot2)
library(reshape2)

# Create the data frame
perceived_impact <- data.frame(
  Task = c("Marketing content personalization", "Content creation", "Camping creation and optimization",
           "Data analysis and interpretation", "Predictive analysis and forecasting", "Creative media",
           "Conversational marketing", "Web, app, and platform creation"),
  N.A = c(3, 4, 4, 5, 5, 5, 8, 9),
  LittleImpact = c(16, 13, 20, 12, 14, 24, 22, 24),
  SomeImpact = c(44, 34, 47, 43, 41, 46, 41, 42),
  HighImpact = c(37, 49, 29, 38, 40, 25, 29, 25)
)

# Melt the data frame
data_melted <- melt(perceived_impact, id.vars = "Task")

# Create the plot
ggplot(data_melted, aes(x = Task, y = value, fill = variable, label = scales::percent(value/100))) +
  geom_bar(stat = "identity", position = "stack") +
  geom_text(position = position_stack(vjust = 0.5)) +
  labs(x = "", y = "Share of respondents") +
  coord_flip() +
  scale_fill_manual(name = "", values = c("N.A" = "#bbdef0", "LittleImpact" = "#efca08", "SomeImpact" = "#00a6a6", "HighImpact" = "#f08700")) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal() +
  theme(legend.position = "bottom",
        panel.grid.major.y = element_blank(),
        axis.text.y = element_text(size = 10),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size = 12, margin = margin(r = 15)))
