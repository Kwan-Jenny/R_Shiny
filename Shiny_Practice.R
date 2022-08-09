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



