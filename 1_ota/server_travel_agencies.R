# Server logic for Travel Agencies page
travel_agencies_server <- function(input, output) {
  
  # loading data

  online_travel_market <- read_csv("1_ota/data/online_travel_market_forecast.csv")
  
  ota_revenue <- read_csv("1_ota/data/ota_revenues.csv")
  
  ota_projects <- read_csv("1_ota/data/ota_projects.csv")
  
  italian_ta <- read.csv("1_ota/data/italy_ta_istat.csv")
  
  
  
  ### utils
  font_size = 16
  
  select_ta_var <- function(){
    italian_ta %>%
      filter(select == input$ta_var)
  }
  
  ### plots
  
  output$online_travel_market_plot <- renderPlot({
    
    ggplot(online_travel_market, aes(x = Year, y = Value)) +
      geom_col() +
      labs(x = NULL, y = "Value", title = "Online travel market size worldwide") +
      ggtitle("from 2017 to 2023, with a forecast until 2028 (in billion U.S. dollars)") +
      theme(axis.text.x = element_text(size = font_size),  # Increase x-axis label font size
            axis.text.y = element_text(size = font_size),  # Increase y-axis label font size
            legend.text = element_text(size = font_size),  # Increase legend font size
            legend.title = element_text(size = font_size))
  })
  
  output$ota_revenue_plot <- renderPlot({
    
    ggplot(ota_revenue, aes(x = year, y = value, color = factor(company))) +
      geom_line() +
      labs(x = NULL, y = "Value", title = "Comparing Global OTAs with Italian Travel Agencies") +
      ggtitle("Total revenue in millions") +
      theme(axis.text.x = element_text(size = font_size),  # Increase x-axis label font size
            axis.text.y = element_text(size = font_size),  # Increase y-axis label font size
            legend.text = element_text(size = font_size),  # Increase legend font size
            legend.title = element_text(size = font_size))
  })
  
  output$ota_projects_plot <- renderPlot({
  
    ggplot(ota_projects, aes(x = date, y = reorder(company, date), color = .data[[input$color_var]])) +
      geom_text(aes(label = project), hjust = -0.1, size = 4) +
      labs(title = "GenAI Projects by OTAs",
           x = NULL, y = "Company", color = input$color_var) +
      ggtitle("Interactive timeline of projects") +
      theme_minimal() +
      coord_cartesian(xlim = c(min(ota_projects$date), max("2024-08-01")))+
      theme(axis.text.x = element_text(size = font_size),  # Increase x-axis label font size
            axis.text.y = element_text(size = font_size),  # Increase y-axis label font size
            legend.text = element_text(size = font_size),  # Increase legend font size
            legend.title = element_text(size = font_size))
    
  })
  
  output$italian_ta_plot <- renderPlot({
    
    ggplot(select_ta_var(), aes(x = as.factor(year), y = value)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Year", y = "Value", fill = "Select") +
      theme_minimal() +
      theme(legend.position = "bottom")  # Move legend to the bottom
  })
  
  
  
  ### experiments
  
  output$ota_revenue_COL_plot <- renderPlot({
    
    ggplot(ota_revenue, aes(x = year, y = value, color = factor(company))) +
      geom_col() +
      labs(x = NULL, y = "Value", title = "Comparing Global OTAs with Italian Travel Agencies") +
      ggtitle("Total revenue in millions") +
      theme(axis.text.x = element_text(size = font_size),  # Increase x-axis label font size
            axis.text.y = element_text(size = font_size),  # Increase y-axis label font size
            legend.text = element_text(size = font_size),  # Increase legend font size
            legend.title = element_text(size = font_size))
  })
  
  
  
  
}











