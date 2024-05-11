library(shiny)

# Define server logic
server <- function(input, output) {
  source("ota/server_travel_agencies.R")
  source("acc_bus/server_accommodation_businesses.R")
  source("countries/server_countries.R")
  source("public/server_public.R")
  source("tourist/server_tourist.R")
  source("rights/server_rights.R")
}

# Define UI for application
ui <- navbarPage(
  title = "Travel Dashboard",
  
  tabPanel("Travel Agencies",
           source("ota/ui_travel_agencies.R")
  ),
  
  tabPanel("Accommodation Businesses",
           source("acc_bus/ui_accommodation_businesses.R")
  ),
  
  tabPanel("Countries",
           source("countries/ui_countries.R")
  ),
  
  tabPanel("Public",
           source("public/ui_public.R")
  ),
  
  tabPanel("Tourist",
           source("tourist/ui_tourist.R")
  ),
  
  tabPanel("Rights",
           source("rights/ui_rights.R")
  )
)

# Run the application
shinyApp(ui = ui, server = server)

