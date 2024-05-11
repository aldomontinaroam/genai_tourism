# Server logic for Tourist page
tourist_server <- function(input, output) {
  output$tourist_plot <- renderPlot({
    # Generate a mock plot for Tourist
    plot(1:10, type = "o", col = "orange", xlab = "X-axis", ylab = "Y-axis", main = "Tourist")
  })
}
