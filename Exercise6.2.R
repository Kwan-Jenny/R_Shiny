# 2. Modify the Central Limit Theorem app to put the sidebar on the right instead of the left.


# just switch the "mainPanel" function and "sidebarPanel" function.
ui <- fluidPage(
  titlePanel("Central limit theorem"),
  sidebarLayout(
    mainPanel(fluidRow(column(4,plotOutput("hist")),
                       column(4,plotOutput("hist2")),column(4,plotOutput("hist3")))
      
    ),
    sidebarPanel(
      numericInput("m", "Number of samples:", 2, min = 1, max = 100)
    )
  )
)


server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
  output$hist2 <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
  output$hist3 <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui,server)



## using "position"


ui <- fluidPage(
  titlePanel("Central limit theorem"),
  sidebarLayout(
    sidebarPanel(
      numericInput("m", "Number of samples:", 2, min = 1, max = 100)
    ),
    mainPanel(
      plotOutput("hist")
    ),
    position="right" # if switch left to right and right to left then ????
  )
)


server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui,server)
