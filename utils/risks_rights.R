library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidytext)
library(wordcloud)
library(RColorBrewer)
library(tm)

risks <- c("Disinformation created with generative AI may be used in ways that risk inciting targeted physical violence against specific individuals or groups, or destabilising societies in ways that risk inciting widespread, sporadic, or random violence",
           "Image and video generators may be used to create non-consensual sexualised content, including synthetic sexualised depictions of real, non-consenting individuals ('deepfake pornography') and/or depictions of violent sexual imagery.",
           "Generative AI models may produce derogatory or otherwise harmful outputs pertaining to people with marginalised identities, amplifying false and harmful stereotypes and facilitating various forms of discrimination throughout society.",
           "Training data ingested by generative AI models may contain personally identifying information and other types of sensitive or private information in ways associated with novel privacy concerns.",
           "Some generative AI models are trained on large quantities of text scraped from the internet, which may include sources that are intellectually protected.",
           "Generative AI models may directly reproduce the original works of others, further adversely impacting original authors' right to property.",
           "The online dissemination of false information created with generative AI may threaten the right to free thought and opinion of internet users who encounter that information without knowing that it is false or of synthetic origin.",
           "Generative AI audio and/or video deepfakes featuring false depictions of political figures or depictions of fictional events with political significance may negatively impact individuals' right to vote freely for candidates or causes of their choosing.",
           "Companies may replace workers with generative AI tools or pause hiring for roles that may be performed by generative AI in the future.",
           "Human creatives are at elevated risk of being displaced by generative AI-created content.",
           "Where generative AI systems fail to communicate to users about limitations on a system's performance or training data, this may also negatively impact the right to freedom of opinion.",
           "Generative AI may be leveraged by malicious actors to create false but convincing content that is weaponised in targeted ways to threaten free expression–for example, the use of generative AI-created disinformation to harass journalists or political opponents into self-censorship.")

risks_df <- data.frame(Risk = risks)

# Define UI
ui <- fluidPage(
  titlePanel("Human Rights Risks of Generative AI"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      wordcloud2Output("wordcloud"),
      plotOutput("bar_chart")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$wordcloud <- renderWordcloud2({
    word_freq <- risks_df %>% unnest_tokens(word, Risk) %>% count(word)
    wordcloud2(data = word_freq, size = 0.5, color = 'random-dark')
  })
  
  risk_categories <- c("Physical and Psychological Harm", "Discrimination", "Privacy", "Property Rights", 
                       "Freedom of Thought and Opinion", "Freedom of Expression", "Public Affairs",
                       "Work and Employment", "Children's Rights", "Physical and Psychological Harm")
  
  risks_categorized <- data.frame(Risk = risks, Category = risk_categories[1:length(risks)])
  
  output$bar_chart <- renderPlot({
    ggplot(risks_categorized, aes(x = Category)) +
      geom_bar(fill = "steelblue") +
      xlab("Human Rights Category") +
      ylab("Count") +
      ggtitle("Frequency of Risk Examples by Human Rights Category") +
      theme_minimal()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
