library(shiny)
library(leaflet)
library(wordcloud)
library(tm)
library(shinyWidgets)
library(tidyverse)
library(scales)

# Server logic for Accommodation Businesses page
server <- function(input, output) {
  
  ### loading data
  
  ota_share <- read_csv("data/ota_share_tidy.csv") 
  
  ota_commissions <- read_csv("data/ota_commissions_tidy.csv")
  
  accbus_digital_investments <- read_csv("data/acc_bus_digital_investments.csv") %>%
    arrange(value) %>%
    mutate(intention = factor(intention, levels=c("less", "same", "more", "not_sure"))) %>%
    mutate(season = factor(season, levels=c("Autumn 2022","Summer 2023", "Autumn 2023")))
  
  accbus_ai_intentions <- read_csv("data/acc_bus_ai_interest.csv") %>%
    arrange(value) %>%
    mutate(intention = factor(intention, levels=c("use", "planned", "no", "not_know"))) %>%
    mutate(season = factor(season, levels=c("Summer 2023", "Autumn 2023")))
  
  accbus_digital_topics <- read_csv("data/accbus_digital_topics.csv")
  
  online_booking_products <- read_csv("data/online_booking_products.csv")
  
  custom_palette <- c("#bbdef0", "#00a6a6", "#efca08", "#f49f0a", "#f08700")
  
  ### PART 1
  
  output$online_booking_products_plot <- renderPlot({
    ggplot(online_booking_products, aes(x = fct_reorder(type, value), y = value)) +
      geom_bar(stat = "identity", fill = custom_palette[1], width = 0.8) +
      geom_text(aes(label = percent(value / 100, accuracy = 1)), 
                hjust = -0.2, size = 6, color = "black") +
      labs(
        title = "Travel Product Online Bookings in Italy 2023",
        subtitle = "% of online bookings made for that travel supplier",
        x = NULL,
        y = NULL,
      ) +
      coord_flip() +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = "none",
        axis.text.y = element_text(size = 17),
        axis.text.x = element_blank(),
        plot.title = element_text(face = "bold"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
      )
  })
  
  
  ### PART 2
  
  output$accbus_digital_investments_plot<- renderPlot({
    ggplot(accbus_digital_investments, aes(x = season, y = value, fill = intention)) +
      geom_col(position = "fill", width = 0.7) +
      geom_text(aes(label = paste0(value, "%")), 
                position = position_fill(vjust = 0.5), 
                hjust = -0.1,
                size = 6, 
                color = "black") +
      scale_fill_manual(values = custom_palette,
                        labels = c("Invest Less", "Invest Same", "Invest More", "Don't Know"),
                        name = "Investment Plans for the Next 6 Months") +
      scale_y_continuous(labels = percent_format()) +
      labs(title = "Digital Transformation Investment Plans for the Next 6 Months",
           subtitle ="Percentages of accommodation businesses intentions in digital investments",
           x = NULL,
           y = NULL,
           fill = NULL) +
      theme_minimal() +
      theme(legend.position = "top",
            plot.title = element_text(face = "bold", size = 16),
            axis.text = element_text(size = 16),
            axis.title = element_text(size = 16),
            legend.text = element_text(size = 16),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank())
    
  })
  
  
  output$accbus_digital_topics_plot <- renderPlot({
    ggplot(accbus_digital_topics, aes(x = fct_reorder(topic, value), y = value, fill = season)) +
      geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
      geom_text(aes(label = paste0(value, "%")), size = 4, position = position_dodge(width = 0.9), hjust = -0.1) +
      labs(title = "Digital Transformation Topics",
           subtitle = "Most important subjects for hoteliers when it comes to the digitalization of their businesses",
           x = NULL,
           y = NULL) +
      coord_flip() +
      scale_fill_manual(values = custom_palette, name = NULL) +
      theme_minimal() +
      theme(legend.position = "top",
            plot.title = element_text(face = "bold", size = 16),
            axis.text = element_text(size = 16),
            axis.title = element_text(size = 16),
            legend.text = element_text(size = 16),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank())
    
    
  })
  
  output$accbus_ai_intentions_plot <- renderPlot({
    ggplot(accbus_ai_intentions, aes(x = season, y = value, fill = intention)) +
      geom_col(position="fill", width = 0.5) +
      geom_text(aes(label = paste0(value, "%")), 
                position = position_fill(vjust = 0.5), 
                size = 6, 
                color = "black") +
      scale_fill_manual(values = custom_palette) +
      scale_y_continuous(labels = percent_format()) +
      labs(title = "Accommodation business use of AI",
           subtitle = "Current or planned use of AI by accommodation businesses",
           x = NULL,
           y = NULL,
           fill = NULL) +
      theme_minimal()+
      theme(legend.position = "top",
            plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
            axis.text = element_text(size = 16),
            axis.title = element_text(size = 16),
            legend.text = element_text(size = 16),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank())
    
  })
  
  ### PART 3
  
  output$ota_share_plot <- renderPlot({
    ggplot(ota_share, aes(x = year, y = value, color = factor(scenario))) +
      geom_line(size = 1.2) +
      labs(
        x = NULL, 
        y = NULL, 
        title = "Scenario analysis of OTA booking share",
        subtitle = "% of U.S. online travel bookings (airline seats, hotel sleeping rooms, cruise cabins)"
      ) +
      scale_color_manual(values = custom_palette, name = "Scenario") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "top"
      )
  })
  
  output$ota_commissions_plot <- renderPlot({
    ggplot(ota_commissions, aes(x = year, y = value, color = factor(scenario))) +
      geom_line(size = 1.2) +
      labs(
        x = NULL, 
        y = NULL, 
        title = "Incremental OTA commissions paid by U.S. travel suppliers ($MN)",
        subtitle = "Annual increase / (decrease) vs. status quo"
      ) +
      scale_color_manual(values = custom_palette, name = "Scenario") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "top"
      )
  })
  
}


