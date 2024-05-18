# UI for Accommodation Businesses page
accommodation_businesses_ui <- fluidPage(
  
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
      p("We have presented forecasts for OTAs regarding the share of direct bookings by suppliers in the online travel market and the commissions paid by suppliers to OTAs for indirect bookings, reflecting different levels of investment by travel suppliers in AI:"),
      tags$ul(
        tags$li("Scenario 0: Constant booking share across travel supplier subsectors"),
        tags$li("Scenario 1: No travel supplier GenAI investment"),
        tags$li("Scenario 2: Moderate travel supplier GenAI investment"),
        tags$li("Scenario 3: Significant travel supplier GenAI investment")
      ),
      h4("Sources"),
      p(em("Oliver Wyman August 2023 Generative AI Travel & Leisure survey"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("OTA Share", plotOutput("ota_share_plot")),
        tabPanel("OTA Commissions", plotOutput("ota_commissions_plot"))
      )
    )
  )
)
