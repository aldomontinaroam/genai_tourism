source("6_rights/global_rights.R")

# Server logic for Rights page
rights_server <- function(input, output) {
  output$plotUI <- renderUI({
    if(input$plotType == "Consumer Sentiment") {
      plotOutput("wordcloudPlot")
    } else {
      plotlyOutput("plot")
    }
  })
  
  output$wordcloudPlot <- renderPlot({
    reviews_corpus <- Corpus(VectorSource(consumer_reviews$review))  
    reviews_corpus <- tm_map(reviews_corpus, content_transformer(tolower))  
    reviews_corpus <- tm_map(reviews_corpus, removePunctuation)  
    reviews_corpus <- tm_map(reviews_corpus, removeWords, stopwords("en"))  
    wordcloud_df <- TermDocumentMatrix(reviews_corpus)  
    wordcloud_matrix <- as.matrix(wordcloud_df)  
    wordcloud_data <- sort(rowSums(wordcloud_matrix), decreasing = TRUE)  
    wordcloud_df <- data.frame(word = names(wordcloud_data), freq = wordcloud_data)  
    wordcloud(words = wordcloud_df$word, freq = wordcloud_df$freq, min.freq = 1,
              max.words = 200, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
  })
  
  output$plot <- renderPlotly({
    if(input$plotType == "Economic Impact") {  
      p <- ggplot(economic_impact, aes(x = year, y = profit)) +  
        geom_line() +  
        geom_point() +  
        theme_minimal() +  
        labs(title = "Economic Impact Over Time", x = "Year", y = "Profit")  
      ggplotly(p)  
    } else if(input$plotType == "Legal Issues") {  
      p <- ggplot(legal_issues, aes(x = issue, y = count, fill = issue)) +  
        geom_bar(stat = "identity") +  
        theme_minimal() +  
        labs(title = "Legal Issues Related to AI", x = "Issue", y = "Count")  
      ggplotly(p)  
    } else if(input$plotType == "Policies") {  
      p <- ggplot(policies, aes(x = policy, y = count, fill = policy)) +  
        geom_bar(stat = "identity") +  
        theme_minimal() +  
        labs(title = "Existing and Proposed Policies", x = "Policy", y = "Count")  
      ggplotly(p)  
    }  
  }) 
}
