# UI for Tourist page
tourist_ui <- fluidPage(
  titlePanel("Customer Journey nel Turismo"),
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
      height: 5px;
      background-color: #007bff;
      z-index: 1;
    }
    .journey-buttons {
      display: flex;
      justify-content: space-around;
      width: 80%;
      z-index: 2;
    }
    .journey-button {
      width: 120px;
      height: 120px;
      background-size: cover;
      color: white;
      font-weight: bold;
      border: none;
      cursor: pointer;
      text-align: center;
      line-height: 120px;
    }
    .phase1 { background-image: url('https://via.placeholder.com/120?text=Dreaming'); }
    .phase2 { background-image: url('https://via.placeholder.com/120?text=Planning'); }
    .phase3 { background-image: url('https://via.placeholder.com/120?text=Pre-Travel'); }
    .phase4 { background-image: url('https://via.placeholder.com/120?text=On-Trip'); }
    .phase5 { background-image: url('https://via.placeholder.com/120?text=Post-Travel'); }
  ")),
  div(class = "journey-container",
      div(class = "journey-line"),
      div(class = "journey-buttons",
          actionButton("phase1", "Fase 1", class = "journey-button phase1"),
          actionButton("phase2", "Fase 2", class = "journey-button phase2"),
          actionButton("phase3", "Fase 3", class = "journey-button phase3"),
          actionButton("phase4", "Fase 4", class = "journey-button phase4"),
          actionButton("phase5", "Fase 5", class = "journey-button phase5")
      )
  )
)

