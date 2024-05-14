# Load data and define global variables
data <- read.csv("4_public/data/geocoded_.csv", row.names = NULL, stringsAsFactors = FALSE, sep = ",")
public_urls <- c(
  "https://www.intentful.ai/blog/100-generative-ai-use-cases-for-dmo-and-travel-brands",
  "https://maddenmedia.com/navigating-the-ai-era-how-dmos-can-thrive-with-googles-ai-trip-planner/",
  "https://datadrivendestinations.com/2024/03/ai-and-generative-ai-transforming-destination-management/",
  "https://destinationsinternational.org/blog/how-use-generative-ai-promote-your-destination"
)

pdf_folder <- "4_public/data/papers"
pdf_files_public <- list.files(path = pdf_folder, pattern = "\\.pdf$", full.names = TRUE)

# Load custom stop words
stop_words_custom <- c(
  "tourism", "tourist", "tourists", "destination", "destinations", "travel", "traveller", "travellers",
  "management", "dmo", "dmos", "use", "case", "cases",
  "et", "al", "crossref",
  "can", "could", "may", "might", "must", "shall", "should", "will", "would",
  "also", "however", "therefore", "thus", "hence", "moreover", "furthermore",
  "e.g.", "i.e.", "etc.", "et al.", "al.",
  "tool", "tools", "method", "methods", "approach", "approaches", "technique", "techniques",
  "res", "httpsdoiorg", "generative ai", "ai", "google", "artificial intelligence",
  "generated", "generation", "generating", "generates", "generate",
  "creating", "create", "created", "creation", "creates",
  "local", "locals", "locally", "locale", "locales",
  "cdata", "var", "ucbutton", "typeubutton", "the", "this", "like", "data", "generative"
)

stop_words_pdfs <- c(
  "tourism", "tourist", "tourists", "destination", "destinations", "travel", "traveller", "travellers",
  "management", "dmo", "dmos", "use", "case", "cases",
  "et", "al", "crossref",
  "can", "could", "may", "might", "must", "shall", "should", "will", "would",
  "also", "however", "therefore", "thus", "hence", "moreover", "furthermore",
  "e.g.", "i.e.", "etc.", "et al.", "al.",
  "tool", "tools", "method", "methods", "approach", "approaches", "technique", "techniques",
  "res", "httpsdoiorg", "generative ai", "ai", "google", "artificial intelligence",
  "generated", "generation", "generating", "generates", "generate",
  "creating", "create", "created", "creation", "creates",
  "local", "locals", "locally", "locale", "locales",
  "-May-", "formatThis"
  
)

