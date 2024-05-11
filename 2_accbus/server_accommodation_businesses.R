# Server logic for Accommodation Businesses page
accommodation_businesses_server <- function(input, output) {
  output$accommodation_businesses_plot <- renderPlot({
    # Generate a mock plot for Accommodation Businesses
    plot(1:10, type = "o", col = "red", xlab = "X-axis", ylab = "Y-axis", main = "Accommodation Businesses")
  })
}
