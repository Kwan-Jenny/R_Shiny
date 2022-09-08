# 3. Add an input control that lets the user decide how many rows to show in the summary tables.

## not clear where to start

# add input control in this ui
ui <- fluidPage(
  fluidRow(
    column(8, selectInput("code", "Product",
                          choices= setNames(products$prod_code, products$title), 
                          width= "100%")
           
           
    ),
    column(2, numericInput("obs", "Rows:", 10, min = 1, max = 100)), # adding rows controller in frontend
    column(2, selectInput("y", "Y axis", c("rate", "count")))
  ),
  fluidRow(
    column(4, tableOutput("diag")), 
    column(4, tableOutput("body_part")), 
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
  
)




server<- function(input, output, session) { # modification based on above code
  selected<- reactive(injuries %>% filter(prod_code==input$code))
  
  output$diag <- renderTable(count_top(selected(), diag), width="100%")
  output$body_part <- renderTable(count_top(selected(), body_part), width= "100%")
  output$location <- renderTable(count_top(selected(), location), width= "100%")
  
  
  summary<- reactive({ 
    selected() %>%
      count(age, sex, wt= weight) %>% 
      left_join(population, by= c("age", "sex")) %>% 
      mutate(rate = n /population*1e4)
  })
  
  output$age_sex<- renderPlot({ 
    summary() %>%
      ggplot(aes(age, n, colour= sex)) +
      geom_line() +
      labs(y ="Estimated number of injuries")
  }, res = 96)
}


shinyApp(ui,server)
