data <- read.csv("4_public/data/geocoded_.csv", row.names = NULL, stringsAsFactors = FALSE, sep = ",")
public_urls <- c(
  "https://www.intentful.ai/blog/100-generative-ai-use-cases-for-dmo-and-travel-brands",
  "https://maddenmedia.com/navigating-the-ai-era-how-dmos-can-thrive-with-googles-ai-trip-planner/",
  "https://datadrivendestinations.com/2024/03/ai-and-generative-ai-transforming-destination-management/",
  "https://destinationsinternational.org/blog/how-use-generative-ai-promote-your-destination"
)

pdf_folder <- "4_public/data/papers"
pdf_files_public <- list.files(path = pdf_folder, pattern = "\\.pdf$", full.names = TRUE)

public_ui <- fluidPage(
  titlePanel("Destination Management Organizations (DMOs)"),
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "input.tabs == 'DMOs in Italy'",  # Change 'map' to 'Map'
        selectInput("selected_region", "Select Region:", choices = c("All", unique(data$state))),
        selectInput("selected_city", "Select City:", choices = NULL)
      )
    ),
    mainPanel(
      tabsetPanel(
        id = "tabs",  # Add id to tabsetPanel
        tabPanel("DMOs in Italy", leafletOutput("public_map")),
        tabPanel("Web",
                 fluidRow(
                   column(width = 6, plotOutput("word_cloud_web_urls")),
                   column(6, plotOutput("web_urls_barplot"))
                 )
        ),
        tabPanel("Literature",
                 fluidRow(
                   column(width = 6, plotOutput("word_cloud_pdfs")),
                   column(6, plotOutput("pdfs_barplot"))
                 )
        ),
        tabPanel("Tools",
                 fluidRow(
                   column(width = 6, plotlyOutput("treemap_tools"))
                 )
        )
      )
    )
  )
)


