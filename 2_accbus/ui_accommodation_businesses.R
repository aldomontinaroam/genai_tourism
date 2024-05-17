# UI for Accommodation Businesses page
accommodation_businesses_ui <- fluidPage(
  
  titlePanel("Why accommodation?"),
  sidebarLayout(
    sidebarPanel(
      h4("Insight"),
      p("With this chart, we want to illustrate why we have decided to focus on the accommodation
business. As clearly shown, the majority of online travel bookings are made for hotels."),
      h4("Plots"),
      p("")
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
      h4("Insight"),
      p("Here, we want to demonstrate how much the accommodation business is investing in digital
technology, what specific areas they are focusing on, and, most importantly, how much they plan
to invest in generative AI."),
      h4("Plots"),
      p("")
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
      h4("Insight"),
      p("We have presented forecasts for OTAs regarding the share of direct bookings by suppliers in the online
travel market and the commissions paid by suppliers to OTAs for indirect bookings, reflecting different
levels of investment by travel suppliers in AI:"),
      h4("Plots"),
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
  ),
)
