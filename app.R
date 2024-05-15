# Libraries for creating web applications
library(shiny)       # For creating web applications
library(leaflet)     # For interactive maps
library(wordcloud)   # For creating word clouds
library(tm)          # For text mining
library(bslib)       # For Bootstrap-based web pages
library(stringr)
library(wordcloud2)

# Libraries for data manipulation and visualization
library(tidyverse)   # For data manipulation and visualization
library(rvest)       # For web scraping

# Additional visualization and data manipulation libraries
library(RColorBrewer) # For color palettes
library(ngram)        # For extracting n-grams
library(httr)         # For HTTP requests
library(ggplot2)      # For plotting
library(igraph)       # For network graphs
library(treemap)      # For treemaps
library(gridExtra)    # For arranging multiple plots

# Library for working with PDF files
library(pdftools)    # For working with PDF files
library(plotly)
library(shinyBS)
library(ggwordcloud)
library(htmlwidgets)

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
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "morph") |> bslib::bs_add_rules(
    rules = "
      .navbar.navbar-default {
        background-color: #bbdef0 !important;
        color: #151B54 !important;
        text-align:center !important;
        margin:auto !important; 
        display:flex !important; 
        justify-content:center !important; 
        align-items:center !important
      }
      .navbar-nav {
        width: 100%;
        justify-content: center !important;
      }
      .nav-item {
        flex: 1;
        text-align: center;
        font-size: 25px !important;
      }
      .footer {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        background-color: #bbdef0;
        padding: 10px 0;
        text-align: center;
        color: #03003B;
        z-index: 999; /* Ensures footer stays on top of other content */
      }
      body {
        margin-bottom: 70px; /* Adjust this value to leave space between body and footer */
        display: flex;
        flex-direction: column;
        min-height: 100vh; /* Ensure the content fills the viewport height */
      }
      .main-content {
        flex: 1; /* Allow the main content to grow and fill the available space */
      }
    "
  ),
  tags$img(src = "logo_bsci-removebg-preview.png", height = "80px", style = "text-align:center;margin-left:auto; margin-right:auto; margin-top: 20px; margin-bottom:20px; display:flex; justify-content:center; align-items:center"),  # Add your logo here
  navbarPage(
    title=NULL,
    tabPanel("Travel Agencies", travel_agencies_ui),
    tabPanel("Accommodation Businesses", accommodation_businesses_ui),
    tabPanel("Countries", countries_ui),
    tabPanel("DMO", public_ui),
    tabPanel("Tourist", tourist_ui),
    tabPanel("Rights", rights_ui)
  ),
  div(class = "main-content",
      # Main content goes here
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
              tags$p("© 2024 Booking's SCIence. All rights reserved.", style = "margin-top: 5px; margin-bottom:0px; font-size: 8px; color: #555;")
  )
)

# Run the application
shinyApp(ui = ui, server = server)



