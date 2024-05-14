source("6_rights/global_rights.R")

# UI for Rights page
rights_ui <- fluidPage(
  titlePanel("Impact of Generative AI in Tourism"),  
  sidebarLayout(  
    sidebarPanel(  
      selectInput("plotType", "Select Plot Type", choices = c("Consumer Sentiment", "Economic Impact", "Legal Issues", "Policies"))  
    ),  
    mainPanel(  
      plotlyOutput("plot")  
    )  
  )  
)
