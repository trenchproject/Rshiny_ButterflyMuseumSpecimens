#
# Part of trench-ed project
# author Aji John https://github.com/ajijohn
# adapted from Shiny 
# Server
#

absM.all=read.csv("absM-all.csv")
varnames = c('Year'='Year','Day of Year'="doy",'Season Temperature (°C)'='doy162to202','Pupal Temperature (°C)'='Tpupal','Forewing Length (mm)'='FWL','Wing Melanism (gray level)'='Corr.Val','Setae length  (mm)'='Thorax')

#Add elevation level to region labels
region_labels <- c("Canadian RM (Low elevation)", "Northern RM (Mid elevation)", "Southern RM (High elevation)")
names(region_labels) <- c("Canadian RM", "Northern RM", "Southern RM")


# Define server logic to do filtering
shinyServer <- function(input, output) { 

  dataset <- reactive({
    x <- strsplit(as.character(input$year), "\\s+")
    from <- as.numeric(x[1])
    to <- as.numeric(x[2])
    absM.all %>% filter(Year >= from & Year <= to & region.lab %in% input$region)
  })

  pal = colorNumeric("RdYlBu", domain = absM.all$estElevation)
  
  output$mymap <- renderLeaflet({
    leaflet(dataset()) %>%
      fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat)) %>%
      addProviderTiles(providers$Esri.WorldTopoMap,
                       options = providerTileOptions(noWrap = TRUE)) %>%
      addCircles(~lon, ~lat, color = ~pal(estElevation)) %>%
      addLegend(pal = pal, values = ~estElevation, title="Elevation (m)") 
  })
  
  output$distPlot <- renderPlot({
    
    p1 <- ggplot(data=dataset(), aes(Lat, estElevation, col=region.lab)) + geom_point() +
      theme_classic() + labs(x = "Latitude (°)", y = "Elevation (m)", col = "Region") + 
      theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12), 
            legend.text = element_text(size = 12), legend.title = element_text(size = 12))
    
    p2 <- ggplot(data=dataset(), aes(Year,doy162to202,col=region.lab)) + geom_point() + geom_line() +
      geom_smooth(se = FALSE, method = lm) +
      theme_classic() + labs(x = "Year", y = "Season Temperature (°C)", col = "Region") +
      theme(axis.text=element_text(size = 12), axis.title=element_text(size = 12), 
            legend.text = element_text(size = 12), legend.title = element_text(size = 12)) 
     
    plot_grid(p1, p2, ncol = 1,nrow = 2, labels = "", label_size = 12, align = "v")  
    
  })
  
  output$trendPlot <- renderPlot({
  
    #TODO Make Y Label dynamic
    xlabel <- names(varnames[which(varnames == input$x)])
    ylabel <- names(varnames[which(varnames == input$y)])
    colorlabel <- names(varnames[which(varnames == input$color)])
  
    # trend plot with #add trendlines
    if(input$color_or_not=='On'){
      p <- ggplot(data=dataset(), aes_string(x=input$x, y = input$y, color=input$color)) +
          scale_color_gradientn(colours = rev(heat.colors(5)))+ 
          labs(x=xlabel, y=ylabel, color=colorlabel) + 
          geom_abline(aes(slope=syear.slope,intercept=syear.int))
    } else {
      p <- ggplot(data=dataset(), aes_string(x=input$x, y = input$y)) +
        labs(x=xlabel, y=ylabel)
    }
    
    p <- p + geom_point(alpha=0.8) + geom_smooth(se = FALSE, method = lm) + 
      theme_classic() +
      geom_abline(aes(slope=syear.slope,intercept=syear.int)) + 
      facet_wrap(~region.lab, labeller = labeller(region.lab = region_labels)) +
      theme(legend.key.width=unit(1,"cm"), strip.text = element_text(size = 12), axis.text=element_text(size=12), 
            axis.title=element_text(size=12), legend.text=element_text(size=12), legend.title=element_text(size=12))
    p
  })
}


