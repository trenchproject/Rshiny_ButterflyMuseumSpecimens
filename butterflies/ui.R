#
#
#
# Part of trench project
# author Aji John https://github.com/ajijohn
# UI
# 
#

library(shiny)
library(tidyverse)

dataset <-read.csv(paste(getwd(),"/absM-all.csv",sep = ""))

# Define UI 
shinyUI(
  fluidPage(
    
    title = "Temperatures",
    
    plotOutput('trendPlot'),
    
    hr(),
    
    fluidRow(
      column(3,
             h4("Filter"),
             sliderInput('year', 'Year', 
                         min=min(dataset$Year), max=max(dataset$Year), value=min(min(dataset$Year), max(dataset$Year)),format = "####",sep = "",step = 1),
             br()
      ),
      column(4, offset = 1,
             selectInput('x', 'X', c('Year'='Year','doy'='doy','Pupal Temperature'='Tpupal','Forewing Length'='FWL')),
             selectInput('y', 'Y', c('FWL','Thorax')),
             selectInput('color', 'Color', c('doy162to202'))
      ),
      column(4,
             selectInput('facets', 'Facet_Column', c('region.lab'))
      )
    )
  )
)
