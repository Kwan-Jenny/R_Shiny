# 2. Complete the user interface below with a server function that updates input$county choices based on input$state. For an added challenge, also change the label from “County” to “Parish” for Louisiana and “Borough” for Alaska.


# interpretation of question:
# input$county choices based on input$state means that ui should be show 
# state selection first and then show county selection after that--> correct?


library(shiny)
library(openintro, warn.conflicts = FALSE)
library(tidyverse)


states <- unique(county$state)

ui <- fluidPage(
  selectInput("state", "State", choices = states),# states derive from above 
  selectInput("county", "County", choices = NULL)
)


server <- function(input, output, session) {
  observeEvent(input$state, {
    
    # to make sure your code waits until the first state is selected
    req(input$state)
    
    # pull out county names
    pick <- county %>% 
      filter(state == input$state) %>%
      pull(name) %>% 
      unique()   # for clarifying?
    
    # update county selection
    updateSelectInput(inputId = "county", choices = pick)
  })
}

shinyApp(ui, server)
