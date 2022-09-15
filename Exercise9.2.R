# 2. Create an app that lets you upload a csv file, select a variable, and then perform a t.test() on that variable. After the user has uploaded the csv file, you’ll need to use updateSelectInput() to fill in the available variables. See Section 10.1 for details.

# it seems we can do "ui" but not "server", then let's look at section 10.1 first and come back to this later



library(shiny)

ui<-fluidPage(
  # upload a csv file
  fileInput("upload",NULL,buttonLabel = "Upload csv", accept=".csv"),#meaning of accept?-> only that file format?
  
  # select a variable
  selectInput("variable", "Select a variable",choices = NULL),#Do I have to define choices?
  
  
  # perform a t.test()--> how to put this part?
  verbatimTextOutput("t_test") # refer from chapter1
  
)

server<-function(input,output,session){
  # uploaded dataset
  data<-reactive({
    req(input$upload)
    #readr::read_csv(input$upload$datapath) <-- what is this line works for ?
  })
  
  # after user uploads data,~
  observeEvent(data(),{
    pick<-unique(colnames(data()))
    updateSelectInput(inputId = "variable",choices=pick)
  })
  
  
  
  # perform a t.test()--> use "renderPrint"? or "renderText"?
  output$t_test<-renderPrint({
    t.test(data()[[input$variable]],mu=0)# need to set-up mu=0
  })
}


shinyApp(ui,server)
