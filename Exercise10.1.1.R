#1. Complete the user interface below with a server function that updates input$date so that you can only select dates in input$year.



library(shiny)


ui <- fluidPage(
  numericInput("year", "year", value = 2020),
  dateInput("date", "date")
)

server<-function(input,output,session){
  
  observeEvent(input$year,{
    #req(input$year) <- necessary?
    
    # define date?
    
      
    
    # update date selection
    updateDateInput(session,"date",min= , max=) # from R help
    
  })
}

shinyApp(ui,server)