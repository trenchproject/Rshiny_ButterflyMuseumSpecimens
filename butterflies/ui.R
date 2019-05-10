#
# Part of trench-ed project
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
library(tippy)

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
    
    p(tippy("1. Year", tooltip="This is the year in which each specimen was collected. Include this variable when you want to look at changes over time.")),
      p(tippy("2. Day of year", tooltip="This is the day of the year (Jan 1 is 1, December 31 is 365) when each specimen was collected. Since adult Colias butterflies only live a few days, this gives us a good estimate of their phenology, especially when they reached adulthood.")),
        p(tippy("3. Seasonal temperature", tooltip="This is a measure of overall spring and summer temperatures in each year.")),
    p(tippy("4. Pupal temperature", tooltip="This is an estimate of how warm it was specifically during the period when a particular specimen was pupating.")),
    p(tippy("5. Wing melanism", tooltip="A measure of the darkness of the underwings.")),
    p(tippy("6. Forewing length", tooltip="A measure of overall body size.")),
    p(tippy("7. Setae length", tooltip="A measure of the longest setae between the first and second leg.")),
    
    p("In addition to selecting variables to display on the x- and y-axes, you have the option of coloring each data point according to a third variable. For example, to see whether pupal temperatures have changed over time, plot Year as the x-axis variable and Pupal temperature as the y-axis variable. If you then select Day of Year as the variable for Color, you’ll be able to see when each specimen was collected. This might be interesting if you wanted to see if pupal temperatures are changing because of climate change, OR because butterflies are experiencing a phenological shift."),
    
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