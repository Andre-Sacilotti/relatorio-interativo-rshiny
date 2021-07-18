library(shiny)

ui <- fluidPage(
  h2("Testee"),
  tags$div()
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)