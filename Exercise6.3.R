#3. Create an app with that contains two plots, each of which takes up half of the width. Put the controls in a full width container below the plots.

# can use problem 1 and 2 both ways?

ui <- fluidPage(
  fluidRow(
    column(6,
           plotOutput("hist")),
    column(6,
           plotOutput("plot"))
  ),
  fluidRow(
    column(12,
           numericInput("m", "Number of samples:", 2, min = 1, max = 100) # Rearrange it at center??
           )
  )

)


server<-function(input,output,session){
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
  output$plot <- renderPlot({
    means <- replicate(1e2, mean(runif(input$m)))
    plot(means)
  }, res = 96)
}



shinyApp(ui,server)







