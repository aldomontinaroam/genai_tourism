tourist_ui <- fluidPage(
  
  titlePanel("Traveler Customer Journey"),
  
  tags$style(HTML("
    .journey-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      position: relative;
      margin-bottom: 40px;
    }
    
    .journey-line {
      position: absolute;
      top: 60px;
      width: 80%;
      height: 10px;
      background-color: #00a6a6;
      z-index: 1;
      border-radius: 10px;
    }
    
    .journey-buttons {
      display: flex;
      justify-content: space-around;
      width: 80%;
      z-index: 2;
    }
    
    #mainplot {
              margin: 20px;
              padding: 20px;
              border: 1px solid #00a6a6;
            }
    
    .journey-button {
      width: 150px;
      height: 150px;
      background-size: cover;
      color: white;
      font-weight: bold;
      border: none;
      cursor: pointer;
      text-align: center;
      line-height: 120px;
      margin: 0 10px;
    }
    
    .phase1 { background-image: url('dreaming.png'); }
    .phase2 { background-image: url('planning.png'); }
    .phase3 { background-image: url('pre-trip.png'); }
    .phase4 { background-image: url('on-trip.png'); }
    .phase5 { background-image: url('post-trip.png'); }
  ")),
  
  div(class = "journey-container",
      div(class = "journey-line"),
      div(class = "journey-buttons",
          actionButton("phase1", "", class = "journey-button phase1"),
          HTML("<p>Dreaming</p>"),  # Text for phase 1
          actionButton("phase2", "", class = "journey-button phase2"),
          HTML("<p>Planning</p>"),  # Text for phase 2
          actionButton("phase3", "", class = "journey-button phase3"),
          HTML("<p>Pre-Trip</p>"),  # Text for phase 3
          actionButton("phase4", "", class = "journey-button phase4"),
          HTML("<p>On-Trip</p>"),    # Text for phase 4
          actionButton("phase5", "", class = "journey-button phase5"),
          HTML("<p>Post-Trip</p>")  # Text for phase 5
      )
  ),
  div(id = "mainplot",
    plotlyOutput("main_plot")
  )
  
)
