
library(shiny)

source("R/Reseptihaku.R", local=T, chdir = T)
source("R/UusiResepti.R", local=T, chdir = T)

# Define UI for application that draws a histogram
ui <- fluidPage(
  tabsetPanel(
    tabPanel(title = "Reseptihaku", ReseptihakuUI("Reseptihaku")),
    tabPanel(title = "Uusi resepti", UusiReseptiUI("UusiResepti"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
   callModule(ReseptihakuServer, "Reseptihaku")
   callModule(UusiReseptiServer,"UusiResepti")
}

# Run the application 
shinyApp(ui = ui, server = server)

