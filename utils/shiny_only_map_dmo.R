# Load required libraries
library(shiny)
library(leaflet)

# Read data from CSV file
data <- read.csv("dmo_map_coordinates.csv", row.names=NULL, stringsAsFactors = FALSE, sep=";")

# Split coordinates into latitude and longitude
coords <- strsplit(as.character(data$coordinates), ", ")
latitude <- as.numeric(sapply(coords, "[[", 1))
longitude <- as.numeric(sapply(coords, "[[", 2))

# UI for Shiny app
ui <- fluidPage(
  leafletOutput("map")
)

# Server logic for Shiny app
public_server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet(data) %>%
      addTiles() %>%
      addMarkers(lng = longitude, lat = latitude, popup = data$dmo)
  })
}

# Run the application
shinyApp(ui = ui, server = public_server)
