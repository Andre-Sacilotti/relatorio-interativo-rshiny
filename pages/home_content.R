library(shiny)
library(bslib)
library(rgdal)
library(leaflet)


new_media_content <- "

body{
background-color: #454c57;
}

@media (max-width: 955px) {
    .navbar-header .navbar-brand {float: left; text-align: center; width: 100%}
    .navbar-header { width:100% }
.navbar-brand { width: 100%; text-align: center }
    
}

#statemap {
border-radius: 25px;
}

.leaflet-overlay-pane{
border-radius: 25px;

}

.container-fluid {
    padding-right: 0px; 
    padding-left: 0px; 
    margin-right: auto;
    margin-left: auto;
}

.nav
{

    padding-left: 15px; 

}

.navbar-inverse .navbar-brand{
  color: white
}

.navbar-brand:hover {
    color: white;
}


@media (min-width: 956px) {
    .navbar {width:100%}
    .navbar .navbar-nav {float: right}
    .navbar .navbar-header {float: left}
    .navbar-brand { float: left; padding-left: 30px;  }
}

.content-home{
width: 100%
flex-direction: row;
display: flex;
background-color: #454c57;
}

.map-div{
  width: 55%;
  margin-left: 30px;
  height: calc(100vh - 69px- 20px);
  margin-bottom: 20px;
   border-radius: 25px;
}

.side-content{
margin-left: 15px;
margin-right: 15px;
width: 45%;
 height: calc(100vh - 69px - 20px);

}


.map-filters{
border-radius: 25px;
background-color: #ededed;
height: 70%
}

.filter-title{
width: 100%;
text-align: center;
padding-top: 7px;
}

@media (max-width: 768px) {
.map-div{
height: calc(100vh - 266px - 20px);
}
.side-content{
height: calc(100vh - 266px - 20px);
}

.content-home{
flex-direction: column;
display: flex;
}
}

@media (min-width: 769px) and (max-width: 956px) {
.map-div{
height: calc(100vh - 121px - 20px);
}
.side-content{
height: calc(100vh - 121px - 20px);
}
}

.leaflet{
border-radius: 25px;
}

.filter-component{
width: 100%;
padding-left: 15px;
padding-right: 15px;
}

hr.solid {
  border-top: 3px solid #bbb;
}





"


home_content <- div(
  # Head with styles
  tags$head(
    tags$style(HTML(new_media_content))
  ),
  div(
    class="content-home",
    div(
      class='map-div',
        
        leafletOutput("statemap", height = "100%")
      
    ),
    div(
      class='side-content',
      div(
        class='map-filters',
        div(class="filter-title", h4('Filtros do Mapa'), hr(class='solid')),
        div(class='filter-component', sliderInput("mapyear", "Ano", min = 2013, max = 2021, value=c(2019, 2021), sep="", dragRange = T, ticks=F, width = "100%"))
        
      )
    )
  )
  
  

)


