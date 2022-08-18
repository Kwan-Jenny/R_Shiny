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



##############################################################################
## Chapter 3: Basic Reactivity



# Reactive Programming

ui<-fluidPage(
  textInput("name","What's your name?"),
  textOutput("greeting")
)

server<-function(input,output,session){
  output$greeting<-renderText({paste0("Hello ",input$name, "!")
  })
}


shinyApp(ui,server)




# Reactive expressions

ui<-fluidPage(
  textInput("name","What's your name?"),
  textOutput("greeting")
)

server<- function(input,output,session){
  string<-reactive(paste0("Hello ",input$name, "!"))
  output$greeting<- renderText(string())
  
  
}

shinyApp(ui,server)


# Execution order


ui<-fluidPage(
  textInput("name","What's your name?"),
  textOutput("greeting")
)

server<- function(input,output,session){
  output$greeting<- renderText(string())
  string<-reactive(paste0("Hello ",input$name, "!"))
  
  
}

shinyApp(ui,server)


## Exercise





# The App

library(ggplot2)


freqpoly<-function(x1,x2,binwidth=0.1,xlim=c(-3,3)){
  df<-data.frame(
    x=c(x1,x2),
    g=c(rep("x1",length(x1)), rep("x2",length(x2)))
  )
  
  ggplot(df,aes(x,colour=g))+
    geom_freqpoly(binwidth=binwidth,size=1)+
    coord_cartesian(xlim=xlim)
}

t_test<- function(xl, x2) {
  test<- t.test(xl, x2)
  
  # use sprintf() to format t.test() results compactly
  sprintf(
    
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2])
  
  
}


x1 <- rnorm(100, mean=0, sd = 0.5) 
x2 <- rnorm(200, mean=0.15, sd = 0.9)


freqpoly(x1, x2) 
cat(t_test(x1, x2)) 



ui<-fluidPage(
  fluidRow(
    column(4,
           "Distribution 1",
           numericInput("n1", label = "n", value = 1000, min = 1),
           numericInput("mean1", label = "u", value = 0, step = 0.1),
           numericInput("sd1", label = "o", value = 0.5, min = 0.1, step = 0.1),
    ),
    column(4,
           "Distribution 2",
           numericInput("n2", label = "n", value = 1000, min = 1),
           numericInput("mean2", label = "u", value = 0, step = 0.1),
           numericInput("sd2", label = "o", value = 0.5, min = 0.1, step = 0.1),
    ),
    column(4,
           "Frequency polygon",
           numericInput("binwidth", label = "Bin width", value = 0.1, step = 0.1),
           sliderInput("range", label = "range", value = c(-3,3), min = -5, max = 5)
    )
  ),
  fluidRow(
    column(9, plotOutput("hist")),
    column(3, verbatimTextOutput("ttest"))
  )
  
)



server<-function(input,output,session){
  output$hist<-renderPlot({
    x1<-rnorm(input$n1,input$mean1,input$sd1)
    x2<-rnorm(input$n2,input$mean2,input$sd2)
    
    freqpoly(x1,x2, binwidth=input$binwidth, xlim=input$range)
  }, res=96)
  
  output$ttest<-renderText({
    x1<-rnorm(input$n1,input$mean1,input$sd1)
    x2<-rnorm(input$n2,input$mean2,input$sd2)
    
    t_test(x1,x2)
  })
}


shinyApp(ui,server)


# Simplifying the graph

ui<-fluidPage(
  fluidRow(
    column(4,
           "Distribution 1",
           numericInput("n1", label = "n", value = 1000, min = 1),
           numericInput("mean1", label = "u", value = 0, step = 0.1),
           numericInput("sd1", label = "o", value = 0.5, min = 0.1, step = 0.1),
    ),
    column(4,
           "Distribution 2",
           numericInput("n2", label = "n", value = 1000, min = 1),
           numericInput("mean2", label = "u", value = 0, step = 0.1),
           numericInput("sd2", label = "o", value = 0.5, min = 0.1, step = 0.1),
    ),
    column(4,
           "Frequency polygon",
           numericInput("binwidth", label = "Bin width", value = 0.1, step = 0.1),
           sliderInput("range", label = "range", value = c(-3,3), min = -5, max = 5)
    )
  ),
  fluidRow(
    column(9, plotOutput("hist")),
    column(3, verbatimTextOutput("ttest"))
  )
  
)



