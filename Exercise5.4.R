# 4. Provide a way to step through every narrative systematically with forward and backward buttons.

library(shiny)
library(forcats)
library(dplyr)
library(ggplot2)

# add forward button and backward button on frontend
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
  ),
  fluidRow(
    column(2, actionButton("bwd","Backward")),
    column(2, actionButton("fwd","Forward")),
    column(8,textOutput("narrative"))
  )
  
)


# Based on section 3.6 Observers, I used function "observeEvent" in server part


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
  
  
  # from solution, store the max possible number of stories
  max_stories<-reactive(length(selected()$narrative))
  
  # save the current position in the narrative list
  story <- reactiveVal(1)
  
  # reset the story counter if the user changes the product code <-???
  observeEvent(input$code,{
    story(1)
  })
  
  
  
  observeEvent(input$fwd,{
    story((story()%%max_stories())+1)  # what is %%? mod??
  })
  
  observeEvent(input$bwd,{
    story(((story()-2)%%max_stories())+1)
  })
  
  
  
  output$narrative<-renderText({
    selected()$narrative[story()]
  })
  
  
}


shinyApp(ui,server)
