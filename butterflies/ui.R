#
# Part of trench project
# author Aji John https://github.com/ajijohn
# UI
#
# todo
# axis labels
# setae length
# 
#

library(shiny)
library(tidyverse)
library(leaflet)
library(leaflet.extras)

dataset <-read.csv(paste(getwd(),"/absM-all.csv",sep = ""))

# Define UI 
shinyUI(
  fluidPage(
    
    title = "Temperatures - Butterflies",
    fluidRow(
    column(12,
           includeMarkdown("include.md")
    )),
    fluidRow(
             column(6,
                    leafletOutput("mymap")
             )    ,
             column(6,
                    imageOutput("distPlot")
             )  
             ),
    hr(),
    fluidRow(
      column(12,
             includeMarkdown("include2.md")
      )),
    plotOutput('trendPlot'),
    
    hr(),
    
    fluidRow(
      column(3,
             h4("Filter"),
             sliderInput('year', 'Year', 
                         min=min(dataset$Year),
                         max=max(dataset$Year), 
                         value=c(min(dataset$Year), 
                                   max(dataset$Year)),
                         format = "####",sep = "",step = 1),
             br()
      ),
      column(4, offset = 1,
             selectInput('x', 'X', c('Year'='Year','doy'='doy','Developmental Temperature'='doy162to202','Pupal Temperature'='Tpupal','Forewing Length (mm)'='FWL','Wing Melanism (gray level)'='Corr.Val','Setae length (mm)'='Thorax')),
             selectInput('y', 'Y',  c('Year'='Year','doy'='doy','Developmental Temperature'='doy162to202','Pupal Temperature'='Tpupal','Forewing Length (mm)'='FWL','Wing Melanism (gray level)'='Corr.Val','Setae length  (mm)'='Thorax')),
             selectInput('color', 'Color', c('Year'='Year','doy'='doy','Developmental Temperature'='doy162to202','Pupal Temperature'='Tpupal','Forewing Length'='FWL'))
      )
      
    ),
    hr(),
    fluidRow(
      column(12,
             includeMarkdown("include3.md")
      ))
  )
)