# Define server function
public_server <- function(input, output, session) {
  
  # Reactive expression for filtered cities based on selected region
  filtered_cities <- reactive({
    req(input$selected_region)
    if (input$selected_region == "All") {
      unique(data$county)
    } else {
      unique(data$county[data$state == input$selected_region])
    }
  })
  
  # Update choices for cities based on selected region
  observe({
    updateSelectInput(session, "selected_city", choices = c("All", filtered_cities()))
  })
  
  # Reactive expression for filtered data based on selected region and city
  filtered_data <- reactive({
    req(input$selected_region, input$selected_city) # Ensure both region and city are selected before filtering
    if (input$selected_region == "All" & input$selected_city == "All") {
      data
    } else if (input$selected_region == "All") {
      subset(data, county == input$selected_city)
    } else if (input$selected_city == "All") {
      subset(data, state == input$selected_region)
    } else {
      subset(data, state == input$selected_region & county == input$selected_city)
    }
  })
  
  # Custom icon for markers
  customIcon <- makeIcon(
    iconUrl = "4_public/data/dmo_icon.png",
    iconWidth = 30, iconHeight = 40
  )
  
  # Render leaflet map
  output$public_map <- renderLeaflet({
    req(filtered_data()) # Ensure filtered data is available
    leaflet() %>%
      addTiles(urlTemplate = "https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png") %>% # Change map tiles
      setView(lng = mean(filtered_data()$original_longitude), lat = mean(filtered_data()$original_latitude), zoom = 5) %>% # Set initial view and zoom level
      addMarkers(lng = filtered_data()$original_longitude, lat = filtered_data()$original_latitude,
                 popup = paste("<b>DMO:</b>", filtered_data()$original_dmo, "<br>", filtered_data()$formatted),
                 icon = customIcon) # Customize popup content
  })
  
  remove_stop_bigrams <- function(text) {
    stop_bigrams <- c("et al", "crossref")  # Define stop bigrams
    stop_words <- c(stopwords("en"), stop_words_custom)  # Get stop words including custom ones
    for (bigram in stop_bigrams) {
      # Check if all words in the bigram are stop words
      if (all(sapply(strsplit(bigram, " "), function(word) word %in% stop_words))) {
        text <- str_replace_all(text, paste0("\\b", bigram, "\\b"), "")  # Remove stop bigrams
      }
    }
    # Remove bigrams with punctuation or digits
    text <- str_replace_all(text, "\\b\\w*\\d\\w*\\b", "") # Remove bigrams with digits
    text <- str_replace_all(text, "\\b\\w*[[:punct:]]\\w*\\b", "") # Remove bigrams with punctuation
    # Remove bigrams with URLs
    text <- str_replace_all(text, "https?://\\S+\\s?", "") # Remove bigrams with URLs
    # Remove additional unwanted patterns
    text <- str_replace_all(text, "\\[\\w+\\s*\\-\\w+\\]\\s*\\.\\n\\.", "") # Remove [Accessed -May-].\n.
    text <- str_replace_all(text, ",\\s*,", "") # Remove , , patterns
    text <- str_replace_all(text, "\\s*\\-\\-\\s*", "") # Remove -- patterns
    text <- str_replace_all(text, "\\s*\\–\\s*", "") # Remove – patterns
    text <- str_replace_all(text, "\\s*\\.\\n\\s*\\[\\w+\\]", "") # Remove .\n [Accessed patterns
    text <- str_replace_all(text, "\\s*\\.\\s*\\w+\\s*\\,\\s*\\w+", "") # Remove ., ). patterns
    text <- str_replace_all(text, "\\s*\\w+\\[\\]", "") # Remove \s*\w+\[\] patterns
    return(text)
  }
  
  remove_unwanted_patterns <- function(text) {
    # Define patterns to remove
    patterns <- c(
      "\\[Accessed.*\\]",  # Remove [Accessed ...] patterns
      "—",  # Remove em dashes
      "\\.",  # Remove periods
      "\\n",  # Remove newline characters
      "\\[\\]",  # Remove empty brackets
      "\\(\\)",  # Remove empty parentheses
      "\\,\\s*\\)",  # Remove , ) patterns
      "\\s*\\,\\s*",  # Remove multiple consecutive commas
      "\\s*\\;\\s*",  # Remove multiple consecutive semicolons
      "\\s*\\:\\s*"  # Remove multiple consecutive colons
    )
    # Remove patterns from text
    for (pattern in patterns) {
      text <- str_replace_all(text, pattern, "")
    }
    return(text)
  }
  
  # Function to scrape and clean text from URLs
  scrape_and_clean <- function(url) {
    tryCatch({
      page <- try(read_html(url), silent = TRUE)
      if (inherits(page, "try-error")) {
        warning("Invalid URL or website not accessible:", url)
        return("")
      }
      all_text <- page %>%
        html_nodes("body") %>%
        html_text() %>%
        str_trim() %>%
        str_squish()
      
      if (length(all_text) == 0) {
        warning("No text found on the page.")
        return("")
      }
      
      # Preprocess text
      cleaned_text <- tolower(all_text)
      cleaned_text <- removePunctuation(cleaned_text)
      cleaned_text <- removeNumbers(cleaned_text)
      cleaned_text <- removeWords(cleaned_text, c(stopwords("en"), stop_words_custom))
      cleaned_text <- remove_stop_bigrams(cleaned_text)
      cleaned_text <- remove_unwanted_patterns(cleaned_text) # Add this line
      cleaned_text <- stripWhitespace(cleaned_text)
      
      if (nchar(cleaned_text) == 0) {
        warning("After cleaning, the document is empty.")
        return("")
      }
      
      cleaned_text
    }, error = function(e) {
      message("Error scraping URL: ", url, "\n", e)
      return("")
    })
  }
  
  scrape_and_clean_pdfs <- function(pdf_files) {
    combined_text <- sapply(pdf_files, extract_text_from_local_pdf)
    all_clean_text <- paste(combined_text, collapse = " ")
    
    # Remove stop words and bigrams containing stop words
    all_clean_text <- removeWords(all_clean_text, c(stopwords("en"), stop_words_pdfs))
    all_clean_text <- remove_stop_bigrams(all_clean_text)
    # Apply remove_unwanted_patterns to clean text
    all_clean_text <- remove_unwanted_patterns(all_clean_text) # Add this line
    
    return(all_clean_text)
  }
  
  # Function to extract text from PDF files
  extract_text_from_local_pdf <- function(pdf_path) {
    tryCatch(
      {
        message("Attempting to read PDF: ", pdf_path)
        pdf_text <- pdftools::pdf_text(pdf_path)
        if (length(pdf_text) == 0) {
          warning("No text extracted from PDF: ", pdf_path)
          return("")
        } else {
          combined_text <- paste(pdf_text, collapse = " ")
          return(combined_text)
        }
      },
      error = function(e) {
        message("Error reading PDF: ", pdf_path, "\n", e)
        return("")
      }
    )
  }
  
  # Function to scrape and clean text from a list of URLs
  scrape_and_clean_urls <- function(urls) {
    combined_text <- sapply(urls, scrape_and_clean)
    all_clean_text <- paste(combined_text, collapse = " ")
    
    # Remove stop words and bigrams containing stop words
    all_clean_text <- removeWords(all_clean_text, c(stopwords("en"), stop_words_custom))
    all_clean_text <- remove_stop_bigrams(all_clean_text)
    # Apply remove_unwanted_patterns to clean text
    all_clean_text <- remove_unwanted_patterns(all_clean_text)
    
    return(all_clean_text)
  }
  
  
  # Word cloud for scraped web URLs
  output$word_cloud_web_urls <- renderPlot({
    req(input$selected_region) # Make sure a region is selected
    all_clean_text <- scrape_and_clean_urls(public_urls)
    wordcloud(
      all_clean_text,
      max.words = 100,
      random.order = FALSE,
      colors = c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700"),
      scale = c(3, 0.5),
      main = "Word Cloud (Web URLs)"
    )
  })
  
  output$word_cloud_pdfs <- renderPlot({
    req(input$selected_region) # Make sure a region is selected
    if (length(pdf_files_public) == 0) {
      plot(1, type = "n", xlab = "", ylab = "", main = "No PDF files found")
    } else {
      all_clean_text <- scrape_and_clean_pdfs(pdf_files_public)
      if (nchar(all_clean_text) > 0) {
        wordcloud(
          all_clean_text,
          max.words = 100,
          random.order = FALSE,
          colors = c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700"),
          scale = c(3, 0.5),
          main = "Word Cloud (PDFs)"
        )
      } else {
        plot(1, type = "n", xlab = "", ylab = "", main = "No text extracted from PDFs")
      }
    }
  })
  
  # BAR PLOTS ===============================================
  # Reactive expression for scraped web URLs
  scraped_web_urls <- reactive({
    req(input$selected_region) # Make sure a region is selected
    all_clean_text <- scrape_and_clean_urls(public_urls)
    return(all_clean_text)
  })
  
  # Reactive expression for scraped PDFs
  scraped_pdfs <- reactive({
    req(input$selected_region) # Make sure a region is selected
    all_clean_text <- scrape_and_clean_pdfs(pdf_files_public)
    return(all_clean_text)
  })
  
  # Bar plot for web URLs
  output$web_urls_barplot <- renderPlot({
    req(scraped_web_urls()) # Ensure scraped data is available
    top_bigrams <- ngram(scraped_web_urls(), n = 2) %>%
      get.phrasetable() %>%
      filter(!str_detect(ngrams, paste(stop_words_custom, collapse = "|")),  # Filter out bigrams containing custom stop words
             !str_detect(ngrams, "\\b(?:the|of|on|in|for|to)\\b")) %>%   # Filter out bigrams containing common stop words
      arrange(desc(freq)) %>%
      head(5)
    
    ggplot(top_bigrams, aes(x = reorder(ngrams, -freq), y = freq)) +
      geom_bar(stat = "identity", fill = "#00a6a6") +
      labs(
        title = "Top 5 Most Frequent Bigrams (Web URLs)",
        x = "Bigram",
        y = "Frequency"
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  output$pdfs_barplot <- renderPlot({
    req(scraped_pdfs()) # Ensure scraped data is available
    if (nchar(scraped_pdfs()) == 0) {
      plot(1, type = "n", xlab = "", ylab = "", main = "No text extracted from PDFs")
    } else {
      top_bigrams <- ngram(scraped_pdfs(), n = 2) %>%
        get.phrasetable() %>%
        filter(!str_detect(ngrams, paste(stop_words_pdfs, collapse = "|")),  # Filter out bigrams containing custom stop words
               !str_detect(ngrams, "\\b(?:the|of|on|in|for|to)\\b")) %>%   # Filter out bigrams containing common stop words
        arrange(desc(freq)) %>%
        head(5)
      
      print(top_bigrams)
      
      ggplot(top_bigrams, aes(x = reorder(ngrams, -freq), y = freq)) +
        geom_bar(stat = "identity", fill = "#00a6a6") +
        labs(
          title = "Top 5 Most Frequent Bigrams (PDFs)",
          x = "Bigram",
          y = "Frequency"
        ) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
  })
}