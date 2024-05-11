library(shiny)

# Define server logic
server <- function(input, output) {
  source("1_ota/server_travel_agencies.R")
  source("2_accbus/server_accommodation_businesses.R")
  source("3_countries/server_countries.R")
  source("4_public/server_public.R")
  source("5_tourist/server_tourist.R")
  source("6_rights/server_rights.R")
}

# Define UI for application
ui <- navbarPage(
  title = "Travel Dashboard",
  
  tabPanel("Travel Agencies",
           source("1_ota/ui_travel_agencies.R")
  ),
  
  tabPanel("Accommodation Businesses",
           source("2_accbus/ui_accommodation_businesses.R")
  ),
  
  tabPanel("Countries",
           source("3_countries/ui_countries.R")
  ),
  
  tabPanel("Public",
           source("4_public/ui_public.R")
  ),
  
  tabPanel("Tourist",
           source("5_tourist/ui_tourist.R")
  ),
  
  tabPanel("Rights",
           source("6_rights/ui_rights.R")
  )
)

# Run the application
shinyApp(ui = ui, server = server)

