library(shiny)
library(leaflet)
library(rgdal)

source("./components/route.R")

ui <- bootstrapPage(
  div(router$ui)
)

server <- function(input, output, session) {
  # Server routes
  router$server(input, output, session)
  print("./state_dataset/SP_Mun97_region")
  stateShape <- readOGR("./state_dataset/", "SP_Mun97_region")
  
  MDIP_df <- read.csv("./datasets/formated_MPID.csv")

  df = transform(MDIP_df, LATITUDE = as.numeric(LATITUDE))
  df = transform(df, LONGITUDE = as.numeric(LONGITUDE))
  
  output$statemap <- renderLeaflet({
    leaflet(stateShape, height = "100%") %>% addTiles() %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.1, label = ~SEM_ACENTO)  %>%
      addCircleMarkers(data=df, lng=~LONGITUDE, lat=~LATITUDE, stroke=F, radius=5, , color = "#054880", fillOpacity = 0.9)
  })


}

shinyApp(ui, server)
