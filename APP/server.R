# Load necessary packages and libraries

# Define server logic
server <- function(input, output) {
  source("server_travel_agencies.R")
  source("server_accommodation_businesses.R")
  source("server_countries.R")
  source("server_public.R")
  source("server_tourist.R")
  source("server_rights.R")
}
