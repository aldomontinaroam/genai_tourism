library(shiny)
library(leaflet)
library(wordcloud)

data <- read.csv("4_public/data/geocoded_.csv", row.names = NULL, stringsAsFactors = FALSE, sep = ",")

# Define server function
public_server <- function(input, output, session) {
  
  # Load data
  
  
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
  
  # Render leaflet map
  output$public_map <- renderLeaflet({
    req(filtered_data()) # Ensure filtered data is available
    leaflet() %>%
      addTiles(urlTemplate = "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png") %>% # Change map tiles
      setView(lng = mean(filtered_data()$original_longitude), lat = mean(filtered_data()$original_latitude), zoom = 5) %>% # Set initial view and zoom level
      addMarkers(lng = filtered_data()$original_longitude, lat = filtered_data()$original_latitude, 
                 popup = paste("<b>DMO:</b>", filtered_data()$original_dmo, "<br>", filtered_data()$formatted)) # Customize popup content
  })
  
  # Generate mock data for word clouds and bar plots
  mock_text_data <- c("apple", "banana", "orange", "apple", "orange", "banana", "apple", "apple", "orange", "banana")
  mock_text_data2 <- c("cat", "dog", "cat", "dog", "dog", "cat", "cat", "dog", "cat", "dog")
  mock_bar_data <- data.frame(category = c("A", "B", "C", "D"), value = sample(1:100, 4))
  mock_bar_data2 <- data.frame(category = c("X", "Y", "Z", "W"), value = sample(1:100, 4))
  
  # Render word cloud 1
  output$word_cloud1 <- renderPlot({
    req(mock_text_data) # Ensure mock data is available
    wordcloud(mock_text_data, main = "Word Cloud 1")
  })
  
  # Render word cloud 2
  output$word_cloud2 <- renderPlot({
    req(mock_text_data2) # Ensure mock data is available
    wordcloud(mock_text_data2, main = "Word Cloud 2")
  })
  
  # Render bar plot 1
  output$bar_plot1 <- renderPlot({
    req(mock_bar_data) # Ensure mock data is available
    barplot(mock_bar_data$value, names.arg = mock_bar_data$category, main = "Bar Plot 1")
  })
  
  # Render bar plot 2
  output$bar_plot2 <- renderPlot({
    req(mock_bar_data2) # Ensure mock data is available
    barplot(mock_bar_data2$value, names.arg = mock_bar_data2$category, main = "Bar Plot 2")
  })
}

public_ui <- fluidPage(
  titlePanel("Select Region and City to View on Map"),
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




# Run the application
shinyApp(ui = public_ui, server = public_server)
