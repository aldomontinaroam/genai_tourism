library(shiny)
library(plotly)
library(dplyr)
library(tm)
library(wordcloud2)
library(RColorBrewer)

# Load patent dataset
patent_data <- read.csv("UNIPI/SCI/DASHBOARD/3_countries/data/lens-export.csv")

# Filter data for publication date greater than 2022-12-01
patent_data$Publication.Date <- as.Date(patent_data$Publication.Date)
patent_data <- patent_data[patent_data$Publication.Date > as.Date("2022-12-01"), ] # 90 patents

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
      plotOutput("trend_plot")
    } else if (analysis_type == "Text Analysis") {
      wordcloud2Output("wordcloud_plot")
    }
  })
  
  
  
  output$wordcloud_plot <- renderWordcloud2({
    tryCatch({
      data("stopwords")
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
      
      wordcloud2(data = data.frame(word = names(word_freqs), freq = word_freqs))
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
      
      plot_ly(plot_data, x = ~Legal.Status, y = ~n, type = 'bar') %>%
        layout(title = "Trend and Legal Status Analysis",
               xaxis = list(title = "Legal Status"),
               yaxis = list(title = "Count"))
    }, error = function(e) {
      print(e)
      return(NULL) # Return NULL if there's an error
    })
  })
}

shinyApp(ui = ui, server = server)
