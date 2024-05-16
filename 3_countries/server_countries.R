# Server logic for Countries page
countries_server <- function(input, output) {
  output$countries_plot <- renderPlot({
    # Data
    data <- data.frame(
      Country = c("Germany", "Austria", "Netherlands", "Portugal", "Nordics", "Greece", "France", "Italy", "Spain"),
      Already_using_AI = c(20, 19, 17, 15, 10, 9, 8, 8, 4),
      Planning_to_use_AI_in_6_months = c(12, 10, 16, 16, 14, 15, 14, 18, 23),
      Not_planning_to_use_AI = c(66, 70, 66, 66, 74, 75, 76, 74, 74)
    )
    
    # Convert to long format
    data_long <- melt(data, id.vars = "Country")
    
    # Reorder the levels of Country based on the percentage of "Already using AI"
    data_long$Country <- factor(data_long$Country, levels = data$Country[order(data$Already_using_AI)])
    
    # Plot
    ggplot(data_long, aes(x = value, y = Country, fill = variable)) +
      geom_bar(stat = "identity", position = "fill") +
      geom_text(aes(label = paste0(value, "%")), position = position_fill(vjust = 0.5), size = 3) +
      scale_fill_manual(values = c("#00a6a6", "#bbdef0","#f49f0a"),
                        name = "Legend",
                        labels = c("Yes, we already use AI", "Not yet, but we plan to use AI in the next 6 months", "No, we do not currently use or plan to use AI", "Don't know")) +
      labs(x = "Country", y = "Percentage", title = "Current use of AI/planned use of AI in the next 6 months") +
      theme_minimal() +
      theme(legend.position = "bottom",
            axis.text.x = element_text(angle = 45, hjust = 1))
  })
}
