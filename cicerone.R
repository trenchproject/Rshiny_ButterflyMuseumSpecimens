guide <- Cicerone$
  new()$
  step(
  el = "viz-wrapper",
  title = "Visualization",
  description = HTML("Welcome to our Butterfly museum specimens visualization tool. We will go over the components in this tool.<br><br> Click <b>Next</b> to get started.")
)$
  step(
  el = "trendPlot",
  title = "Plot",
  description = HTML("Each dot represents an individual of <b><i>Colias</i></b> butterflies.
                       Right now, the wing melanism is plotted against year, with the day of year collected colored.<br><br>
                       At a quick glance, we can see that individuals in the Southern RM are getting darker wings in the recent years
                       while those from the Northern RM are getting lighter wings. Let's switch up the parameters and find some new trends. <br><br>Hit <b>Next</b> to move forward.")
)$
  step(
  el = "axes-wrapper",
  title = "Axes",
  description = HTML("Axes can be changed here. Change the x axis to <b>Season Temperature</b>, and y axis to <b>Pupal temperature</b>. <br><br> Then click on<b> Next</b>."),
  position = "top"
)$
  step(
  el = "color-wrapper",
  title = "Colors",
  description = HTML("Let's turn off the colors since they make the plot unnecessarily complicated.<br><br>
   Select <b>off</b> then <b>Next</b>.")
)$
  step(
  el = "region-wrapper",
  title = "Regions",
  description = HTML("Let's focus on the two regions in the rocky mountains.<br><br>
                       Select <b>Northern RM</b> and <b>Southern RM</b>.<br><br>
                       Now, Click <b>Next</b> to see the now plot.")
)$
  step(
  el = "trendPlot",
  title = "New plot!",
  description = HTML("Now we can see that the plot is showing how the pupal temperatures change depending on the seasonal temperatures as we specified.<br><br>
                       The pupal temperature increases in warmer years in both regions but the influence seems to be larger in the Northern RM.")
)$
  step(
  el = "year-wrapper",
  title = "Year",
  description = "Lastly, interact with the slider to change the specific time period."
)
