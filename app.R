library(shiny)
library(leaflet)
library(wordcloud)
library(tm)
library(bslib)

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
  
  # Read text from external file
  about_text <- readLines("about.txt", warn = FALSE)
  
  # Combine lines of text into a single string
  about_text_combined <- paste(about_text, collapse = "\n")
  
  observeEvent(input$aboutBtn, {
    showModal(modalDialog(
      title = "About",
      HTML(about_text_combined),
      footer = NULL,
      easyClose = TRUE
    ))
  })
}

# Define UI for application
ui <- tagList(
  div(
    tags$style(HTML("
      .footer {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        background-color: #bbdef0;
        padding: 5px;
        text-align: center;
        color: #03003B;
      }
    ")),
    
    navbarPage(
      title = "SOTA GenAI in Tourism",
      theme = bs_theme(version = 5, bootswatch = "solar"),
      tabPanel("Travel Agencies", travel_agencies_ui),
      tabPanel("Accommodation Businesses", accommodation_businesses_ui),
      tabPanel("Countries", countries_ui),
      tabPanel("Public", public_ui),
      tabPanel("Tourist", tourist_ui),
      tabPanel("Rights", rights_ui)
    )
  ),
  
  tags$footer(class = "footer",
              tags$div(
                tags$a(href = "https://esami.unipi.it/esami2/ects_shortprogram.php?a=61771", class = "btn btn-secondary", style = "float: left; margin-right: 10px;", "SCI"),
                tags$img(src = "footer_logo.png", height = "50px"),
                actionButton(
                  inputId = "aboutBtn",
                  label = "About",
                  class = "btn btn-primary",
                  style = "float: right; margin-left: 10px;"
                )
              ),
              tags$p("© 2024 Booking's SCIence. All rights reserved.", style = "margin-top: 5px; font-size: 10px; color: #555;")
  )
)


# Run the application
shinyApp(ui = ui, server = server)

