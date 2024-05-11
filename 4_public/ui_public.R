# UI for Public page
public_ui <- fluidPage(
  titlePanel("Public"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      leafletOutput("public_map")  # Change from plotOutput to leafletOutput
    )
  )
)