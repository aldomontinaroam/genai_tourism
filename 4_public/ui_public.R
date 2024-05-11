data <- read.csv("4_public/data/geocoded_.csv", row.names = NULL, stringsAsFactors = FALSE, sep = ",")

public_ui <- fluidPage(
  titlePanel("Can Destination Management Organizations (DMO) use Generative AI to improve efficacy in attracting tourists?"),
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "input.tabs == 'Map'",  # Change 'map' to 'Map'
        selectInput("selected_region", "Select Region:", choices = c("All", unique(data$state))),
        selectInput("selected_city", "Select City:", choices = NULL)
      )
    ),
    mainPanel(
      tabsetPanel(
        id = "tabs",  # Add id to tabsetPanel
        tabPanel("Map", leafletOutput("public_map")),
        tabPanel("Word Clouds",
                 fluidRow(
                   column(width = 6, plotOutput("word_cloud1")),
                   column(width = 6, plotOutput("word_cloud2"))
                 )
        ),
        tabPanel("Bar Plots",
                 fluidRow(
                   column(width = 6, plotOutput("bar_plot1")),
                   column(width = 6, plotOutput("bar_plot2"))
                 )
        )
      )
    )
  )
)

