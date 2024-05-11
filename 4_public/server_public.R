# Server logic for Public page
public_server <- function(input, output) {
  output$public_map <- renderLeaflet({
    # Load required libraries
    library(leaflet)
    
    # Read data from CSV file
    data <- read.csv("4_public/data/dmo_map_coordinates.csv", row.names=NULL, stringsAsFactors = FALSE, sep=";")
    
    # Split coordinates into latitude and longitude
    coords <- strsplit(as.character(data$coordinates), ", ")
    latitude <- as.numeric(sapply(coords, "[[", 1))
    longitude <- as.numeric(sapply(coords, "[[", 2))
    
    # Render leaflet map
    leaflet(data) %>%
      addTiles() %>%
      addMarkers(lng = longitude, lat = latitude, popup = data$dmo)
  })
}
