# Load patent dataset
patent_data <- read.csv("3_countries/data/lens-export.csv")

# Filter data for publication date greater than 2022-12-01
patent_data$Publication.Date <- as.Date(patent_data$Publication.Date)
patent_data <- patent_data[patent_data$Publication.Date > as.Date("2022-12-01"), ] # 90 patents

# Load stopwords
data("stopwords")

# Custom palette
custom_palette <- c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700")

# Server logic for Countries page
countries_server <- function(input, output) {
  output$countries_plot <- renderPlot({
    # Data
    data <- data.frame(
      Country = c("Germany", "Austria", "Netherlands", "Portugal", "Nordics", "Greece", "France", "Italy", "Spain"),
      Already_using_AI = c(20, 19, 17, 15, 10, 9, 8, 8, 4),
      Planning_to_use_AI_in_6_months = c(12, 10, 16, 16, 14, 15, 14, 18, 23),
      Not_planning_to_use_AI = c(66, 70, 66, 66, 74, 75, 76, 74, 74)
    )
    
    # Convert to long format
    data_long <- melt(data, id.vars = "Country")
    
    # Reorder the levels of Country based on the percentage of "Already using AI"
    data_long$Country <- factor(data_long$Country, levels = data$Country[order(data$Already_using_AI)])
    
    # Plot
    ggplot(data_long, aes(x = value, y = Country, fill = variable)) +
      geom_bar(stat = "identity", position = "fill") +
      geom_text(aes(label = paste0(value, "%")), position = position_fill(vjust = 0.5), size = 3) +
      scale_fill_manual(values = c("#00a6a6", "#bbdef0","#f49f0a"),
                        name = "Legend",
                        labels = c("Yes, we already use AI", "Not yet, but we plan to use AI in the next 6 months", "No, we do not currently use or plan to use AI", "Don't know")) +
      labs(x = "Country", y = "Percentage", title = "Current use of AI/planned use of AI in the next 6 months") +
      theme_minimal() +
      theme(legend.position = "bottom",
            axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
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
