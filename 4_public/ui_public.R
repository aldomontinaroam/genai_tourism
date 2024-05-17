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
      ),
      conditionalPanel(
        id="textpanel",
        condition = "input.tabs == 'Web'",  # Add explanatory text for 'Web' panel
        h4("Word Cloud from Web URLs"),
        p("This panel displays a word cloud generated from the text scraped from the provided web URLs."),
        p("It gives an overview of the most frequent words used in the content of the URLs.")
      ),
      conditionalPanel(
        id="textpanel",
        condition = "input.tabs == 'Literature'",  # Add explanatory text for 'Literature' panel
        h4("Word Cloud from PDFs"),
        p("This panel displays a word cloud generated from the text extracted from the provided PDF files."),
        p("It provides insights into the most common words found in the literature related to DMOs.")
      ),
      conditionalPanel(
        id="textpanel",
        condition = "input.tabs == 'Tools'",  # Add explanatory text for 'Tools' panel
        h4("AI Tools by Usage"),
        p("This panel presents a treemap visualization showcasing various AI tools used for marketing purposes by professionals."),
        p("It highlights the percentage usage of each tool along with a brief description of its functionality.")
      ),
      conditionalPanel(
        id="textpanel",
        condition = "input.tabs == 'Perception'",  # Add explanatory text for 'Tools' panel
        h4("Perceived Impact of AI on DMOs"),
        p("Marketing Content Personalization and Content Creation are highly regarded, 
          while Camping Creation and Optimization is slightly less so. Data Analysis 
          and Interpretation and Predictive Analysis and Forecasting are seen as valuable 
          but with some distinctions. Creative Media holds promise but with reservations. 
          Conversational Marketing and Web, App, and Platform Creation are viewed as highly 
          impactful, indicating recognition of AI's potential in enhancing interactive experiences and digital platforms.")
      )
    ),
    mainPanel(
      tags$style(HTML("
            #plotrow {
              margin: 20px;
              padding: 20px;
            }
            #second {
              border: 2px dashed blue;
            }
            #titlediv h4{
              font-weight: bold;
              font-size: 20px;
              text-align: center;
              margin-top: 20px;
              margin-bottom: 10px;
              margin-left: auto;
              margin-right: auto;
            }
            ")),
      tabsetPanel(
        id = "tabs",  # Add id to tabsetPanel
        tabPanel("DMOs in Italy",
                 div(
                   id="titlediv",
                   h4("Destination Management Organizations (DMOs) in Italy"),
                 ),
                 fluidRow(
                   id="plotrow",
                   column(12, leafletOutput("public_map", width = "100%", height = "600px"))
                 )
        ),
        tabPanel("Web & Literature",
                 fluidRow(
                   id = "titlediv",
                   column(6, 
                          h4("20 Most frequent Words in Blog Posts")),
                   column(6, 
                          h4("5 Most Frequent Bigrams in Blog Posts"))
                 ),
                 fluidRow(
                   id = "plotrow",
                   column(width = 6, 
                          plotOutput("word_cloud_web_urls")),
                   column(6, 
                          plotOutput("web_urls_barplot"))
                 ),
                 fluidRow(
                   id = "titlediv",
                   column(6, 
                          h4("20 Most frequent Words in Scientific Literature")),
                   column(6, 
                          h4("5 Most Frequent Bigrams in Scientific Literature"))
                 ),
                 fluidRow(
                   id = "plotrow",
                   column(width = 6, plotOutput("word_cloud_pdfs")),
                   column(6, plotOutput("pdfs_barplot"))
                 )
        ),
        tabPanel("Tools",
                 div(
                   id="titlediv",
                   h4("AI Tools by Usage"),
                 ),
                 fluidRow(
                   id = "plotrow",
                   column(width = 12, plotlyOutput("treemap_tools"))
                 )
        ),
        tabPanel("Impact",
                 div(
                   id="titlediv",
                   h4("Perceived impact of AI on activities of DMOs"),
                 ),
                 fluidRow(
                   id = "plotrow",
                   column(width = 12, plotOutput("perceived"))
                 )
        )
      )
    )
  )
)



