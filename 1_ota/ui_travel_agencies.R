# UI for Travel Agencies page
travel_agencies_ui <- fluidPage(
  titlePanel("Travel Agencies"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("travel_agencies_plot")
    )
  )
)
