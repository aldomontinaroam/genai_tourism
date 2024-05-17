library(shiny)
library(plotly)
library(dplyr)
library(tm)
library(wordcloud)
library(RColorBrewer)

# Load patent dataset
patent_data <- read.csv("UNIPI/SCI/DASHBOARD/3_countries/data/lens-export.csv")

# Filter data for publication date greater than 2022-12-01
patent_data$Publication.Date <- as.Date(patent_data$Publication.Date)
patent_data <- patent_data[patent_data$Publication.Date > as.Date("2022-12-01"), ] # 90 patents

# Load stopwords
data("stopwords")

# Custom palette
custom_palette <- c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700")

# Define UI
ui <- fluidPage(
  titlePanel("Patent Analysis Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("analysis", "Choose Analysis:",
                  choices = c("Trend and Legal Status Analysis", "Text Analysis"),
                  selected = "Trend and Legal Status Analysis")
    ),
    mainPanel(
      uiOutput("plot_output")
    )
  )
)

server <- function(input, output) {
  
  output$plot_output <- renderUI({
    analysis_type <- input$analysis
    
    if (analysis_type == "Trend and Legal Status Analysis") {
      plotlyOutput("trend_plot")
    } else if (analysis_type == "Text Analysis") {
      plotOutput("wordcloud_plot")
    }
  })
  
  output$wordcloud_plot <- renderPlot({
    tryCatch({
      custom_stopwords <- c("patent", "invention", "method", "device", "system", "apparatus", 
                            "use", "thereof", "comprising", "comprises", "comprise", "using", 
                            "used", "based", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
                            "methods", "systems", "devices", "apparatuses", "devices", "systems", "apparatuses", "first",
                            "second", "data", "may", "can", "least", "configured")
      
      # Combine Title and Abstract into a single corpus
      corpus <- Corpus(VectorSource(paste(patent_data$Title, patent_data$Abstract, sep = " ")))
      corpus <- tm_map(corpus, content_transformer(tolower))
      corpus <- tm_map(corpus, removePunctuation)
      corpus <- tm_map(corpus, removeNumbers)
      corpus <- tm_map(corpus, removeWords, stopwords("en"))
      corpus <- tm_map(corpus, removeWords, custom_stopwords)
      
      dtm <- TermDocumentMatrix(corpus)
      m <- as.matrix(dtm)
      
      word_freqs <- sort(rowSums(m), decreasing = TRUE)
      
      wordcloud(words = names(word_freqs), freq = word_freqs, min.freq = 1,
                max.words = 100, random.order = FALSE, rot.per = 0.35, 
                colors = custom_palette)
    }, error = function(e) {
      print(e)
      return(NULL) # Return NULL if there's an error
    })
  })
  
  output$trend_plot <- renderPlotly({
    tryCatch({
      plot_data <- patent_data %>%
        count(Legal.Status) %>%
        arrange(desc(n))
      
      # Highlighting the highest bar
      plot_data$color <- ifelse(plot_data$n == max(plot_data$n), '#00a6a6', '#bbdef0')
      
      plot_ly(plot_data, y = ~Legal.Status, x = ~n, type = 'bar', orientation = 'h',
              marker = list(color = plot_data$color)) %>%
        layout(title = "Trend and Legal Status Analysis",
               xaxis = list(title = "Count"),
               yaxis = list(title = "Legal Status"))
    }, error = function(e) {
      print(e)
      return(NULL) # Return NULL if there's an error
    })
  })
}

shinyApp(ui = ui, server = server)
