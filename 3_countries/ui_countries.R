countries_ui <- fluidPage(
  titlePanel("Countries"),
  sidebarLayout(
    sidebarPanel(
      # Add sidebar components as needed
      conditionalPanel(
        condition = "input.tabs == 'Planned Use'",
        h5("Country Analysis"),
        hr(),
        p("Greece and France are the most skeptical, with around three-quarters of respondents in each stating that they do not plan to use AI. Germany, Austria, the Netherlands, and Portugal host more AI pioneers, with around a third of hoteliers in these countries reporting openness to try this novel technology."
          ),
        p(strong("Source:")),"European Accommodation Barometer Fall 2023 - Statista x Booking.com"
      ),
      conditionalPanel(
        condition = "input.tabs == 'Patents'",
        h5("Patent Analysis"),
        hr(),
        p("As for patents on generative AI in tourism, from 2022 to now, they are mostly pending, although we find many active ones. \n\n Source: Lens.org \n\n The key concept expressed in the patents concerns images, thus likely referring to automatic methods of content creation. 
          "),
        p(strong("Source:")),"Lens.org"
      )
    ),
    mainPanel(
      tags$style(HTML("
            #plotrow {
              margin: 20px;
              padding: 20px;
            }
            #second {
              border: 2px dashed blue;
            }
            #titlediv h4{
              font-weight: bold;
              font-size: 20px;
              text-align: center;
              margin-top: 20px;
              margin-bottom: 10px;
              margin-left: auto;
              margin-right: auto;
            }
            #planned_use {
              height:600px !important;
            }
            ")),
      tabsetPanel(
        id = "tabs",
        tabPanel("Planned Use",
                 id="planned_use",
                 div(
                   id="titlediv",
                   h4("Current use of AI/planned use of AI in the next 6 months"),
                 ),
                 plotOutput("countries_plot")),
        tabPanel("Patents",
                 div(
                   id="titlediv",
                   h4("Legal Status of Patents (2022-2024)"),
                 ),
                 plotlyOutput("trend_plot"),
                 div(
                   id="titlediv",
                   h4("Key Words in Patents (2022-2024)"),
                 ),
                 plotOutput("wordcloud_plot")
        )
      )
    )
  )
)