#
# Part of trench-ed project
# author Aji John https://github.com/ajijohn
# adapted from Shiny 
# Server
#

library(shiny)
library(cowplot)

#source(paste(getwd(),'/spatial_functions.R',sep = ""))

# Do house  keeping
absM.all=read.csv(paste(getwd(),"/absM-all.csv",sep = ""))
absM= absM.all

# Define server logic to do filtering
shinyServer(function(input, output) { 

  dataset <- reactive({
    x <- strsplit(as.character(input$year), "\\s+")
    print(x)
    from <- as.numeric(x[1])
    to <-   as.numeric(x[2])
    print(from)
    print(to)
    absM.all %>% filter(Year >=  from & Year <= to)
  })
  
  print(getwd())
  pal = colorNumeric("RdYlBu", domain = absM.all$estElevation)
  output$mymap <- renderLeaflet({
    leaflet(dataset()) %>%
      fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat)) %>%
      addProviderTiles(providers$Esri.WorldTopoMap,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addCircles(~lon,~lat,color = ~pal(estElevation)) %>%
      addLegend(pal = pal, values = ~estElevation) 
  })
  
  output$distPlot <- renderPlot({
    
    p1<- ggplot(data=dataset(), aes(Lat,estElevation,col=region.lab)) + geom_point() +
      theme_classic() +labs(x="Latitude(°)",y="Elevation (m)")
    
    p2<- ggplot(data=dataset(), aes(Year,doy162to202,col=region.lab)) + geom_point() + geom_line() +
      geom_smooth(se = FALSE, method = lm) +
      theme_classic() +labs(x="Year",y="Developmental Temperature (°C)")
    
    plot_grid(p1,p2, ncol=1,nrow = 2,
              labels="", label_size=12, align="v")  
    
  })
  
  output$trendPlot <- renderPlot({
  
  #TODO Make Y Label dynamic

  # trend plot with #add trendlines
  ggplot(data=dataset(), aes_string(x=input$x, y = input$y, color=input$color)) +
      geom_point(alpha=0.8) +
      geom_smooth(se = FALSE, method = lm) +
      theme_classic()+ xlab(input$x) +
      #theme(legend.position="none")+
      scale_color_gradientn(colours = rev(heat.colors(5)))+ 
      theme(legend.key.width=unit(1,"cm"))+
      #labs(color="Developmental Temperature (°C)") +labs(tag="(a)") +
      geom_abline(aes(slope=syear.slope,intercept=syear.int))+
      facet_wrap(~region.lab)
  })
  
})


