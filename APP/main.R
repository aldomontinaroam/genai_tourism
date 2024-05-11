library(shiny)

# Source UI and server scripts
source("ui.R")
source("server.R")

# Run the application
shinyApp(ui = ui, server = server)
