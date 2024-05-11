# Server logic for Countries page
countries_server <- function(input, output) {
  output$countries_plot <- renderPlot({
    # Generate a mock plot for Countries
    plot(1:10, type = "o", col = "green", xlab = "X-axis", ylab = "Y-axis", main = "Countries")
  })
}
