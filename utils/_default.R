library(shiny)

# Server logic for Travel Agencies page
travel_agencies_server <- function(input, output) {
  output$travel_agencies_plot <- renderPlot({
    # Generate a mock plot for Travel Agencies
    plot(1:10, type = "o", col = "blue", xlab = "X-axis", ylab = "Y-axis", main = "Travel Agencies")
  })
}

# UI for Travel Agencies page
travel_agencies_ui <- fluidPage(
  titlePanel("Travel Agencies"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("travel_agencies_plot")
    )
  )
)


# Server logic for Accommodation Businesses page
accommodation_businesses_server <- function(input, output) {
  output$accommodation_businesses_plot <- renderPlot({
    # Generate a mock plot for Accommodation Businesses
    plot(1:10, type = "o", col = "red", xlab = "X-axis", ylab = "Y-axis", main = "Accommodation Businesses")
  })
}

# UI for Accommodation Businesses page
accommodation_businesses_ui <- fluidPage(
  titlePanel("Accommodation Businesses"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("accommodation_businesses_plot")
    )
  )
)


# Server logic for Countries page
countries_server <- function(input, output) {
  output$countries_plot <- renderPlot({
    # Generate a mock plot for Countries
    plot(1:10, type = "o", col = "green", xlab = "X-axis", ylab = "Y-axis", main = "Countries")
  })
}

# UI for Countries page
countries_ui <- fluidPage(
  titlePanel("Countries"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("countries_plot")
    )
  )
)

# UI for Public page
public_ui <- fluidPage(
  titlePanel("Public"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("public_plot")
    )
  )
)

# Server logic for Public page
public_server <- function(input, output) {
  output$public_plot <- renderPlot({
    # Generate a mock plot for Public
    plot(1:10, type = "o", col = "purple", xlab = "X-axis", ylab = "Y-axis", main = "Public")
  })
}

# Server logic for Tourist page
tourist_server <- function(input, output) {
  output$tourist_plot <- renderPlot({
    # Generate a mock plot for Tourist
    plot(1:10, type = "o", col = "orange", xlab = "X-axis", ylab = "Y-axis", main = "Tourist")
  })
}

# UI for Tourist page
tourist_ui <- fluidPage(
  titlePanel("Tourist"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("tourist_plot")
    )
  )
)

# Server logic for Rights page
rights_server <- function(input, output) {
  output$rights_plot <- renderPlot({
    # Generate a mock plot for Rights
    plot(1:10, type = "o", col = "brown", xlab = "X-axis", ylab = "Y-axis", main = "Rights")
  })
}

# UI for Rights page
rights_ui <- fluidPage(
  titlePanel("Rights"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
    ),
    mainPanel(
      plotOutput("rights_plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  call_modules <- function(module_server) {
    lapply(module_server, function(server_func) {
      server_func(input, output)
    })
  }
  
  
  # Call all server logic functions
  call_modules(list(
    travel_agencies_server,
    accommodation_businesses_server,
    countries_server,
    public_server,
    tourist_server,
    rights_server
  ))
}

# UI definitions
ui <- navbarPage(
  title = "Travel Dashboard",
  tabPanel("Travel Agencies", travel_agencies_ui),
  tabPanel("Accommodation Businesses", accommodation_businesses_ui),
  tabPanel("Countries", countries_ui),
  tabPanel("Public", public_ui),
  tabPanel("Tourist", tourist_ui),
  tabPanel("Rights", rights_ui)
)

# Run the application
shinyApp(ui = ui, server = server)
