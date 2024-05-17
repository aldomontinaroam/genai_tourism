# UI for Countries page
countries_ui <- fluidPage(
  titlePanel("Countries"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Countries Plot",
                 plotOutput("countries_plot")),
        tabPanel("Analysis Output",
                 selectInput("analysis", "Choose Analysis:",
                             choices = c("Trend and Legal Status Analysis", "Text Analysis"),
                             selected = "Trend and Legal Status Analysis"),
                 uiOutput("plot_output"))
      )
    )
  )
)
