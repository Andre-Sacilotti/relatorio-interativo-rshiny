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
  df = transform(df, ANO_BO = as.numeric(ANO_BO))
  
  dfcopy <- data.frame(df[!is.na(df$CIDADE_ELABORACAO), ])
  
  
  output$statemap <- renderLeaflet({
    
    leaflet(stateShape, height = "100%") %>% addTiles() %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.1, group = "densidade")
      
  })
  
  
  deal_with_agrouped_clorophet <- function(filtered){
    aggregated_freq = aggregate(filtered[, 31], list(filtered$MUNICIPIO_CIRC), length)
    labels <- c()
    density <- c()
    for (name in stateShape$SEM_ACENTO){
      
      dens = 0
      if (!is.na(aggregated_freq[aggregated_freq['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])){
        if (name == "SAO PAULO"){
          print(gsub("SAO ", "S.", name))
        }
        
        dens = as.numeric(aggregated_freq[aggregated_freq['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])
      }
      labels <- c(labels, htmltools::HTML(sprintf( "<strong>%s</strong><br/>%g Vitimas</sup>", name, dens)))
      density <- c(density, dens)
    }
    
    
    stateShape$labels = labels
    stateShape$density = density
    bins <- c(0, 2, 4, 8, 16, 32, 64, 128, Inf)
    pal <- colorBin("YlOrRd", domain = stateShape$density, bins = bins)
    
    leafletProxy("statemap") %>% clearMarkers() %>% addPolygons(
      color = "#444444",
      data = stateShape,
      weight = 0.5, smoothFactor = 0.5,
      opacity = 1.0, fillOpacity = 0.8,
      fillColor = ~pal(density), label =lapply(labels, htmltools::HTML), group = "densidade" )
  }
  
  deal_with_circle_marks <- function(filtered_data){
    leafletProxy("statemap") %>%
      clearGroup("densidade") %>%
      addPolygons(data= stateShape, color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.1, group = "densidade") %>% clearMarkers() %>% addCircleMarkers(data=filtered_data, lng=~LONGITUDE, lat=~LATITUDE, stroke=F, radius=5,  color = "#054880", fillOpacity = 0.9, group = "pointmarker")
  }
  
  
  observeEvent(input$mapgroupment,{
    if (input$mapgroupment == "mun"){
      filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
      deal_with_agrouped_clorophet(filtered)

    }else{
      filtered_data = df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
      deal_with_circle_marks(filtered_data)
    }
  })
  
  
  observeEvent(input$mapyear, {
    if (input$mapgroupment == "mun"){
      filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
      deal_with_agrouped_clorophet(filtered)
    }else{
      
      filtered_data = df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
      deal_with_circle_marks(filtered_data)
    }
  })
  
  observeEvent(input$corgroupment,{
    ano_filtered = df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
    if (input$mapgroupment == "mun"){
      if (input$corgroupment == "all"){
        filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
        deal_with_agrouped_clorophet(filtered)
      }else if(input$corgroupment == "pp"){
        filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
        filtered <- filtered[filtered['COR'] == "Preta" | filtered['COR'] == "Parda", ]
        deal_with_agrouped_clorophet(filtered)
      }else if(input$corgroupment == "ba"){
        filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
        filtered <- filtered[filtered['COR'] == "Branca" | filtered['COR'] == "Amarela", ]
        deal_with_agrouped_clorophet(filtered)
      }else{
        filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
        filtered <- filtered[filtered['COR'] == "NÃO INFORMADO" | filtered['COR'] == "Ignorada" | filtered['COR'] == "Outros", ]
        deal_with_agrouped_clorophet(filtered)
      }
    }else{
      if (input$corgroupment == "all"){
        filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
        deal_with_circle_marks(filtered)
      }else if(input$corgroupment == "pp"){
        filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
        
        filtered <- filtered[filtered['COR'] == "Preta" | filtered['COR'] == "Parda", ]
        deal_with_circle_marks(filtered)
      }else if(input$corgroupment == "ba"){
        filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
        filtered <- filtered[filtered['COR'] == "Branca" | filtered['COR'] == "Amarela", ]
        deal_with_circle_marks(filtered)
      }else{
        filtered <- df[df['ANO_BO'] >= as.numeric(input$mapyear[1]) & df['ANO_BO'] <= as.numeric(input$mapyear[2]), ]
        filtered <- filtered[filtered['COR'] == "NÃO INFORMADO" | filtered['COR'] == "Ignorada" | filtered['COR'] == "Outros", ]
        deal_with_circle_marks(filtered)
        }
    }
    
    
  })


}

shinyApp(ui, server)
