# Load necessary packages and libraries

# Define UI for application
ui <- navbarPage(
  title = "Travel Dashboard",
  
  tabPanel("Travel Agencies",
           source("ui_travel_agencies.R")
  ),
  
  tabPanel("Accommodation Businesses",
           source("ui_accommodation_businesses.R")
  ),
  
  tabPanel("Countries",
           source("ui_countries.R")
  ),
  
  tabPanel("Public",
           source("ui_public.R")
  ),
  
  tabPanel("Tourist",
           source("ui_tourist.R")
  ),
  
  tabPanel("Rights",
           source("ui_rights.R")
  )
)
