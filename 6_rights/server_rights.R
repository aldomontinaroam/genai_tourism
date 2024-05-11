# Server logic for Rights page
rights_server <- function(input, output) {
  output$rights_plot <- renderPlot({
    # Generate a mock plot for Rights
    plot(1:10, type = "o", col = "brown", xlab = "X-axis", ylab = "Y-axis", main = "Rights")
  })
}
