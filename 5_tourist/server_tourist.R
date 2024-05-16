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
  
  # Prepare the main plot
  # Prepare the main plot
  output$main_plot <- renderPlotly({
    p <- ggplot(tools_by_phase, aes(x = phase, y = number_of_tools, fill = phase)) +
      geom_col() +
      labs(title = "Number of Tools for Each Phase",
           x = "Phase",
           y = "Number of Tools") +
      theme_minimal() +
      scale_fill_manual(values = custom_palette) +
      guides(fill = FALSE)
    
    ggplotly(p) %>%
      event_register("plotly_click") %>%
      onRender("
    function(el, x) {
      el.on('plotly_click', function(d) {
        var data = d.points[0].data;
        var phase = d.points[0].x;
        var tools = data.text[d.points[0].pointIndex].split('<br>')[2];
        var popup = $('<div></div>').attr('title', phase).html(tools);
        $(popup).dialog({
          height: 300,
          width: 400,
          modal: true
        });
      });
    }
  ")
  })
  
  
  
  
  
  
  
  create_popup <- function(id, title, description) {
    showModal(modalDialog(
      title = title,
      p(description),
      plotlyOutput(paste0("plot_", id)),
      easyClose = TRUE,
      footer = NULL
    ))
  }
  
  observeEvent(input$phase1, {
    create_popup("phase1", "Dreaming and Research Phase", "
    Generative AI-powered chatbots and virtual assistants are being used by travel companies to provide personalized trip inspiration and recommendations based on user preferences and past behavior.
    AI-generated content, such as descriptive travel blogs, social media posts, and promotional materials, can influence traveler's dreaming and research phases by showcasing destinations and experiences in an engaging and visually appealing manner.
    According to a study by Phocuswright, 38% of travelers use virtual assistants or chatbots for researching travel destinations and seeking inspiration.
    A report by Tractica suggests that the global market for AI-generated content, including travel blogs and promotional materials, is expected to reach $42.7 billion by 2028, growing at a CAGR of 29.7%."
    )
  })
  
  observeEvent(input$phase2, {
    create_popup("phase2", "Planning and Booking Phase", "
    Generative AI models are being used by OTAs and travel companies to generate personalized travel itineraries, taking into account user preferences, budget, and other constraints.
    AI-powered natural language processing (NLP) and conversational AI assistants can help travelers plan and book their trips more efficiently by understanding complex queries and providing relevant recommendations.
    A survey by Travelport found that 57% of travelers are willing to use AI-powered trip planning tools, and 38% would consider booking through an AI-powered travel agent.
    According to a report by Drift, travel companies that use conversational AI assistants see an average increase of 28% in customer satisfaction rates during the booking phase."
    )
  })
  
  observeEvent(input$phase3, {
    create_popup("phase3", "Pre-Travel Experience", "
    AI-generated content, such as virtual tours, 360-degree videos, and immersive experiences, can enhance the pre-travel experience by allowing travelers to preview destinations and attractions before their trip.
    Generative AI models can create personalized pre-trip guides, packing lists, and travel tips tailored to individual travelers' needs and preferences.
    A study by Forrester Research indicates that 54% of travelers are interested in using virtual reality (VR) or augmented reality (AR) experiences to preview destinations and attractions before their trip.
    According to a report by Salesforce, 62% of travel companies are already using AI-powered personalization for pre-trip communications and content."
    )
  })
  
  observeEvent(input$phase4, {
    create_popup("phase4", "On-Trip Experience", "
    AI-powered language translation and interpretation services can facilitate communication between travelers and locals, enhancing the on-trip experience.
    Generative AI models can provide real-time recommendations for activities, restaurants, and attractions based on the traveler's location, preferences, and real-time data.
    A survey by Booking.com found that 49% of travelers would be interested in using real-time translation services powered by AI during their trip.
    A report by Skift suggests that the global market for AI-powered travel recommendations and personalization is expected to reach $2.9 billion by 2025, growing at a CAGR of 27.3%."
    )
  })
  
  observeEvent(input$phase5, {
    create_popup("phase5", "Post-Travel Experience", "
    AI-powered content generation tools can help travelers create personalized travel journals, photo albums, and videos, capturing their experiences in a visually appealing and engaging manner.
    Generative AI models can analyze traveler feedback and reviews, helping travel companies understand customer sentiment and identify areas for improvement.
    A study by Adobe found that 66% of travelers are interested in using AI-powered tools to create personalized travel journals, photo albums, or videos after their trip.
    According to a report by Capgemini, travel companies that leverage AI for sentiment analysis and customer feedback can achieve up to 25% improvement in customer satisfaction scores."
    )
  })
  
  # Output dei grafici per ogni fase
  output$plot_phase1 <- renderPlotly({
    p <- plot_ly(x = ~rnorm(100), type = "histogram") %>%
      layout(title = "Plot Phase 1") %>%
      config(displayModeBar = FALSE)
    
    ggplotly(p) %>%
      layout(title = "Plot Phase 1") %>%
      config(displayModeBar = FALSE)
  })
  
  output$plot_phase2 <- renderPlotly({
    p <- plot_ly(x = ~rnorm(100), type = "histogram") %>%
      layout(title = "Plot Phase 2") %>%
      config(displayModeBar = FALSE)
    
    ggplotly(p) %>%
      layout(title = "Plot Phase 2") %>%
      config(displayModeBar = FALSE)
  })
  
  output$plot_phase3 <- renderPlotly({
    p <- plot_ly(x = ~rnorm(100), type = "histogram") %>%
      layout(title = "Plot Phase 3") %>%
      config(displayModeBar = FALSE)
    
    ggplotly(p) %>%
      layout(title = "Plot Phase 3") %>%
      config(displayModeBar = FALSE)
  })
  
  output$plot_phase4 <- renderPlotly({
    p <- plot_ly(x = ~rnorm(100), type = "histogram") %>%
      layout(title = "Plot Phase 4") %>%
      config(displayModeBar = FALSE)
    
    ggplotly(p) %>%
      layout(title = "Plot Phase 4") %>%
      config(displayModeBar = FALSE)
  })
  
  output$plot_phase5 <- renderPlotly({
    p <- plot_ly(x = ~rnorm(100), type = "histogram") %>%
      layout(title = "Plot Phase 5") %>%
      config(displayModeBar = FALSE)
    
    ggplotly(p) %>%
      layout(title = "Plot Phase 5") %>%
      config(displayModeBar = FALSE)
  })
  
  # Apply custom palette to all plots
  outputOptions(output, "plot_phase1", suspendWhenHidden = FALSE)
  outputOptions(output, "plot_phase2", suspendWhenHidden = FALSE)
  outputOptions(output, "plot_phase3", suspendWhenHidden = FALSE)
  outputOptions(output, "plot_phase4", suspendWhenHidden = FALSE)
  outputOptions(output, "plot_phase5", suspendWhenHidden = FALSE)

}
