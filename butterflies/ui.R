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
      )),
    
    p(tippy("*Have spring and summer temperatures increased over the years?", tooltip="When you plot Year on the x-axis and spring and summer temperatures on the y-axis, you see lines sloping upward. This indicates a positive relationship. On average, all three sites have warmed over the years.")),
    
    p(tippy("* Have butterfly wings lightened over the years?", tooltip="When you plot Year on the x-axis and wing melanism on the y-axis, you see the expected pattern (a negative relationship, indicating wing lightening over the years) only for the Northern Rocky Mountains. For the Southern and Canadian Rocky Mountains, you see either no relationship or a positive relationship, which means wings have actually gotten darker over the years despite warming. Why might this be? One thing to consider is that butterflies in the Southern Rocky Mountains are living at extremely high elevations, where conditions even after warming are colder than the other sites. Here, darker wings could allow the butterflies to take advantage of warming to fly farther and longer, especially if shifting phenologies are causing them to be active earlier and later in the season when things are cooler than in midsummer. Also, temperatures fluctuate more dramatically at high elevation, meaning even if it's warmer on average, darker wings are still beneficial in very cool days or years.")),
    
      p(tippy("*Have forewings or setae length decreased over the years?", tooltip="In the Northern and Canadian Rocky Mountains, neither forewing nor setae length have shifted over time, suggesting there hasn't been enough selective pressure to trigger these changes. In the Southern Rocky Mountains, both forewing and setae length have increased over the years, along with wing melanism. This is a surprising result, since they all point toward the butterflies increasing their ability to retain heat even though the climate has warmed. See the discussion linked to the previous question for some possible explanations.")),
    
         p(tippy("* Do spring and summer temperatures affect the day of year when butterflies reach adulthood?", tooltip="When you plot spring and summer temperatures on the x-axis and DOY on the y-axis, you see lines sloping downward. This indicates a negative relationship. In years with warmer spring and summer temperatures, butterfly phenology advances (shifts earlier). However, if you plot Year on the x-axis, there is no clear pattern—meaning average butterfly phenology hasn't advanced over the years.")),

    fluidRow(
      column(12,
             includeMarkdown("include4.md")
      ))
  )
)