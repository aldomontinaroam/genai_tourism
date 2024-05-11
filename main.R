library(shiny)
library(leaflet)
library(wordcloud)
library(tm)

# Source UI and server files
source("1_ota/server_travel_agencies.R")
source("1_ota/ui_travel_agencies.R")

source("2_accbus/server_accommodation_businesses.R")
source("2_accbus/ui_accommodation_businesses.R")

source("3_countries/server_countries.R")
source("3_countries/ui_countries.R")

source("4_public/server_public.R", local = TRUE)
source("4_public/ui_public.R")

source("5_tourist/server_tourist.R")
source("5_tourist/ui_tourist.R")

source("6_rights/server_rights.R")
source("6_rights/ui_rights.R")

# Define server logic
server <- function(input, output, session) {
  call_modules <- function(module_server) {
    lapply(module_server, function(server_func) {
      server_func(input, output)  # Remove session argument here
    })
  }
  
  # Call all server logic functions
  call_modules(list(
    travel_agencies_server,
    accommodation_businesses_server,
    countries_server,
    function(input, output) { public_server(input, output, session) },  # Pass session here
    tourist_server,
    rights_server
  ))
}


# Define UI for application
ui <- navbarPage(
  title = "Travel Dashboard",
  
  tabPanel("Travel Agencies",
           travel_agencies_ui
  ),
  
  tabPanel("Accommodation Businesses",
           accommodation_businesses_ui
  ),
  
  tabPanel("Countries",
           countries_ui
  ),
  
  tabPanel("Public",
           public_ui
  ),
  
  tabPanel("Tourist",
           tourist_ui
  ),
  
  tabPanel("Rights",
           rights_ui
  )
)

# Run the application
shinyApp(ui = ui, server = server)
