# Server logic for Travel Agencies page
travel_agencies_server <- function(input, output) {
  
  # loading data

  online_travel_market <- read_csv("1_ota/data/online_travel_market_forecast.csv")
  
  ota_revenue <- read_csv("1_ota/data/ota_revenues.csv")
  
  ota_projects <- read_csv("1_ota/data/ota_projects.csv")
  
  italian_ta <- read.csv("1_ota/data/italy_ta_istat.csv")
  
  
  
  ### utils
  custom_palette <- c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700")
  
  font_size = 16
  
  select_ta_var <- function(){
    italian_ta %>%
      filter(select == input$ta_var)
  }
  
  subtitle_ita <- reactive({
    switch(input$ta_var,
      "number" = "Number",
      "revenue" = "Revenue",
      "employed" = "Employees",
      "")
  })
  
  subtitle_project <- reactive({
    switch(input$color_var,
       "type" = "Implementation",
       "group" = "Financial Group/Holding",
       "provider" = "Provider of API",
       "")
  })
  
  filtered_revenue <- reactive({
    if (input$show_italian_data) {
    ota_revenue
  } else {
    ota_revenue %>%
      filter(company != "(Italian Travel Agencies)")
  }
  })
  
  ### plots
  
  
### PART 1 
  
  output$online_travel_market_plot <- renderPlot({
    
    ggplot(online_travel_market, aes(x = Year, y = Value)) +
      geom_col(fill=custom_palette[1]) +
      geom_text(aes(label = Value), vjust = -0.5, size = 6) +
      labs(x = NULL, y = NULL, 
           title = "Online travel market size worldwide",
           subtitle = "by revenue in billion U.S. dollars") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 20, hjust = 0.5),
        plot.subtitle = element_text(size = 16, hjust = 0.5),
        axis.text.y = element_blank(),
        legend.position = "top",
        legend.text = element_text(size = 16),
        legend.title = element_text(size = 16),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) +
      # Ensure all years are displayed on the x-axis
      scale_x_continuous(breaks = seq(min(online_travel_market$Year), max(online_travel_market$Year), by = 1))
  })
  
  output$ota_revenue_plot <- renderPlot({
    
    ggplot(filtered_revenue(), aes(x = year, y = value, color = factor(company), linetype = ifelse(company == "(Italian Travel Agencies)", "solid", "dashed"))) +
      geom_line(size = 1.5) +
      labs(x = NULL, y = NULL, 
           title = "Comparing Global Online Travel Agencies",
           subtitle = "revenue in millions",
           color = "Company") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 20, hjust = 0.5),
        plot.subtitle = element_text(size = 16, hjust = 0.5),
        legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(size = 16),
        legend.key = element_blank()
      )
  })
  
  
  ### PART 2
  
  output$ota_projects_plot <- renderPlot({
  
    ggplot(ota_projects, aes(x = date, y = reorder(company, date), color = .data[[input$color_var]])) +
      geom_text(aes(label = project), hjust = -0.1, size = 6) +
      labs(title = "GenAI Projects by OTAs",
           x = NULL, y = NULL,
           subtitle = subtitle_project()) +
      scale_x_date(date_breaks = "3 month", date_labels = "%Y-%m-%d") +  # Set breaks and labels for x-axis
      coord_cartesian(xlim = c(min(ota_projects$date), max("2024-08-01")))+
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 20, hjust = 0.5),
        plot.subtitle = element_text(size = 16, hjust = 0.5),
        legend.position = "top",
        legend.text = element_text(size = 16),
        legend.title = element_text(size = 16)
      )
    
  })
  
  ### PART 3
  
  output$italian_ta_plot <- renderPlot({
    
    ggplot(select_ta_var(), aes(x = as.factor(year), y = value)) +
      geom_bar(fill=custom_palette[1], stat = "identity", position = "dodge") +
      geom_text(aes(label = value), vjust = -0.5, size = 6) +
      labs(x = NULL, y = NULL, fill = "Select",
           title = "Features of Italian Travel Agencies",
           subtitle = subtitle_ita()) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 20, hjust = 0.5),
        plot.subtitle = element_text(size = 16, hjust = 0.5),
        axis.text.y = element_blank(),
        legend.position = "top",
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()
      )
  })
  
}


