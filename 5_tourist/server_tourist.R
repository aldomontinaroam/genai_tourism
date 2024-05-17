custom_palette <- c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700")

# Server logic for Tourist page
tourist_server <- function(input, output) {
  # Data
  relevance <- data.frame(
    phase = c(rep("Dreaming", 18), rep("Planning", 7), rep("Pre-Travel", 7),
              rep("On-Trip", 6), rep("Post-Travel", 14)),
    tool = c("Inspirational Photos & Videos", "Interactive Quizzes and Surveys", 
             "Trendspotting and Discovery", "Nurturing the Dream",
             "Social media platforms", "Travel blogs and websites", 
             "Travel influencers", "ChatGPT", "GPT-4", "AlphaCode", 
             "GitHub Copilot", "Duet AI", "Bard", "ChatSonic", 
             "Sora", "FutureGAN", "OpenAI's Sora",
             "ChatGPT Code Interpreter", "Online travel agencies (OTAs)", 
             "Travel apps", "Travel websites", "Search engines", 
             "Metasearch engines", "Strategic partnerships with OTAs",
             "Efficient reservation systems via phone or chat", "Online booking platforms", 
             "Travel apps", "Travel websites", "Search engines", 
             "Metasearch engines", "Strategic partnerships with OTAs",
             "Efficient reservation systems via phone or chat", "Online booking platforms", 
             "Travel apps", "Travel websites", "Social media platforms", 
             "Pre-arrival emails", "Hotel mobile apps for personalization",
             "Social media for last-minute updates or offers", "Social media platforms", 
             "Travel blogs and websites", "Travel influencers", "ChatGPT", 
             "GPT-4", "AlphaCode", "GitHub Copilot", "Duet AI", 
             "Bard", "ChatSonic", "Sora", "FutureGAN", "OpenAI's Sora",
             "ChatGPT Code Interpreter")[-53] # Remove last element to make lengths match
  )
  
  # Count the number of tools by phase
  tools_by_phase <- relevance %>%
    group_by(phase) %>%
    summarize(number_of_tools = n(), tools = toString(unique(tool)))
  
  # Correctly order the phases
  phase_order <- c("Dreaming", "Planning", "Pre-Travel", "On-Trip", "Post-Travel")
  tools_by_phase$phase <- factor(tools_by_phase$phase, levels = phase_order)
  
  
  create_popup <- function(id, title, description, source, plot = NULL) {
    modal_content <- list(
      p(description),
      div(strong("Source: "), source),
      if(!is.null(plot)){plotlyOutput(paste0("plot_", id))}
      else{tags$div(
        id = "vr-img",
        tags$img(src = "vr.png", width = "60%")
        )}
    )
    
    showModal(modalDialog(
      title = title,
      modal_content,
      easyClose = TRUE,
      footer = NULL
    ))
  }
  
  
  observeEvent(input$phase1, {
    create_popup("phase1", "Dreaming and Research Phase", 
                 "Even though most generative AI tools launched only in the recent months before our survey, 
               leisure travelers have been experimenting with them and are largely pleased with their experiences. 
               More than a third of surveyed leisure travelers recently used generative AI for travel inspiration.
               84% of respondents reported being satisfied or very satisfied with the quality of generative AI’s recommendations.",
                 "GENERATIVE AI’S INFLUENCE ON LEISURE TRAVELER BEHAVIORS - Oliver Wyman, Exhibit 1: Leisure travelers' prior experience with Generative AI", plot=1)
  })
  
  observeEvent(input$phase2, {
    create_popup("phase2", "Planning and Booking Phase", 
                 "Generative AI-enabled channels will need to ensure they offer functionality that travelers find useful: 
                 based on the survey, real-time price comparison, loyalty program integration, and the ability to book all 
                 components of a trip in the same tool should be the top priorities to maximize traveler adoption.
                 55% of leisure travelers would select a booking channel because it has Generative AI capabilities",
                 "GENERATIVE AI’S INFLUENCE ON LEISURE TRAVELER BEHAVIORS - Oliver Wyman, Exhibit 2: Leisure travelers' prior experience with Generative AI", plot=1)
  })
  
  observeEvent(input$phase3, {
    create_popup("phase3", "Pre-Travel Experience", 
                 "Studies demonstrate that a VR preview induces higher elaboration of mental imagery about 
                 the experience and a stronger sense of presence compared to both the 360° preview and images 
                 preview, thereby translating into enhanced brand experience. Such findings suggest that VR 
                 is substantial in prompting tourists to “daydream” about lodging offers prior to experiencing them at 
                 the destination's premises.",
                 "Vanja Bogicevic, Soobin Seo, Jay A. Kandampully, Stephanie Q. Liu, Nancy A. Rudd, Virtual reality presence as a preamble of tourism experience: 
                 The role of mental imagery, Tourism Management, Volume 74, 2019, Pages 55-64, https://doi.org/10.1016/j.tourman.2019.02.009")
  })
  
  observeEvent(input$phase4, {
    create_popup("phase4", "On-Trip Experience", 
                 "Chatbots are multilingual, offer instant responses, and 24/7 availability, which is ideal for 
            customer-centric businesses such as travel companies, accommodation providers, or even destinations. 
          They use existing platforms or browsers that travelers already have on their phones, which means that they 
          don’t need to download a separate app and clutter their device. As chatbots can be implemented on any channel 
          or social network, travelers can approach your brand to seek recommendations, book flights and hotels via 
          different channels like Facebook, Skype, Slack, Twitter, etc, thus increasing your chances of reaching your target audience.
          Users can ask questions in their own words and get a response rather than spending time searching for those answers 
          on your website. Conversing is a much easier and pleasant experience to identify the best places to visit.",
                 "Leading chatbot/conversational AI startups worldwide in 2023, by funding raised (in million U.S. dollars) [Graph], NFX, February 14, 2024. [Online]. Available: https://www.statista.com/statistics/1359073/chatbot-and-conversational-ai-startup-funding-worldwide/", plot=1)
  })
  
  observeEvent(input$phase5, {
    create_popup("phase5", "Post-Travel Experience", 
                 "Elite loyalty members are typically high-spending travelers who are more inclined to make supplier-direct 
                 bookings. But while many online travel agencies (OTAs) and other technology companies have released generative AI tools, 
                 suppliers generally have yet to do so. As a result, travel suppliers without generative AI capabilities may start to lose 
                 direct booking share among their most valuable customers or, even worse, risk losing those loyal customers to competing 
                 brands who incorporate generative AI capabilities into their own channels. Of the loyalty members who recently used the technology, 86% were satisfied or 
                 very satisfied with the quality of the recommendations they received, and 64% booked all or most of them. Given that generative AI is still in its infancy, 
                 that is a very strong vote of confidence from a seasoned and knowledgeable customer base.",
                 "GENERATIVE AI HAS INTRIGUED THE MOST DEDICATED TRAVELERS - Oliver Wyman, Exhibit 2", plot=1)
  
    })
  
  
  # Output dei grafici per ogni fase
  output$plot_phase1 <- renderPlotly({
    # Define the data
    satisfaction <- data.frame(
      Category = c("Very dissatisfied", "Dissatisfied", "Neutral", "Satisfied", "Very satisfied"),
      Percentage = c(1, 1, 14, 45, 39)
    )
    
    # Find the maximum percentage value
    max_percentage <- max(satisfaction$Percentage)
    
    # Create a new column for fill color
    satisfaction$Fill <- ifelse(satisfaction$Percentage == max_percentage, "#00a6a6", "#bbdef0")
    
    # Create ggplot object
    p <- ggplot(satisfaction, aes(x = reorder(Category, Percentage), y = Percentage, fill = Fill)) +
      geom_bar(stat = "identity") +
      scale_fill_identity() +  # Use identity scale for fill
      labs(title = "Satisfaction with Generative AI's recommendation quality",
           subtitle = "% of leisure travelers with prior Generative AI use",
           x = NULL, y = NULL) +
      coord_flip() +
      theme_minimal() +
      theme(legend.position = "none",  # Remove legend
            panel.grid.major = element_blank(),  # Remove major gridlines
            panel.grid.minor = element_blank()) +  # Remove minor gridlines
      guides(fill = "none")  # Correctly use "none" instead of FALSE
    
    # Convert ggplot to plotly
    ggplotly(p)
  })
  
  
  output$plot_phase2 <- renderPlotly({
    data <- data.frame(
      Capability = c("Intuitive user experience", "Access to user review data",
                     "Robust security/data privacy protections", "Ability to book vacation packages",
                     "Ability to search for pricing/pay in cash or loyalty currency",
                     "Ability to integrate with loyalty programs", "Ability to book all trip elements in one place",
                     "Comparative pricing"),
      Percentage = c(17, 21, 23, 32, 40, 41, 50, 76)
    )
    data <- data[order(data$Percentage, decreasing = FALSE), ]
    data$Capability <- factor(data$Capability, levels = data$Capability)
    colors <- ifelse(data$Percentage == max(data$Percentage), "#00a6a6", "#bbdef0")
    plot_ly(data, x = ~Percentage, y = ~Capability, type = "bar", orientation = "h",
            marker = list(color = colors)) %>%
      layout(title = "Relative importance of Generative AI capabilities",
             titlefont = list(size = 16),
             margin = list(t = 50),  # Aggiunto margine superiore
             xaxis = list(title = "% leisure travelers"),
             yaxis = list(title = ""))
  })
  
  # output$plot_phase3 <- renderPlotly({
  #   # Your plot creation code for phase 3
  # })
  
  output$plot_phase4 <- renderPlotly({
    # Create data frame
    data <- data.frame(
      Company = c("ASAPP", "Moveworks", "Poe by Quora", "Observe.ai", "Ada", "Cresta", "Woebot Health", "Forethought", "Ushur", "Kasisto"),
      Funding = c(380, 305, 226, 214, 190.6, 151, 123.3, 92, 92, 81.5)
    )
    
    # Sort data frame by Funding in descending order
    data <- data[order(data$Funding), ]
    
    # Darken the longest bar
    max_funding <- max(data$Funding)
    colors <- ifelse(data$Funding == max_funding, "#00a6a6", "#bbdef0")
    
    fig <- plot_ly(data, y = factor(data$Company, levels = data$Company), x = ~Funding, type = "bar", marker = list(color = colors))
    fig <- fig %>% layout(title = "Leading Chatbot AI Startups by funding raised", yaxis = list(tickangle = -45, tickfont = list(size = 10)), xaxis = list(title = "Funding in million U.S. dollars"))
    
    fig
  })
  
  output$plot_phase5 <- renderPlotly({
    data <- data.frame(
      Recommendations_Booked = c("None of its recommendations", "A minority of its recommendations", "Neutral", "Most of its recommendations", "All of its recommendations"),
      Recommendations_Percentage = c(5, 5, 27, 35, 29)
    )
    recommendations_order <- c("None of its recommendations", "A minority of its recommendations", "Neutral", "Most of its recommendations", "All of its recommendations")
    data$Recommendations_Booked <- factor(data$Recommendations_Booked, levels = recommendations_order)
    plot_recommendations <- ggplot(data, aes(x = Recommendations_Percentage, y = fct_reorder(Recommendations_Booked, Recommendations_Percentage))) +
      geom_bar(stat = "identity", fill = ifelse(data$Recommendations_Percentage == max(data$Recommendations_Percentage), "#00a6a6", "#bbdef0")) +
      theme_minimal() + 
      theme(axis.line = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
      xlab("Percentage of members") +
      ylab("Recommendations Booked") +
      ggtitle("Recommendations Booked") +
      theme(plot.margin = margin(t = 30, r = 10, b = 10, l = 10))  # Aggiunto margine
    
    plot_recommendations <- ggplotly(plot_recommendations)
    plot_recommendations %>%
      layout(title = "Recommendations Booked", margin = list(t = 50), 
             xaxis = list(title = "Percentage of members"), 
             yaxis = list(title = "Recommendations Booked"))})
  
  
  
  
  
  
  # Apply custom palette to all plots
  outputOptions(output, "plot_phase1", suspendWhenHidden = FALSE)
  outputOptions(output, "plot_phase2", suspendWhenHidden = FALSE)
  outputOptions(output, "plot_phase4", suspendWhenHidden = FALSE)
  outputOptions(output, "plot_phase5", suspendWhenHidden = FALSE)

}