server<-function(input,output,session){
  x1<-reactive(rnorm(input$n1,input$mean1,input$sd1))
  x2<-reactive(rnorm(input$n2,input$mean2,input$sd2))
  
  output$hist<-renderPlot({
    freqpoly(x1(),x2(), binwidth=input$binwidth, xlim=input$range)
  }, res=96)
  
  output$ttest<-renderText({
    t_test(x1(),x2())
  })
}


shinyApp(ui,server)



# Controlling timing of evaluation


ui <- fluidPage( 
  fluidRow(
    
    column(3,
           numericInput("lambda1", label= "lambda1", value= 3), 
           numericInput("lambda2", label= "lambda2", value= 5), 
           numericInput("n", label= "n", value= 1e4, min= 0)
    ),
    column(9, plotOutput("hist"))
  )
)

server<- function(input, output, session) {
  x1 <- reactive(rpois(input$n, input$lambda1)) 
  x2 <- reactive(rpois(input$n, input$lambda2)) 
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}


shinyApp(ui,server)




# Timed invalidation


ui <- fluidPage( 
  fluidRow(
    
    column(3,
           numericInput("lambda1", label= "lambda1", value= 3), 
           numericInput("lambda2", label= "lambda2", value= 5), 
           numericInput("n", label= "n", value= 1e4, min= 0)
    ),
    column(9, plotOutput("hist"))
  )
)

server<- function(input, output, session) {
  timer<-reactiveTimer(500)
  
  x1 <- reactive({
    timer()
    rpois(input$n, input$lambda1)
  }) 
  x2 <- reactive({
    timer()
    rpois(input$n, input$lambda2)
  }) 
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}


shinyApp(ui,server)


# On click

ui <- fluidPage( 
  fluidRow(
    column(3,
           numericInput("lambda1", label= "lambda1", value= 3), 
           numericInput("lambda2", label= "lambda2", value= 5), 
           numericInput ("n", label = "n", value = 1e4, min = 0), 
           actionButton ("simulate", "Simulate!")
    ),
    column(9, plotOutput("hist"))
  )
)

server<- function(input, output, session) { 
  x1 <- reactive({
    input$simulate 
    rpois(input$n, input$lambda1)
  } )
  x2 <- reactive({ 
    input$simulate 
    rpois(input$n, input$lambda2)
    
  })
  output$hist <- renderPlot({ 
    freqpoly(x1(), x2(), binwidth=1, xlim=c(0,40))
  }, res = 96)
}




shinyApp(ui,server)


# Fancy version of upper code


ui <- fluidPage( 
  fluidRow(
    column(3,
           numericInput("lambda1", label= "lambda1", value= 3), 
           numericInput("lambda2", label= "lambda2", value= 5), 
           numericInput ("n", label = "n", value = 1e4, min = 0), 
           actionButton ("simulate", "Simulate!")
    ),
    column(9, plotOutput("hist"))
  )
)

server<- function(input, output, session) { 
  x1 <- eventReactive(input$simulate, { 
    rpois(input$n, input$lambda1)
  } )
  x2 <- eventReactive(input$simulate, { 
    rpois(input$n, input$lambda2)
    
  })
  output$hist <- renderPlot({ 
    freqpoly(x1(), x2(), binwidth=1, xlim=c(0,40))
  }, res = 96)
}




shinyApp(ui,server)




# Observers

ui <- fluidPage(
  textInput("name", "What's your name?"), 
  textOutput("greeting")
)

server<- function(input, output, session) {
  string <- reactive(paste0("Hello ", input$name, "! ") )
  
  output$greeting <- renderText(string()) 
  observeEvent(input$name, {
    message("Greeting performed")
  } )
  
}

shinyApp(ui,server)




##############################################################################
## Chapter 4. Case Study: ER Injuries

# Introduction


library(shiny)
library(vroom)
library(tidyverse)


dir.create("neiss")


## This is good function code for saving file from internet url

