library(shiny)
library(leaflet)

# Read data from CSV file
data <- read.csv("4_public/data/geocoded_.csv", row.names = NULL, stringsAsFactors = FALSE, sep = ",")

# Server logic for Public page
public_server <- function(input, output, session) {
  
  # Reactive expression for filtered cities based on selected region
  filtered_cities <- reactive({
    req(input$selected_region)
    if (input$selected_region == "All") {
      unique(data$county)
    } else {
      unique(data$county[data$state == input$selected_region])
    }
  })
  
  # Update choices for cities based on selected region
  observe({
    updateSelectInput(session, "selected_city", choices = c("All", filtered_cities()))
  })
  
  # Reactive expression for filtered data based on selected region and city
  filtered_data <- reactive({
    req(input$selected_region, input$selected_city) # Ensure both region and city are selected before filtering
    if (input$selected_region == "All" & input$selected_city == "All") {
      data
    } else if (input$selected_region == "All") {
      subset(data, county == input$selected_city)
    } else if (input$selected_city == "All") {
      subset(data, state == input$selected_region)
    } else {
      subset(data, state == input$selected_region & county == input$selected_city)
    }
  })
  
  output$public_map <- renderLeaflet({
    filtered_data <- filtered_data()
    
    # Define a custom icon
    customIcon <- makeIcon(
      iconUrl = "4_public/data/dmo_icon.png",
      iconWidth = 30, iconHeight = 40
    )
    
    # Get latitude and longitude from filtered data
    latitude <- as.numeric(filtered_data$original_latitude)
    longitude <- as.numeric(filtered_data$original_longitude)
    
    # Render leaflet map
    leaflet() %>%
      addTiles(urlTemplate = "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png") %>% # Change map tiles
      setView(lng = mean(longitude), lat = mean(latitude), zoom = 5) %>% # Set initial view and zoom level
      addMarkers(lng = longitude, lat = latitude, 
                 popup = paste("<b>DMO:</b>", filtered_data$original_dmo, "<br>", filtered_data$formatted), # Customize popup content
                 icon = customIcon) %>% # Custom marker icons
      addScaleBar(position = "bottomleft") # Add scale bar
  })
}

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

shinyApp(ui = public_ui, server = public_server)
