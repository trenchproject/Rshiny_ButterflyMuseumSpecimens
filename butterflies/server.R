#
# Part of trench project
# author Aji John https://github.com/ajijohn
# adapted from Shiny 
# Server
#

library(shiny)
source(paste(getwd(),'/spatial_functions.R',sep = ""))

# Do house  keeping
absM.all=read.csv(paste(getwd(),"/absM-all.csv",sep = ""))


# Define server logic to do filtering
shinyServer(function(input, output) {

  dataset <- reactive({
    absM.all[sample(nrow(absM.all), input$sample_size),]
  })
  
  print(getwd())
  

  output$trendPlot <- renderPlot({
  
  #TODO Make Y Label dynamic
  #ylab("Forewing length (mm)")
    
  # trend plot with #add trendlines
  ggplot(data=dataset(), aes_string(x=input$x, y = input$y, color=input$color)) +
      geom_point(alpha=0.8) +theme_classic()+ xlab("year") +
      theme(legend.position="none")+
      scale_color_gradientn(colours = rev(heat.colors(5)))+ 
      theme(legend.key.width=unit(1,"cm"))+
      labs(color="Developmental Temperature (°C)") +labs(tag="(a)") +
      geom_abline(aes(slope=syear.slope,intercept=syear.int))+
      facet_wrap(~region.lab)
  })
  
})
