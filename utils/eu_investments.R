# Load required packages
library(shiny)
library(plotly)

# Define UI
ui <- fluidPage(
  titlePanel("Private Investment in AI by Country, 2023"),
  plotlyOutput("barPlot")
)

# Define server
server <- function(input, output) {
  
  # Create data frame
  data <- data.frame(
    Country = c("United Kingdom", "Germany", "Sweden", 
                "France", "Canada", "Israel", "Spain"),
    Value = c(3.5, 1.8, 1.8, 1.6, 1.5, 1.4, 0.4)
  )
  
  # Create vector of colors for bars
  bar_colors <- ifelse(data$Country == "United Kingdom", "#00a6a6", "#bbdef0")
  
  # Create bar plot
  output$investments <- renderPlotly({
    plot_ly(data, x = ~Value, y = ~Country, type = "bar", orientation = 'h', 
            marker = list(color = bar_colors)) %>%
      layout(title = NULL,
             xaxis = list(title = "Value (€ billion)"),
             yaxis = list(title = "Country", categoryorder = "array", categoryarray = rev(data$Country)))
  })
  
}

# Run the app
shinyApp(ui = ui, server = server)
