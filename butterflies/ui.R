#
#
#
# Part of trench project
# author Aji John https://github.com/ajijohn
# UI
# 
#

library(shiny)
library(ggplot2)

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
             sliderInput('sample_size', 'Sample Size', 
                         min=1, max=nrow(dataset), value=min(1000, nrow(dataset)), 
                         step=500, round=0),
             br()
      ),
      column(4, offset = 1,
             selectInput('x', 'X', c('Year')),
             selectInput('y', 'Y', c('FWL','Thorax')),
             selectInput('color', 'Color', c('doy162to202'))
      ),
      column(4,
             selectInput('facets', 'Facet_Column', names(dataset))
      )
    )
  )
)
