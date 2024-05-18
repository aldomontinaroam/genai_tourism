# UI for Travel Agencies page
travel_agencies_ui <- fluidPage(
  
  titlePanel("Online vs Traditional Travel Market"),
  sidebarLayout(
    sidebarPanel(
      h4("Insights"),
      p("After Covid, the Online Travel Global Market is expected to grow systematically.
        Bigger players are getting even bigger.
        Italian traditional agencies are recovering quite well."),
      h4("Sources"),
      p(em("Statista, Istat, ilsole24ore"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Market Size", plotOutput("online_travel_market_plot") ),
        tabPanel("Revenues", plotOutput("ota_revenue_plot"))
      )
      
    )
  ),
  
  titlePanel("OTA Projects"),
  sidebarLayout(
    sidebarPanel(
      h4("Insights"),
      p("OTAs are aware of the GenAI revolution and they are investing to keep their positions.
      First they experimented with low-cost plugins, now they are building full applications.
        Smaller players are emerging, but we could expect acquisitions as often happened in the past."),
      radioGroupButtons(
        inputId = "color_var",
        label = "Select feature:", 
        choices = c("group", "type", "provider"),
        status = "primary"
      ),
      #selectInput("color_var", "Select feature:", choices = c("group", "type", "provider")),
      h4("Sources"),
      p(em("Various Company Announcements"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Projects", plotOutput("ota_projects_plot"))
      )
    )
  ),

  titlePanel("Status of Italian Travel Agencies"),
  sidebarLayout(
    sidebarPanel(
      h4("Insights"),
      p("Travel Agencies are recovering after covid, as seen also above, but the number of companies and empoyees is slowly decreasing."),
      radioGroupButtons(
        inputId = "ta_var",
        label = "Italian Travel Agency Variable", 
        choices = c("number", "revenue", "employed"),
        status = "primary"
      ),
      #selectInput("ta_var", "Italian Travel Agency Variable", choices = c("number", "revenue", "employed")),
      p("Show Italian Travel Agencies revenue in OTAs Plot"),
      materialSwitch(
        inputId = "show_italian_data",
        label = "Show Italian Data",
        status = "primary",
        right = TRUE
      ),
      h4("Sources"),
      p(em("Istat"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Italian Agencies", plotOutput("italian_ta_plot")),
      )
    )
  )
)

###
#"Status quo: Constant booking share across travel supplier subsectors", 
#"Scenario 1: No travel supplier GenAI investment",
#"Scenario 2: Moderate travel supplier GenAI investment",
#"Scenario 3: Significant travel supplier GenAI investment"