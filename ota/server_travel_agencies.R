# Server logic for Travel Agencies page
travel_agencies_server <- function(input, output) {
  output$travel_agencies_plot <- renderPlot({
    # Generate a mock plot for Travel Agencies
    plot(1:10, type = "o", col = "blue", xlab = "X-axis", ylab = "Y-axis", main = "Travel Agencies")
  })
}
