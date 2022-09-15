# 2. Create an app that plots ggplot(diamonds, aes(carat)) but allows the user to choose which geom to use: geom_histogram(), geom_freqpoly(), or geom_density(). Use a hidden tabset to allow the user to select different arguments depending on the geom: geom_histogram() and geom_freqpoly() have a binwidth argument; geom_density() has a bw argument.



library(shiny)
library(tidyverse)


parameter_tabs<-tabsetPanel(
  id="params",
  type="hidden",
  
  # define 3 different tabPanel
  tabPanel("geom_histogram",
           numericInput()), # what do i need to plug in?
  
  tabPanel("geom_freqpoly",
           numericInput()),
  
  tabPanel("geom_density",
           numericInput())
  
)
