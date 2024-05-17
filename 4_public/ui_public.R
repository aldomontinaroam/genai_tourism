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
        condition = "input.tabs == 'Web & Literature'",  
        h4("Word Cloud from Web URLs"),
        p("Blogs focus a lot on the content development and promotional content part, while the scientific literature directly cites the field of marketing, also focusing on controlling visitor flows."),
        p(strong("Source:")),"Text mining on blog posts with information on AI tools for DMOs and scientific papers on Scopus.",
      ),
      conditionalPanel(
        id="textpanel",
        condition = "input.tabs == 'Tools'", 
        h4("AI Tools"),
        p("OpenAI dominates the ranking with ChatGPT (currently multi-modal) and DALL-E (text-to-image)."),
        p(strong("Source:")),"Leading generative artificial intelligence (AI) tools used for marketing purposes by professionals in the United States as of March 2023 [Graph], Botco.ai, May 4, 2023. [Online]. Available: https://www.statista.com/statistics/1386850/generative-ai-tools-marketing-purposes-usa/",
      ),
      conditionalPanel(
        id="textpanel",
        condition = "input.tabs == 'Impact'",
        h4("Perceived Impact of AI on DMOs"),
        p("Content creation is perceived as the most relevant area with the implementation of generative AI tools, followed by personalization of marketing campaigns."),
        p(strong("Source:")),"Perceived impact of artificial intelligence (AI) on activities of destination marketing organizations (DMOs) worldwide as of September 2023 [Graph], Sojern, November 20, 2023. [Online]. Available: https://www.statista.com/statistics/1425416/ai-impact-activities-dmos-worldwide/",
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
                   h4("AI Tools by Usage in Marketing"),
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



