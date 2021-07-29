library(shiny)


css_content <- "

.our-team {
  padding: 30px 0 40px;
  margin-bottom: 30px;
  background-color: #f7f5ec;
  text-align: center;
  overflow: hidden;
  position: relative;
}

.our-team .picture {
  display: inline-block;
  height: 130px;
  width: 130px;
  margin-bottom: 50px;
  z-index: 1;
  position: relative;
}

.our-team .picture::before {
  width: 100%;
  height: 0;
  border-radius: 50%;
  background-color: #1369ce;
  position: absolute;
  bottom: 135%;
  right: 0;
  left: 0;
  opacity: 0.9;
  transform: scale(3);
  transition: all 0.3s linear 0s;
}

.our-team:hover .picture::before {
  height: 100%;
}

.our-team .picture::after {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background-color: #1369ce;
  position: absolute;
  top: 0;
  left: 0;
  z-index: -1;
}

.our-team .picture img {
  width: 100%;
  height: auto;
  border-radius: 50%;
  transform: scale(1);
  transition: all 0.9s ease 0s;
}

.our-team:hover .picture img {
  box-shadow: 0 0 0 14px #f7f5ec;
  transform: scale(0.7);
}

.our-team .title {
  display: block;
  font-size: 15px;
  color: #4e5052;
  text-transform: capitalize;
}

.our-team .social {
  width: 100%;
  padding: 0;
  margin: 0;
  background-color: #1369ce;
  position: absolute;
  bottom: -100px;
  left: 0;
  transition: all 0.5s ease 0s;
}

.our-team:hover .social {
  bottom: 0;
}

.our-team .social li {
  display: inline-block;
}

.our-team .social li a {
  display: block;
  padding: 10px;
  font-size: 17px;
  color: white;
  transition: all 0.3s ease 0s;
  text-decoration: none;
}

.our-team .social li a:hover {
  color: #1369ce;
  background-color: #f7f5ec;
}

"

about_page <- div(
  
  tags$head(tags$style(HTML(css_content))),
  
  titlePanel(
    div(
      h1("Sobre", align = "center", style='color:white'),
        tags$br(),
        tags$br(),
        tags$h5(
          "Projeto desenvolvido como avaliação para a disciplina SME0803 - Visualização e Exploração de dados,
          ministrada no ICMC/USP pela incrivel Prof. Dr. Cibele Russo
          ",
          align = "center", style='color:white'),
        tags$h5(align = "center", style='color:white', 
        div(tags$a( href="https://uspdigital.usp.br/jupiterweb/obterDisciplina?nomdis=&sgldis=SME0803", 'Link da Disciplina SME0803')),
        ),
        tags$h5(align = "center", style='color:white', 
                div( tags$a( href="https://br.linkedin.com/in/cibelerusso", 'Linkedin Prof. Dr. Cibele')),
        ),
        tags$br(),
        )
    
  ),
  
  fluidRow(
    column(3, align="center", offset=2,
           div(class='',
            div(class='our-team',
                div(class='picture',
                    icon('user-circle', "fa-8x")
                    ),
                div(class="team-content",
                    h3(class='name', "André Sacilotti"),
                    h4(class='title', "Estatistica e Ciencia de Dados  - ICMC USP")
                    ),
                tags$ul(class='social',
                        tags$li(tags$a(href="", icon('linkedin'))),
                        tags$li(tags$a(href="", icon('github'))),
                        
                   )
              )     
          )
           ),
    column(3, align="center", offset=2,
           div(class='',
               div(class='our-team',
                   div(class='picture',
                       icon('user-circle', "fa-8x")
                   ),
                   div(class="team-content",
                       h3(class='name', "Willian Franco"),
                       h4(class='title', "Estatistica e Ciencia de Dados - ICMC USP")
                   ),
                   tags$ul(class='social',
                           tags$li(tags$a(href="", icon('linkedin'))),
                           tags$li(tags$a(href="", icon('github'))),
                           
                   )
               )     
           )
    ),
  ),
  

)
