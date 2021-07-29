library(shiny)
library(leaflet)
library(rgdal)
library(plotly)


source("./components/route.R")

ui <- bootstrapPage(
  div(router$ui)
)

server <- function(input, output, session) {
  # Server routes
  router$server(input, output, session)
  print("./state_dataset/SP_Mun97_region")
  stateShape <- readOGR("./state_dataset/", "SP_Mun97_region")
  
  MDIP_df <- read.csv("./datasets/formated_MPID.csv", sep='\t')

  df = transform(MDIP_df, LATITUDE = as.numeric(LATITUDE))
  df = transform(df, LONGITUDE = as.numeric(LONGITUDE))
  df = transform(df, ANO_BO = as.numeric(ANO_BO))
  
  dfcopy <- data.frame(df[!is.na(df$CIDADE_ELABORACAO), ])
  initied = F
  
  f <- function(x) {
    data = x[7]
    genero = x[22]
    idade = x[23]
    cor = x[24]
    profissao = x[26]
    return(sprintf("<strong>Genero: %s</strong><br/>Idade: %s</sup><br/>Cor: %s</sup><br/>Profissão: %s</sup><br/>Data do Ocorrido: %s</sup>", as.character(genero), as.character(idade), as.character(cor), as.character(profissao), as.character(data)))
  }
  
  Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  
  
  output$predictive_timeseries <- renderPlotly({
    x <- c(1:100)
    random_y <- rnorm(100, mean = 0)
    data <- data.frame(x, random_y)
    
    fig <- plot_ly(data, x = ~x, y = ~random_y, type = 'scatter', mode = 'lines')
    
  })
  
  
  output$statemap <- renderLeaflet({
    
    filtered <- df[df['ANO_BO'] >= 2019 & df['ANO_BO'] <= 2021, ]
    
    aggregated_freq = aggregate(filtered[, 31], list(filtered$MUNICIPIO_CIRC), length)
    only_number = transform(filtered[grep("[[:digit:]]", filtered$IDADE_PESSOA), ], IDADE_PESSOA = as.numeric(IDADE_PESSOA))
    aggregated_freq_idade = aggregate(only_number[, 23], list(only_number$MUNICIPIO_CIRC), mean, )
    aggregated_freq_cor = aggregate(filtered[, 24], list(filtered$MUNICIPIO_CIRC),  Mode)
    labels <- c()
    density <- c()
    for (name in stateShape$SEM_ACENTO){
      
      dens = 0
      idade = 0
      cor = ""
      percentage = 0
      if (!is.na(aggregated_freq[aggregated_freq['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])){
        dens = as.numeric(aggregated_freq[aggregated_freq['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])
      }
      if (!is.na(aggregated_freq_idade[aggregated_freq_idade['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])){
        idade = as.numeric(aggregated_freq_idade[aggregated_freq_idade['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])
      }
      if (!is.na(aggregated_freq_cor[aggregated_freq_cor['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])){
        cor = as.character(aggregated_freq_cor[aggregated_freq_cor['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])
        aux = filtered['COR']
        percentage = length(aux[aux['COR'] == as.character(cor)])/nrow(filtered)
      }
      
      labels <- c(
        labels, htmltools::HTML(paste(
          sprintf(
            "<strong>%s</strong><br/>Vitimas: %g</sup><br/>Idade Média das Vitimas: %g</sup><br/>Raça/Cor com mais Vitimas: <strong>%s</strong> (%g",
            name,
            dens,
            round(idade, digits = 0), cor,  round(as.numeric(percentage)*100, digits = 2)
            ), "%)"))
      )
      density <- c(density, dens)
    }
    
    
    stateShape$labels = labels
    stateShape$density = density
    bins <- c(0, 2, 4, 8, 16, 32, 64, 128, Inf)
    pal <- colorBin("YlOrRd", domain = stateShape$density, bins = bins)
    
    leaflet(stateShape, height = "100%") %>% addTiles() %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.1)  %>% clearGroup("densidade") %>% clearMarkers() %>% addPolygons(
                    color = "#444444",
                    data = stateShape,
                    weight = 0.5, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.8,
                    fillColor = ~pal(density), popup =lapply(labels, htmltools::HTML), group = "densidade" )
  
      
  })
  

  
  
  
  deal_with_agrouped_clorophet <- function(filtered){
    aggregated_freq = aggregate(filtered[, 31], list(filtered$MUNICIPIO_CIRC), length)
    only_number = transform(filtered[grep("[[:digit:]]", filtered$IDADE_PESSOA), ], IDADE_PESSOA = as.numeric(IDADE_PESSOA))
    aggregated_freq_idade = aggregate(only_number[, 23], list(only_number$MUNICIPIO_CIRC), mean, )
    aggregated_freq_cor = aggregate(filtered[, 24], list(filtered$MUNICIPIO_CIRC),  Mode)
    labels <- c()
    density <- c()
    for (name in stateShape$SEM_ACENTO){
      
      dens = 0
      idade = 0
      cor = ""
      percentage = 0
      if (!is.na(aggregated_freq[aggregated_freq['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])){
        dens = as.numeric(aggregated_freq[aggregated_freq['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])
      }
      if (!is.na(aggregated_freq_idade[aggregated_freq_idade['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])){
        idade = as.numeric(aggregated_freq_idade[aggregated_freq_idade['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])
      }
      if (!is.na(aggregated_freq_cor[aggregated_freq_cor['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])){
        cor = as.character(aggregated_freq_cor[aggregated_freq_cor['Group.1'] == toupper(gsub("SAO ", "S.", name))][2])
        aux = filtered['COR']
        percentage = length(aux[aux['COR'] == as.character(cor)])/nrow(filtered)
      }
      
      labels <- c(
        labels, htmltools::HTML(paste(
          sprintf(
            "<strong>%s</strong><br/>Vitimas: %g</sup><br/>Idade Média das Vitimas: %g</sup><br/>Raça/Cor com mais Vitimas: <strong>%s</strong> (%g",
            name,
            dens,
            round(idade, digits = 0), cor,  round(as.numeric(percentage)*100, digits = 2)
          ), "%)"))
      )
      density <- c(density, dens)
    }
    
    
    stateShape$labels = labels
    stateShape$density = density
    bins <- c(0, 2, 4, 8, 16, 32, 64, 128, Inf)
    pal <- colorBin("YlOrRd", domain = stateShape$density, bins = bins)
    
    leafletProxy("statemap") %>% clearGroup("densidade") %>% clearMarkers() %>% addPolygons(
      color = "#444444",
      data = stateShape,
      weight = 0.5, smoothFactor = 0.5,
      opacity = 1.0, fillOpacity = 0.8,
      fillColor = ~pal(density), label =lapply(labels, htmltools::HTML), group = "densidade" )
  }
  
  deal_with_circle_marks <- function(filtered_data){
    
    labels <- apply(filtered_data, 1, f)
    filtered_data_with_label = filtered_data
    
    filtered_data_with_label$labels <- with(filtered_data, paste(
      "<p>Data do Ocorrido:", DATA_FATO, "</br>",
      "Genero: ", SEXO_PESSOA, "</br>",
      "Idade: ",IDADE_PESSOA, "</br>",
      "Cor: ",COR, "</br>",
      "Profissão: ",DESCR_PROFISSAO, "</br>",
      "</p>"))
    
    leafletProxy("statemap") %>%
      clearGroup("densidade") %>%
      clearMarkers() %>% addCircleMarkers(data=filtered_data_with_label, popup=~labels, lng=~LONGITUDE, lat=~LATITUDE, stroke=F, radius=5,  color = "#054880", fillOpacity = 0.9, group = "pointmarker")
  }
  
  
  observeEvent(input$filterbtn,{
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
