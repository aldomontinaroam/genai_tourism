# Server logic for Accommodation Businesses page
accommodation_businesses_server <- function(input, output) {
  
  ### loading data
  
  ota_share <- read_csv("2_accbus/data/ota_share_tidy.csv") 
  
  ota_commissions <- read_csv("2_accbus/data/ota_commissions_tidy.csv")
  
  accbus_digital_investments <- read_csv("2_accbus/data/acc_bus_digital_investments.csv") %>%
    arrange(value) %>%
    mutate(intention = factor(intention, levels=c("less", "same", "more", "not_sure"))) %>%
    mutate(season = factor(season, levels=c("Autumn 2022","Summer 2023", "Autumn 2023")))
  
  accbus_ai_intentions <- read_csv("2_accbus/data/acc_bus_ai_interest.csv") %>%
    arrange(value) %>%
    mutate(intention = factor(intention, levels=c("use", "planned", "no", "not_know"))) %>%
    mutate(season = factor(season, levels=c("Summer 2023", "Autumn 2023")))
  
  accbus_digital_topics <- read_csv("2_accbus/data/accbus_digital_topics.csv")
  
  online_booking_products <- read_csv("2_accbus/data/online_booking_products.csv")
  
  ### plotting
  
  color_palette <- c("#0072B2", "#D55E00", "#CC79A7", "#999999")
  
  ### PART 3
  
  output$ota_share_plot <- renderPlot({
    ggplot(ota_share, aes(x = year, y = value, color = factor(scenario))) +
      geom_line(size = 1.2) +
      labs(
        x = "Year", 
        y = "Value", 
        title = "Scenario analysis of OTA booking share",
        subtitle = "% of U.S. online travel bookings (airline seats, hotel sleeping rooms, cruise cabins)"
      ) +
      scale_color_manual(values = color_palette, name = "Scenario") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "bottom"
      )
  })
  
  output$ota_commissions_plot <- renderPlot({
    ggplot(ota_commissions, aes(x = year, y = value, color = factor(scenario))) +
      geom_line(size = 1.2) +
      labs(
        title = "Incremental OTA commissions paid by U.S. travel suppliers ($MN)",
        subtitle = "Annual increase / (decrease) vs. status quo"
      ) +
      scale_color_manual(values = color_palette, name = "Scenario") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "bottom"
      )
  })
  
  ### PART 2
  
  output$accbus_digital_investments_plot<- renderPlot({
    
    # Create the plot
    ggplot(accbus_digital_investments, aes(x = season, y = value, fill = intention)) +
      
      # Column plot with fill
      geom_col(position = "fill") +
      
      # Add text labels
      geom_text(aes(label = paste0(value, "%")), 
                position = position_fill(vjust = 0.5), 
                size = 4, 
                color = "white") +
      
      # Custom color and labels for fill
      scale_fill_manual(values = color_palette,
                        labels = c("Invest Less", "Invest Same", "Invest More", "Don't Know"),
                        name = "Investment Plans for the Next 6 Months") +
      
      # Format y-axis as percentage
      scale_y_continuous(labels = scales::percent_format()) +
      
      # Title and other labels
      labs(title = "Digital Transformation Investment Plans for the Next 6 Months",
           x = NULL,
           y = "Percentage of Respondents",
           fill = NULL) +
      
      # Improve aesthetics
      theme_minimal() +
      theme(legend.position = "bottom",
            plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            legend.text = element_text(size = 12),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank())
    
  })
  
  
  
  output$accbus_ai_intentions_plot <- renderPlot({
    ggplot(accbus_ai_intentions, aes(x = season, y = value, fill = intention)) +
      geom_col(position="fill") +
      geom_text(aes(label = paste0(value, "%")), 
                position = position_fill(vjust = 0.5), 
                size = 4, 
                color = "white") +
      scale_fill_manual(values = color_palette,
                        labels = c("use",
                                   "planned",
                                   "no",
                                   "not_know"),
                        name = "Piani di investimento in AI") +
      scale_y_continuous(labels = percent_format()) +
      labs(title = "Piani di investimento",
           x = NULL,
           y = NULL,
           fill = NULL) +
      theme_minimal()+
      theme(legend.position = "bottom",
            plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            legend.text = element_text(size = 12),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank())
    
  })
  
  output$accbus_digital_topics_plot <- renderPlot({
    ggplot(accbus_digital_topics, aes(x = fct_reorder(topic, value), y = value, fill = season)) +
      geom_bar(stat = "identity", position = "dodge") +
      geom_text(aes(label = paste0(value, "%")), size = 4) +
      labs(title = "Most Important Digital Transformation Topics",
           x = "Topics",
           y = NULL,
           fill = "Season") +
      coord_flip() +
      theme_minimal() +
      theme(legend.position = "bottom",
            plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            legend.text = element_text(size = 12))
    
  })
  
  ### PART 1
  
  output$online_booking_products_plot <- renderPlot({
    ggplot(online_booking_products, aes(x = fct_reorder(type, value), y = value, fill="#D55E00")) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = scales::percent(value / 100, accuracy = 1)), 
                hjust = 1.1, size = 4, color = "white") +
      labs(
        title = "Travel Product Online Bookings in Italy 2023",
        x = NULL,
        y = NULL,
      ) +
      coord_flip() +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = "none",
        axis.text.x = element_text(size = 16),
        plot.title = element_text(face = "bold", hjust = 0.5)
      )
  })
  
  
}
