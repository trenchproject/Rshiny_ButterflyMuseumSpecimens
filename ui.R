library(shiny)
library(tidyverse)
library(leaflet)
library(leaflet.extras)
library(tippy)
library(cowplot)
library(shinyWidgets)
library(cicerone)
library(shinyjs)
library(shinyBS)

dataset <- read.csv(paste(getwd(), "/absM-all.csv", sep = ""))
regions <- c("Canadian RM", "Northern RM", "Southern RM")

# Define UI
shinyUI(
  fluidPage(
    # Include the favicon
    tags$head(
      tags$link(
        rel = "icon",
        href = "TrenchEdLogo.png", # Make sure this matches your file name and extension
        type = "image/png"
      ) # Change the type if your favicon is not a PNG
    ),
    use_cicerone(),
    useShinyjs(),
    setBackgroundColor(color = "white"),
    title = "Butterfly Coloration",
    titlePanel(
      div(
        tags$img(src = "TrenchEdLogo.png", height = 50),
        "Morphological Responses to Climate Change",
        style = "text-align: cente; background-color: #367fa9; color: white; padding: 10px; border-radius: 5px;"
      )
    ),
    includeMarkdown("include.md"),
    fluidRow(
      column(
        6,
        leafletOutput("mymap")
      ),
      column(
        6,
        imageOutput("distPlot")
      )
    ),
    hr(),
    includeMarkdown("include2.md"),
    p(tippy("1. Year", tooltip = "This is the year in which each specimen was collected. Include this variable when you want to look at changes over time.")),
    p(tippy("2. Day of year", tooltip = "This is the day of the year (Jan 1 is 1, December 31 is 365) when each specimen was collected. Since adult Colias butterflies only live a few days, this gives us a good estimate of their phenology, especially when they reached adulthood.")),
    p(tippy("3. Seasonal temperature", tooltip = "This is a measure of overall spring and summer temperatures in each year.")),
    p(tippy("4. Pupal temperature", tooltip = "This is an estimate of how warm it was specifically during the period when a particular specimen was pupating.")),
    p(tippy("5. Wing melanism", tooltip = "A measure of the darkness of the underwings.")),
    p(tippy("6. Forewing length", tooltip = "A measure of overall body size.")),
    p(tippy("7. Setae length", tooltip = "A measure of the longest setae between the first and second leg.")),
    p("In addition to selecting variables to display on the x- and y-axes, you have the option of coloring each data point according to a third variable. For example, to see whether pupal temperatures have changed over time, plot Year as the x-axis variable and Pupal temperature as the y-axis variable. If you then select Day of Year as the variable for Color, you’ll be able to see when each specimen was collected. This might be interesting if you wanted to see if pupal temperatures are changing because of climate change, OR because butterflies are experiencing a phenological shift."),
    actionBttn(
      inputId = "reset",
      label = "Reset",
      style = "material-flat",
      color = "danger",
      size = "xs"
    ),
    bsTooltip("reset", "If you have already changed the variables, reset them to default here before starting the tour."),
    actionBttn(
      inputId = "tour",
      label = "Take a tour!",
      style = "material-flat",
      color = "success",
      size = "sm"
    ),
    hr(),
    div(
      id = "viz-wrapper",
      h4("Filter"),
      fluidRow(
        column(
          3,
          div(
            id = "year-wrapper",
            sliderInput("year", "Year",
              min = min(dataset$Year),
              max = max(dataset$Year),
              value = c(
                min(dataset$Year),
                max(dataset$Year)
              ),
              sep = "", step = 1
            )
          ),
          div(
            id = "color-wrapper",
            radioButtons("color_or_not", "Color", c("On", "Off"))
          ),
          br()
        ),
        column(3,
          offset = 1,
          div(
            id = "axes-wrapper",
            selectInput("x", "X", choices = list(
              Temporal = c("Year" = "Year", "Day of Year Collected" = "doy"),
              Environmental = c("Season Temperature(°C)" = "doy162to202", "Pupal Temperature(°C)" = "Tpupal"),
              Morphological = c("Forewing Length (mm)" = "FWL", "Wing Melanism (gray level)" = "Corr.Val", "Setae length (mm)" = "Thorax")
            )),
            selectInput("y", "Y", choices = list(
              Environmental = c("Season Temperature(°C)" = "doy162to202", "Pupal Temperature(°C)" = "Tpupal"),
              Morphological = c("Forewing Length (mm)" = "FWL", "Wing Melanism (gray level)" = "Corr.Val", "Setae length (mm)" = "Thorax")
            ), selected = "Corr.Val"),
          ),
          uiOutput("colorInput")
        ),
        column(3,
          offset = 1,
          div(
            id = "region-wrapper",
            checkboxGroupInput("region", "Region", choices = as.character(regions), selected = regions)
          )
        )
      ),
      plotOutput("trendPlot"),
    ),
    hr(),
    includeMarkdown("include3.md")
  )
)
