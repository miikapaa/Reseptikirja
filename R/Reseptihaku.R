
library(shiny)
library(readr)

# Define UI for application that draws a histogram
ReseptihakuUI <- function(id){ 
  ns <- NS(id)
  fluidPage(
    fluidRow(
      column(6,
        htmlOutput(outputId = ns("valitseResepti"))),
      column(6,
        checkboxInput(inputId = ns("keskeneraisetReseptit"), label = "Näytä myös keskeneräiset reseptit", value=FALSE))
    ),
    
    br(),
    textOutput(outputId = ns("naytaResepti"))
  )
}
# Define server logic required to draw a histogram
ReseptihakuServer <- function(input, output, session) {
  
  output$valitseResepti <- renderUI({
    
    #Haetaan valmiit ja keskeneräiset reseptit omiin dataframeihin ja muutetaan sarakkeen nimet, jotta saadaan ne nätisti dropdown valikkoon
    valmiitReseptit <- as.data.frame(list.files("valmiit reseptit"))
    colnames(valmiitReseptit)<- "Valmiit reseptit"
    
    valmiitReseptit2 <- valmiitReseptit
    colnames(valmiitReseptit2) <- "reseptit"
    valmiitReseptit2$paikka <- "valmiit reseptit"
    
    
    keskenReseptit <- as.data.frame(list.files("keskeneraiset reseptit"))
    colnames(keskenReseptit) <- "Keskeneräiset reseptit"
    keskenReseptit2 <- keskenReseptit
    colnames(keskenReseptit2)<- "reseptit"
    keskenReseptit2$paikka <- "keskeneraiset reseptit"
    
    kaikkiReseptit <- rbind(valmiitReseptit2,keskenReseptit2)
    
    #muodostetaan lista riippuen käyttäjän valinnasta
    if (input$keskeneraisetReseptit == TRUE) {

      lista <- c("", valmiitReseptit,keskenReseptit)
      
    }
    else{
      lista <- c("", valmiitReseptit)
    }
    
    #dropdown valikko, josta reseptin voi valita
    selectInput(inputId = session$ns("resepti"), label="Valitse resepti: ",
                choices = lista, selected = NULL)
  })
  
  
#Näytetään valitun reseptin sisältö
  output$naytaResepti <- renderText(
    
    
    
    
    readr::read_lines("valmiit reseptit/Ribsit")
    
  )

  
}