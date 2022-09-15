# 3. Complete the user interface below with a server function that updates input$country choices based on the input$continent. Use output$data to display all matching rows.


library(shiny)
library(gapminder)
library(tidyverse)



continents <- unique(gapminder$continent)

ui <- fluidPage(
  selectInput("continent", "Continent", choices = continents), 
  selectInput("country", "Country", choices = NULL),
  tableOutput("data")
)


server<-function(input,output,session){
  
  observeEvent(input$continent, {
    
    # to make sure your code waits until the first continent is selected
    req(input$continent)
    
    # pull out contry names
    
    pick<-gapminder%>%
      filter(continent==input$continent)%>%
      pull(country)%>%
      unique()
    
    # update country selection
    updateSelectInput(inputId = "country", choices=pick)
    
  })
  
  output$data<- renderTable({
    gapminder%>%
      filter(continent==input$continent,country==input$country)
  })
  
}


shinyApp(ui,server)
