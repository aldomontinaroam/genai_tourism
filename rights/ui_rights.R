# UI for Rights page
rights_ui <- fluidPage(
  titlePanel("Rights"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("rights_plot")
    )
  )
)
