# Server logic for Rights page
use_genai <- read_csv("6_rights/data/use_genai.csv")

satisfaction_genai <- read.csv("6_rights/data/satisfaction_genai.csv")

sentiment_twitter <- read_csv("6_rights/data/sentiment_twitter.csv")

benchmark_genai <- read.csv("6_rights/data/genai_benchmark_tidy.csv")


rights_server <- function(input, output) {
  
  ### data
  use_genai <- read_csv("6_rights/data/use_genai.csv")
  
  satisfaction_genai <- read.csv("6_rights/data/satisfaction_genai.csv")
  
  sentiment_twitter <- read_csv("6_rights/data/sentiment_twitter.csv")
    
  benchmark_genai <- read.csv("6_rights/data/genai_benchmark_tidy.csv")
  
  ### utils
  library(DT)
  
  custom_palette <- c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700")
  
  
  filter_benchmark <- reactive({
    benchmark_genai %>% 
      # setting,method,llm,set,metric
      filter(setting %in% input$setting) %>%
      filter(method %in% input$method) %>%
      filter(llm %in% input$llm) %>%
      filter(set %in% input$set) %>%
      filter(metric %in% input$metric)
  })
  
  ### plots
  
  ### PART 1
  
  output$use_genai_plot <- renderPlot({
    ggplot(use_genai, aes(x=1, y=value, fill=answer)) +
      geom_bar(stat = "identity", width = 0.8) +
      coord_flip() +
      scale_fill_manual(values=custom_palette) +
      labs(x = NULL, y = NULL, 
           title = "Recently used Generative AI for travel inspiration, planning, or booking",
           subtitle = "Share of leisure travelers who recently used GenAI for travel inspiration, planning, or booking in the US and Canada as of August 2023") +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
        plot.subtitle = element_text(hjust = 0.5, size = 16),
        legend.position = "none",
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()
      ) +
      geom_text(aes(label = paste0(answer, '\n', value, "%")), 
                position = position_stack(vjust = 0.5), 
                size = 10, color = "black")
  })
  

  output$satisfaction_genai_plot <- renderPlot({
    ggplot(satisfaction_genai, aes(x=fct_reorder(satisfaction,value), y=value)) +
      geom_col(stat="identity", width=0.8, fill=custom_palette[1]) +
      coord_flip() +
      labs(x = NULL, y = NULL, 
           title = "Satisfaction with genAI recommendation quality",
           subtitle = "Satisfaction with genAI recommendation quality among leisure travelers in the US and Canada as of August 2023") +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
        plot.subtitle = element_text(hjust = 0.5, size = 16),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 16),
        legend.position = "none",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()) +
      geom_text(aes(label = paste0(value, "%")), 
                position = position_stack(vjust = 0.5), 
                size = 8, color = "black")
  })
  
  output$sentiment_twitter_plot <- renderPlot({
    ggplot(sentiment_twitter, aes(x=bin_edges, y=counts),  fill = custom_palette[1]) +
      geom_bar(stat="identity", width=0.1, fill=custom_palette[1]) +
      labs(x = "Sentiment",
           y = "Number of Tweets",
           title = "Sentiment of Tweets on Travel and Tourism",
           subtitle = "") +
      theme_minimal(base_size = 15) +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
        plot.subtitle = element_text(hjust = 0.5, size = 16),
        axis.text.x = element_text(hjust = 1),
        axis.text.y = element_text(face = "bold"),
        legend.position = "top",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank())
    
    
  })
  
  ### PART 2
  
  output$benchmark_genai_table <- renderDataTable({
    datatable(filter_benchmark())
  })
  
  output$benchmark_genai_plot <- renderPlot({
    ggplot(filter_benchmark(), aes(x=llm, y=value, fill=metric)) +
      geom_col(stat="identity", width=0.8, color="black") +
      coord_flip() +
      scale_fill_manual(values=custom_palette) +
      labs(x = NULL, y = NULL,
           title = "Generative AI Benchmark Metrics",
           subtitle = "") +
      facet_wrap(~ metric, scales = "free_y") +
      theme_minimal(base_size = 15) +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        plot.subtitle = element_text(hjust = 0.5, size = 12),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_text(face = "bold"),
        legend.position = "bottom",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()
      ) +
      geom_text(aes(label = paste0(value, "%")), position = position_stack(vjust = 0.5), size = 5, color = "black")
  })
}  
  
  ### DEPRECATED
  
# benchmark_genai_wrong <- read.csv("6_rights/data/genai_benchmark.csv") %>%
#   pivot_longer(
#     cols = starts_with("validation_"):starts_with("test_"),
#     names_to = c("set", "metric"),
#     names_pattern = "(validation|test)_(.*)",
#     values_to = "value")


  # filter_benchmark_OLD <- reactive({
  #   benchmark_genai %>% 
  #     # setting,method,llm,set,metric
  #     filter(setting == input$setting) %>%
  #     filter(method == input$method) %>%
  #     filter(llm == input$llm) %>%
  #     filter(set == input$set) %>%
  #     filter(metric == input$metric)
  # })




  # output$benchmark_genai_plot_OLD <- renderPlot({
  #   ggplot(filter_benchmark(), aes(x = llm)) +
  #     geom_bar(aes(y = validation_delivery_rate), stat = "identity", fill = "skyblue", position = "dodge") +
  #     geom_bar(aes(y = test_delivery_rate), stat = "identity", fill = "steelblue", position = "dodge", alpha = 0.7) +
  #     labs(
  #       title = paste("Performance of LLM", input$setting),
  #       x = "LLM",
  #       y = "Delivery Rate",
  #       fill = "Metric"
  #     ) +
  #     ggtitle("Main results of different LLMs and planning strategies on the TravelPlanner validation and test set.")
  #     theme_minimal() +
  #     theme(axis.text.x = element_text(angle = 45, hjust = 1))
  # })
  
