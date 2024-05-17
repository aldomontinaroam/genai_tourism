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

custom_palette <- c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700")

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
  "cdata", "var", "ucbutton", "typeubutton", "the", "this", "like", "data", "generative",
  "us"
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
  "-May-", "formatThis", "the", "generative", "this", "formatfigure", "prebensen",
  "zhang", "state", "journal", "accessed"
  
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
  # Render leaflet map with margins
  # Render leaflet map with margins
  output$public_map <- renderLeaflet({
    req(filtered_data())
    
    leaflet() %>%
      addTiles(urlTemplate = "https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png") %>%
      addMarkers(lng = filtered_data()$original_longitude, lat = filtered_data()$original_latitude,
                 popup = paste("<b>DMO:</b>", filtered_data()$original_dmo, "<br>", filtered_data()$formatted),
                 icon = customIcon)
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
      "\\s*\\:\\s*",  # Remove multiple consecutive colons
      "\\(p \\)" # Remove (p ) pattern
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
    
    # Convert text to lowercase before removing stop words
    all_clean_text <- tolower(all_clean_text)
    
    # Remove stop words and bigrams containing stop words
    all_clean_text <- removeWords(all_clean_text, c(stopwords("en"), stop_words_pdfs))
    all_clean_text <- remove_stop_bigrams(all_clean_text)
    
    # Apply remove_unwanted_patterns to clean text
    all_clean_text <- remove_unwanted_patterns(all_clean_text)
    
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
  
  # Update word cloud title visibility
  wordcloud_title <- function(title) {
    list(
      title = list(
        text = title,
        color = "black",
        margin = margin(b = 20)  # Add margin to move the title down
      )
    )
  }
  
  
  output$word_cloud_web_urls <- renderPlot({
    all_clean_text <- scrape_and_clean_urls(public_urls)
    
    # Create word cloud
    wordcloud_obj <- wordcloud(all_clean_text, max.words = 20, random.order = FALSE,
                               figPath = "wc1.png",
                               colors = custom_palette, scale = c(5, 1),
                               main = list(text = "<b>Word Cloud (Web URLs)</b>", color = "black"), 
                               theme = theme_minimal() +
                                 theme(panel.grid.major = element_blank(),
                                       panel.grid.minor = element_blank(),
                                       axis.text = element_blank(),
                                       axis.ticks = element_blank(),
                                       plot.title = element_text(color = "black"),
                                       plot.margin = margin(10, 10, 10, 10)))  # Adjust margin
    
    # Ensure horizontal layout for the most frequent word
    wordcloud_obj$layout$rotation <- 0
    
    
    
    # Plot the word cloud
    print(wordcloud_obj)
  })
  
  output$word_cloud_pdfs <- renderPlot({
    if (length(pdf_files_public) == 0) {
      plot(1, type = "n", xlab = "", ylab = "", main = "<b>No PDFs</b>")
    } else {
      all_clean_text <- scrape_and_clean_pdfs(pdf_files_public)
      if (nchar(all_clean_text) > 0) {
        # Create word cloud
        wordcloud_obj <- wordcloud(all_clean_text, max.words = 20, random.order = FALSE,
                                   colors = custom_palette, scale = c(5, 1),
                                   main = list(text = "<b>Word Cloud (PDFs)</b>", color = "black"),
                                   theme = theme_minimal() +
                                     theme(panel.grid.major = element_blank(),
                                           panel.grid.minor = element_blank(),
                                           axis.text = element_blank(),
                                           axis.ticks = element_blank(),
                                           plot.title = element_text(color = "black"),
                                           plot.margin = margin(10, 10, 10, 10)))  # Adjust margin
        
        # Ensure horizontal layout for the most frequent word
        wordcloud_obj$layout$rotation <- 0
        
        # Plot the word cloud
        print(wordcloud_obj)
      } else {
        plot(1, type = "n", xlab = "", ylab = "", main = "<b>No Text from PDFs</b>")
      }
    }
  })
  
  
  
  
  
  # BAR PLOTS ===============================================
  
  
  # Define custom palette with the first color as darker
  custom_palette_bar <- c("#00a6a6", "#bbdef0")
  
  # Function to create bar plot with decreasing order and different colors for highest bar
  create_barplot <- function(data, title) {
    ggplot(data, aes(x = reorder(ngrams, -freq), y = freq, fill = ifelse(freq == max(freq), "Highest", "Other"))) +
      geom_bar(stat = "identity", width = 0.7) +
      geom_text(aes(label = freq), vjust = -0.5, size = 4, color = "black") +
      scale_fill_manual(name = "", values = c("Highest" = custom_palette_bar[1], "Other" = custom_palette_bar[2])) +  # Different color for the highest bar
      labs(
        title = title,
        x = NULL,
        y = "Frequency"
      ) +
      theme_minimal() +
      theme(
        legend.position = "none",
        plot.title = element_text(hjust = 0.5),
        axis.title.y = element_text(size = 12, vjust = 1.5),
        axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 0.5, size = 10, face = "bold"), # Zero angle, centered, bold x-axis labels
        axis.text.y = element_text(size = 10),
        panel.grid = element_blank(),
        plot.caption = element_text(hjust = 1),
        plot.margin = margin(20, 20, 20, 20)
      ) +
      scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) # Wrap labels to two lines
  }
  
  
  
  
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
  
  output$web_urls_barplot <- renderPlot({
    req(scraped_web_urls())
    top_bigrams <- ngram(scraped_web_urls(), n = 2) %>%
      get.phrasetable() %>%
      filter(!str_detect(ngrams, paste(stop_words_custom, collapse = "|")),
             !str_detect(ngrams, "\\b(?:the|of|on|in|for|to)\\b")) %>%
      arrange(desc(freq)) %>%
      head(5)
    
    create_barplot(top_bigrams, "Top Bigrams from BLOG POSTS")
  })
  
  output$pdfs_barplot <- renderPlot({
    req(scraped_pdfs())
    if (nchar(scraped_pdfs()) == 0) {
      plot(1, type = "n", xlab = "", ylab = "", main = "No text extracted from PDFs")
    } else {
      top_bigrams <- ngram(scraped_pdfs(), n = 2) %>%
        get.phrasetable() %>%
        filter(!str_detect(ngrams, paste(stop_words_pdfs, collapse = "|")),
               !str_detect(ngrams, "\\b(?:the|of|on|in|for|to)\\b")) %>%
        arrange(desc(freq)) %>%
        head(5)
      
      create_barplot(top_bigrams, "Top Bigrams from PAPERS")
    }
  })
  
  
  
  # Leading generative artificial intelligence (AI) tools used for marketing purposes by professionals in the United States as of March 2023
  output$treemap_tools <- renderPlotly({
    # Define data
    tools <- data.frame(
      Category = c(
        "ChatGPT",
        "Copy.ai",
        "Jasper.ai",
        "Peppertype.ai",
        "Lensa",
        "DALL-E",
        "Midjourney"
      ),
      Percentage = c(55, 42, 36, 29, 28, 25, 24),
      Description = c(
        "Chatbot and conversational AI",
        "Product descriptions and content",
        "Blog posts and articles",
        "Content creation optimization",
        "Image editing app",
        "Text-to-Image",
        "Text-to-Image"
      ),
      Image = c(
        "chatgpt.png",
        "copyai.png",
        "jasperai.png",
        "peppertypeai.png",
        "lensa.png",
        "dalle.png",
        "midjourney.png"
      )
    )
    
    # Define the color palette
    color_palette <- colorRampPalette(c("#bbdef0", "#00a6a6"))(nrow(tools))
    
    plot_ly(tools, type = "treemap", labels = ~Category,
            parents = "", values = ~Percentage,
            hoverinfo = "text", text = ~paste(Percentage, "%<br>", Description),
            marker = list(colors = color_palette),
            textfont = list(color = "black", size = 14, family = "Verdana", 
                            weight = "bold")) %>%
      layout(font = list(color = "black", size = 12, family = "Verdana"))
  })
  
  output$perceived <- renderPlot({
    # Create the data frame
    perceived_impact <- data.frame(
      Task = c("Marketing content personalization", "Content creation", "Camping creation and optimization",
               "Data analysis and interpretation", "Predictive analysis and forecasting", "Creative media",
               "Conversational marketing", "Web, app, and platform creation"),
      N.A = c(3, 4, 4, 5, 5, 5, 8, 9),
      LittleImpact = c(16, 13, 20, 12, 14, 24, 22, 24),
      SomeImpact = c(44, 34, 47, 43, 41, 46, 41, 42),
      HighImpact = c(37, 49, 29, 38, 40, 25, 29, 25)
    )
    
    # Melt the data frame
    data_melted <- reshape2::melt(perceived_impact, id.vars = "Task")
    
    # Reorder the Task factor levels based on HighImpact
    data_melted$Task <- factor(data_melted$Task, levels = data_melted$Task[order(perceived_impact$HighImpact)])
    
    # Create the plot
    ggplot(data_melted, aes(x = Task, y = value, fill = variable, label = scales::percent(value/100))) +
      geom_bar(stat = "identity", position = "stack") +
      geom_text(position = position_stack(vjust = 0.5), aes(label = scales::percent(value/100)), size = 4, fontface = "bold") +
      labs(x = "", y = "Share of respondents") +
      coord_flip() +
      scale_fill_manual(name = "", values = c("N.A" = "#bbdef0", "LittleImpact" = "#efca08", "SomeImpact" = "#00a6a6", "HighImpact" = "#f08700")) +
      guides(fill = guide_legend(reverse = TRUE)) +
      theme_minimal() +
      theme(legend.position = "bottom",
            panel.grid.major.y = element_blank(),
            axis.text.y = element_text(size = 14, face = "bold"),
            axis.ticks.y = element_blank(),
            axis.title.y = element_text(size = 16, face = "bold", margin = margin(r = 15)))
  })
  
  
  
  
  
}