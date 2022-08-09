## Mastering Shiny Practice

library("shiny")


ui<-fluidPage(
  "Hello, world!"
)
server<-function(input,output,session){
  
}

shinyApp(ui,server)


#########################################

ui<-fluidPage(selectInput("dataset",label="Dataset",
                          choices = ls("package:datasets")),
              verbatimTextOutput("summary"),
              tableOutput("table")
)


server <- function(input, output, session){
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$table<-renderTable({
    dataset<-get(input$dataset,"package:datasets")
    dataset
  })
}


##############################################################################
## Chapter 2

# Free text

sliderInput("main", "Limit (minimum)", value=50, min=0, max=100)



ui<-fluidPage(
  textInput("name", "What's your name"),
  passwordInput("password","What's your password?"),
  textAreaInput("story","Tell me about yourself",rows=3)
)




shinyApp(ui,server)


# Numeric Inputs

ui<-fluidPage(
  numericInput("num","Number one", value=0, min=0, max=100),
  sliderInput("num2","Number two", value=50, min=0, max=100),
  sliderInput("rng","Range", value=c(10,20), min=0, max=100)
)

shinyApp(ui,server)


# Dates

ui<-fluidPage(
  dateInput("dob","When were you born?"),
  dateRangeInput("holiday","When do you want to go on vacation next?")
)

shinyApp(ui,server)





# Limited Choices

animals<-c("dog","cat","mouse","bird","other","I hate animals")

ui<-fluidPage(
  selectInput("state","What's your favorite state?", state.name),
  radioButtons("animal","What's your favorite animal?",animals)
)


shinyApp(ui,server)




# File Uploads

ui<-fluidPage(
  fileInput("upload",NULL)
)


shinyApp(ui,server)



# Action Buttons

ui<-fluidPage(
  actionButton("click","Click me!"),
  actionButton("drink","Drink me!",icon=icon("cocktail"))
)


shinyApp(ui,server)



# Tables

ui<-fluidPage(
  tableOutput("static"),
  dataTableOutput("dynamic")
)

server<-function(input,output,session){
  output$static<-renderTable(head(mtcars))
  output$dynamic<-renderDataTable(mtcars, options=list(pageLength=5))
}

shinyApp(ui,server)




# Plots

ui<-fluidPage(
  plotOutput("plot",width="400px")
)


server<-function(input,output,session){
  output$plot<-renderPlot(plot(1:5),res=96)
}  


shinyApp(ui,server)  





