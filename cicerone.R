guide <- Cicerone$
  new()$
  step(
    el = "viz-wrapper",
    title = "Visualization",
    description = "Welcome to our Butterfly museum specimens visualization tool. We will go over the components in this tool. Click next to get started."
  )$
  step(
    el = "trendPlot",
    title = "Plot",
    description = HTML("Each dot represents an individual of Colias butterflies. 
                       Right now, the wing melanism is plotted against year, with the day of year collected colored.<br>
                       At a quick glance, we can see that individuals in the Southern RM are getting darker wings in the recent years 
                       while those from the Northern RM are getting lighter wings. Let's switch up the parameters and find some new trends. Hit next to move forward.")
  )$
  step(
    el = "axes-wrapper",
    title = "Axes",
    description = HTML("Axes can be changed here. Let's change the x axis to <b>Season Temperature</b>, and y axis to <b>Pupal temperature</b>. Hit next."),
    position = "top"
  )$
  step(
    el = "color-wrapper",
    title = "Colors",
    description = HTML("Let's turn off the colors since they make the plot unnecessarily complicated. Hit next after clicking <b>off</b>.")
  )$
  step(
    el = "region-wrapper",
    title = "Regions",
    description = HTML("Let's focus on the two regions in the rocky mountains.<br> 
                       Select <b>Northern RM</b> and <b>Southern RM</b> while holding ctrl button. They should be colored blue once selected.<br>
                       Now let's go back to the plot to see how it looks.")
  )$
  step(
    el = "trendPlot",
    title = "New plot!",
    description = HTML("Now we can see that the plot is showing how the pupal temperatures change depending on the seasonal temperatures as we specified.
                       The pupal temperature increases in warmer years in both regions but the influence seems to be larger in the Northern RM.")
  )$
  step(
    el = "year-wrapper",
    title = "Year",
    description = "Lastly, if you want specific periods, this slider lets you do it."
  )