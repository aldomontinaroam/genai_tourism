# Server logic for Public page
public_server <- function(input, output) {
  output$public_plot <- renderPlot({
    # Generate a mock plot for Public
    plot(1:10, type = "o", col = "purple", xlab = "X-axis", ylab = "Y-axis", main = "Public")
  })
}
