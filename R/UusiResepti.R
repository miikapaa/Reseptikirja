library(crayon)

# Define UI for application that draws a histogram
UusiReseptiUI <- function(id){ 
  rows <- "10"
  cols <- "100"
  ns <- NS(id)
  fluidPage(
    fluidRow(
      titlePanel("Lis�� uusi resepti")
      ),
    h3("Listaa tarvittavat ainekset"),
    tags$form(method="post", 
              tags$textarea(id=ns("ainekset"), rows=rows, cols=cols)
              ),
    h3("Listaa ty�vaiheet"),
    tags$form(method="post", 
              tags$textarea(id=ns("ohje"), rows=rows, cols=cols)
    ),
    h3("Lis�kommentit"),
    tags$form(method="post", 
              tags$textarea(id=ns("lisakommentit"), rows=rows, cols=cols)
    ),
    
    actionButton(inputId = ns("tallennus"), label = "Tallenna resepti"),
    
    textOutput(ns("resepti"))
    
    
    
    # tags$head(
    #   useShinyjs(),
    #   tags$script(src='https://cdn.tinymce.com/4/tinymce.min.js')
    # ),
    # 
    # fluidRow(
    #   titlePanel("tinyMCE Shiny"),
    #   br(),
    #   column(width=6,
    #          tags$form(method="post",
    #                    tags$textarea(id="textHolder")
    #          ),
    # 
  )
}
# Define server logic required to draw a histogram
UusiReseptiServer <- function(input, output, session) {
  output$resepti <- renderText({paste("#Ainekset",
                                      input$ainekset,
                                      "\n#Ohje",
                                      input$ohje,
                                      "\n#Lisakommentit",
                                      input$lisakommentit, sep = "\n")})
  
  # Reaktiivinen muuttuja, johon tallentuu koko resepti hyv��n struktuuriin
  resepti <- reactive({paste("#Ainekset \n",
                             input$ainekset,
                             "\n\n#Ohje \n",
                             input$ohje,
                             "\n\n#Lisakommentit \n",
                             input$lisakommentit, sep = "")})
  
  # Funktio, joka muodostaa tallennusdialogin, jos tallennus onnistui, annetaan ilmoitus k�ytt�j�lle
  tallennusModal <- function(onnistui = FALSE){
    
    modalDialog(
      title = "Painoit nappia!", textInput(inputId = session$ns("filepath"), 
                                           label = "Anna reseptin nimi"),
      
      footer = tagList(
        modalButton("Peruuta"),
        actionButton(inputId = session$ns("tallennaKesk"),
                     label = "Tallenna keskener�isen�"),
        actionButton(inputId = session$ns("tallenna"),
                     label = "Tallenna")
      )#,
      # if (onnistui)
      # {div(tags$b("Tallennus onnistui!", style = "color: green;"))
      #   message("in here!")
      #   Sys.sleep(1)
      #   removeModal()
      # }
    )
    
    
    
    
    
    
    
  }
  
  # Funktio, joka hoitaa tallentamisen
  filesave <- function(name, kesken = FALSE, sisalto){
    #TODO: lis�� check, ettei file� ole olemassa!
    fileConn <- file(paste("valmiit reseptit/", name, ".txt", sep = ""))
    if(kesken){
      fileConn <- file(paste("keskeneraiset reseptit/", name, ".txt", sep = ""))
    }
    writeLines(sisalto, fileConn)
    close(fileConn)
  }
  
  # Kun k�ytt�j� painaa reseptin tallennusnappia
  observeEvent(input$tallennus, {
    showModal(
      tallennusModal()
      )
    })
  # Kun k�ytt�j� valitsee tallentaa lopullisen version
  observeEvent(input$tallenna, {
    filesave(name = input$filepath, sisalto = resepti())
    removeModal()
    # showModal(tallennusModal(onnistui = TRUE))
  })
  # Kun k�ytt�j� valitsee tallentaa keskener�isen version
  observeEvent(input$tallennaKesk, {
    filesave(name = input$filepath , kesken = TRUE, sisalto = resepti())
    removeModal()
    # showModal(tallennusModal(onnistui = TRUE))
  })
  
  
  
}