# UI for Accommodation Businesses page
ui <- fluidPage(
  
  titlePanel("Why accommodation?"),
  sidebarLayout(
    sidebarPanel(
      h4("Insights"),
      p("With this chart, we want to illustrate why we have decided to focus on the accommodation
business. As clearly shown, the majority of online travel bookings are made for hotels."),
      h4("Sources"),
      p(em("Accommodation Barometers Fall 2023, by Statista in collaboration with Booking.com"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Products", plotOutput("online_booking_products_plot"))
      )
    )
  ),
  
  titlePanel("Accommodation Businesses Digital Investments"),
  sidebarLayout(
    sidebarPanel(
      h4("Insights"),
      p("Here, we want to demonstrate how much the accommodation business is investing in digital
technology, what specific areas they are focusing on, and, most importantly, how much they plan
to invest in generative AI."),
      h4("Sources"),
      p(em("Accommodation Barometers Fall 2023, by Statista in collaboration with Booking.com"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Digital Investments", plotOutput("accbus_digital_investments_plot")),
        tabPanel("Digital Topics",plotOutput("accbus_digital_topics_plot")),
        tabPanel("AI Investments", plotOutput("accbus_ai_intentions_plot"))
      )
    )
  ),
  
  titlePanel("Accommodation Businesses VS OTAs"),
  sidebarLayout(
    sidebarPanel(
      h4("Insights"),
      p("We have presented forecasts for OTAs regarding the share of direct bookings by suppliers in the online
travel market and the commissions paid by suppliers to OTAs for indirect bookings, reflecting different
levels of investment by travel suppliers in AI:"),
      h4("Sources"),
      p(em("Source: Oliver Wyman August 2023 Generative AI Travel & Leisure survey")),
      p("Scenario 0: Status quo
Scenario 1: Travel suppliers invest very little in alternatives
Scenario 2: Travel suppliers invest moderately in alternatives
Scenario 3: Travel suppliers invest heavily in alternatives")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("OTA Shares",plotOutput("ota_share_plot")),
        tabPanel("OTA Commissions",plotOutput("ota_commissions_plot"))
      )
    )
  )
)




shinyApp(ui, server)



