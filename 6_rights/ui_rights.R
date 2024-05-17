
use_genai <- read_csv("6_rights/data/use_genai.csv")

satisfaction_genai <- read.csv("6_rights/data/satisfaction_genai.csv")

sentiment_twitter <- read_csv("6_rights/data/sentiment_twitter.csv")

benchmark_genai <- read.csv("6_rights/data/genai_benchmark_tidy.csv")

# UI for Rights page
rights_ui <- fluidPage(
  
  titlePanel("Leisure travelers' prior experience with Generative AI"),
  sidebarLayout(
    sidebarPanel(
      h4("Insights"),
      p("Leisure travelers have been experimenting with generative AI and are largely pleased with their experiences. In particular, ",
        strong("84% of respondents"), 
        " reported being ",
        em("satisfied or very satisfied"),
        " with the quality of generative AI’s recommendations."
      ),
      h4("Sources"),
      p(em("Oliver Wyman August 2023 Generative AI Travel & Leisure survey")),
      p(em("Sentiment Analysis on Twitter Dataset"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Use", plotOutput("use_genai_plot")),
        tabPanel("Satisfaction", plotOutput("satisfaction_genai_plot")),
        tabPanel("Sentiment", plotOutput("sentiment_twitter_plot"))
      )
    )
  ),

  
  titlePanel("TravelPlanning Benchmarking"),
  sidebarLayout(
    sidebarPanel(
      # Setting
      awesomeCheckboxGroup(
        inputId = "setting",
        label = "Settings Checkboxes", 
        choices = unique(benchmark_genai$setting),
        selected = benchmark_genai$setting[1],
        inline = TRUE, 
        status = "danger"
      ),
      
      # Method
      awesomeCheckboxGroup(
        inputId = "method",
        label = "Select Method(s):", 
        choices = unique(benchmark_genai$method),
        selected = benchmark_genai$method[1],
        inline = TRUE, 
        status = "danger"
      ),
      
      # LLM
      awesomeCheckboxGroup(
        inputId = "llm",
        label = "Select LLM(s):", 
        choices = unique(benchmark_genai$llm),
        selected = benchmark_genai$llm[1],
        inline = TRUE, 
        status = "danger"
      ),
      
      # Set
      awesomeCheckboxGroup(
        inputId = "set",
        label = "Select Set(s):", 
        choices = c("validation", "test"),
        selected = "test",
        inline = TRUE, 
        status = "danger"
      ),
      
      # Metric
      awesomeCheckboxGroup(
        inputId = "metric",
        label = "Select Metric(s):", 
        choices = unique(benchmark_genai$metric),
        selected = benchmark_genai$metric[1],
        inline = TRUE, 
        status = "danger"
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Table", dataTableOutput("benchmark_genai_table")),
        tabPanel("Plot", renderPlot("benchmark_genai_plot"))
      )
      
    )
  )
)


### deprecated

# titlePanel("TravelPlanning Benchmarking"),
# sidebarLayout(
#   sidebarPanel(
#     # setting,method,llm,set,metric,value
#     selectizeInput("setting", "Select Setting:", selected="tool+planning", choices = unique(benchmark_genai$setting), multiple=TRUE),
#     selectizeInput("method", "Select Method:", selected="ReAct", choices = unique(benchmark_genai$method), multiple=TRUE),
#     selectizeInput("llm", "Select LLM:", selected="GPT-3.5-Turbo", choices = unique(benchmark_genai$llm), multiple=TRUE),
#     selectizeInput("set", "Select Set:", selected="test", choices = c("validation","test"), multiple=TRUE),
#     selectizeInput("metric", "Select Metric:", selected="final_pass_rate", choices = unique(benchmark_genai$metric), multiple=TRUE),
#   ),
#   mainPanel(
#     dataTableOutput("benchmark_genai_table")
#   )
# ),




