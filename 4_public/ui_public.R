data <- read.csv("4_public/data/geocoded_.csv", row.names = NULL, stringsAsFactors = FALSE, sep = ",")

public_ui <- fluidPage(
  titlePanel("Select Region and City to View on Map"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_region", "Select Region:", choices = c("All", unique(data$state))),
      selectInput("selected_city", "Select City:", choices = NULL)
    ),
    mainPanel(
      leafletOutput("public_map")
    )
  )
)