download<- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
  download.file(paste0(url, name), paste0("neiss/", name), quiet= TRUE)
}

download("injuries.tsv.gz") 
download("population.tsv") 
download("products.tsv")


# need to know what this code use for
injuries<-vroom::vroom("neiss/injuries.tsv.gz") # what are :: and neiss/~    ?   

injuries


products<-vroom::vroom("neiss/products.tsv")
products


population<- vroom::vroom("neiss/population.tsv")
population


selected<-injuries%>%filter(prod_code==649)

nrow(selected)



selected%>%count(location, wt=weight,sort=TRUE)


selected%>%count(body_part, wt=weight,sort=TRUE)


selected%>%count(diag, wt=weight,sort=TRUE)


summary<-selected%>%count(age,sex,wt=weight)

summary


summary%>%ggplot(aes(age,n,color=sex))+
  geom_line()+
  labs(y="Estimated number of injuries")


# typical way of handling data using tidyverse
summary<-selected%>%
  count(age,sex,wt=weight)%>%
  left_join(population,by=c("age","sex"))%>%
  mutate(rate=n/population*1e4)


summary


summary%>%
  ggplot(aes(age,rate,color=sex))+
  geom_line(na.rm=TRUE)+
  labs(y="Injuries per 10,000 people")


selected%>%
  sample_n(10)%>%
  pull(narrative)



# Prototype


prod_codes <- setNames(products$prod_code, products$title)

ui <- fluidPage(
  fluidRow( 
    column(6,
           selectInput("code", "Product", choices=prod_codes)
    )           
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



server<- function(input, output, session) { 
  selected<- reactive(injuries %>% filter(prod_code==input$code))
  
  output$diag <- renderTable(
    selected() %>% count(diag, wt= weight, sort=TRUE)
  )
  output$body_part	<- renderTable(	
    selected() %>%	count(body_part, wt=weight, sort=TRUE)
  )
  output$location <- renderTable(
    selected() %>% count(location, wt=weight, sort=TRUE)
  )
  
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


# Polish Tables


injuries%>%
  mutate(diag = fct_lump(fct_infreq(diag), n =  5)) %>% 
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))


count_top <- function(df, var, n = 5){
  df %>%
    mutate({{ var}} := fct_lump(fct_infreq({{ var}}), n=n))%>%
    group_by({{var}}) %>%
    summarise(n = as.integer(sum(weight)))
}


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




# Rate Versus Count



ui <- fluidPage(
  fluidRow(column(8,
                  selectInput("code", "Product",
                              choices= setNames(products$prod_code, products$title), 
                              width= "100%"
                  )
                  
  ),
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




server<- function(input, output, session) { 
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
  
  output$age_sex <- renderPlot({ 
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour= sex)) + 
        geom_line() +
        labs(y = "Estimated number of injuries") 
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour= sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people")
    }
  }, res= 96)
  
}


shinyApp(ui,server)


###############################################################################
## Exercises

# 1. Draw the reactive graph for each app


# 2. What happens if you flip fct_infreq() and fct_lump() in the code zthat reduces the summary talbes?

## If we dont know what are they, then we code them and execute them

injuries%>%mutate(diag = fct_lump(fct_infreq(diag), n = 5))%>%
  pull(diag)

injuries%>%mutate(diag = fct_infreq(fct_lump(diag, n = 5)))%>%
  pull(diag)

# 3. Add an input control that lets the user decide how many rows to show in the summary tables.

## not clear where to start

# add input control in this ui
ui <- fluidPage(
  fluidRow(
    column(8, selectInput("code", "Product",
                              choices= setNames(products$prod_code, products$title), 
                              width= "100%")
                 
                  
   ),
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

# I think I need to insert something after first selectInput

# It seems that I need to insert "actionButton" right after plotOutput


injuries%>%
  mutate(diag = fct_lump(fct_infreq(diag), n =  5)) %>% 
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))


count_top <- function(df, var, n = 5){
  df %>%
    mutate({{ var}} := fct_lump(fct_infreq({{ var}}), n=n))%>%
    group_by({{var}}) %>%
    summarise(n = as.integer(sum(weight)))
}


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







# 4. Provide a way to step through every narrative systematically with forward and backward buttons.







