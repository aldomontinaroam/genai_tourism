# UI for Travel Agencies page
travel_agencies_ui <- fluidPage(
  
  titlePanel("Online vs Traditional Travel Market"),
  sidebarLayout(
    sidebarPanel(
      h4("Insight"),
      p(""),
      h4("Plots"),
      p("Online Travel Market. Source: Statista"),
      p("Global Online Travel Agencies. Source: Statista"),
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Market Size", plotOutput("online_travel_market_plot") ),
        tabPanel("OTA share", plotOutput("ota_revenue_plot"))
      )
      
    )
  ),
  
  titlePanel("OTA Projects"),
  sidebarLayout(
    sidebarPanel(
      h4("Insight"),
      p(""),
      h4("Plots"),
      p("Online Italian Market. Source: Statista"),
      selectInput("color_var", "Select features:", choices = c("group", "type", "provider"))
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Projects", plotOutput("ota_projects_plot"))
      )
    )
  ),

  titlePanel("Comparing with the Italian Travel Agencies"),
  sidebarLayout(
    sidebarPanel(
      h4("Insight"),
      p(""),
      h4("Plots"),
      p("Status of Italian Travel Agencies. Source Istat"),
      selectInput("ta_var", "Italian Travel Agency Variable", choices = c("number", "revenue", "employed")),
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("TA in Italy", plotOutput("italian_ta_plot")),
      )
    )
  )
)

###
#"Status quo: Constant booking share across travel supplier subsectors", 
#"Scenario 1: No travel supplier GenAI investment",
#"Scenario 2: Moderate travel supplier GenAI investment",
#"Scenario 3: Significant travel supplier GenAI investment"