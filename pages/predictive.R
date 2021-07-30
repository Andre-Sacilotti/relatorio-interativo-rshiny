library(shiny)
library(plotly)
library(DT)


predictive_page <- div(
  fluidRow(titlePanel("Tabela de Dados"), align = "center"),
  fluidRow(column(
    10,
    offset = 1, DT::dataTableOutput("data_table")
  ))
)
