# UI for Countries page
countries_ui <- fluidPage(
  titlePanel("Countries"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("countries_plot")
    )
  )
)
