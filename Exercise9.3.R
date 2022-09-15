#3. Create an app that lets the user upload a csv file, select one variable, draw a histogram, and then download the histogram. For an additional challenge, allow the user to select from .png, .pdf, and .svg output formats.


library(shiny)
library(tidyverse)


ui<-fluidPage(
  # upload a csv file
  fileInput("upload",NULL,buttonLabel = "Upload csv", accept=".csv"),#meaning of accept?-> only that file format?
  
  # select a variable
  selectInput("variable", "Select a variable",choices = NULL),#Do I have to define choices?
  
  
  # show histogram
  plotOutput("plot"),
  
  
  
  # download histogram
  downloadButton("download")
  
)


server<-function(input,output,session){
  # uploaded dataset
  data<-reactive({
    req(input$upload)
    read_csv(input$upload$datapath) # why take out "readr::" ?
  })
  
  # after user uploads data,~
  observeEvent(data(),{
    pick<-unique(colnames(data()))
    updateSelectInput(inputId = "variable",choices=pick)
  })
  
  # create reactive plot <- necessary?
  plot_output <- reactive({
    req(input$variable)#always needed for what?
    ggplot(data()) +
      geom_histogram(aes(.data[[input$variable]]))
  })
  
  # draw a histogram
  output$plot <-renderPlot({
    req(input$variable)
    plot_output()
  })
  
  
  # download the histogram
  output$download <-downloadHandler(
    filename = function(){
      paste("histogram")
    },
    content=function(file){
      ggsave(file,plot_output) # save ggplot histogram
    }
  )
  
  
}


shinyApp(ui,server)



# different version--> it seems working --> check!

ui<-fluidPage(
  # upload a csv file
  fileInput("upload",NULL,buttonLabel = "Upload csv", accept=".csv"),#meaning of accept?-> only that file format?
  
  # select a variable
  selectInput("variable", "Select a variable",choices = NULL),#Do I have to define choices?
  
  
  # show histogram
  plotOutput("plot"),
  
  
  
  # download histogram
  downloadButton("download")
  
)

server<-function(input,output,session){
  # uploaded dataset
  data<-reactive({
    req(input$upload)
    read_csv(input$upload$datapath) # why take out "readr::" ?
  })
  
  # after user uploads data,~
  observeEvent(data(),{
    pick<-unique(colnames(data()))
    updateSelectInput(inputId = "variable",choices=pick)
  })
  
   
  
  # draw a histogram
  output$plot <-renderPlot({
    req(input$variable)
    reactive({
      
      ggplot(data()) +
        geom_histogram(aes(.data[[input$variable]]))
    })
  })
  
  
  # download the histogram
  output$download <-downloadHandler(
    filename = function(){
      paste("histogram")
    },
    content=function(file){
      ggsave(file,plot_output) # save ggplot histogram
    }
  )
  
  
}


shinyApp(ui,server)


