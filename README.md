# Rshiny_ButterflyMuseumSpecimens

ButterflyMuseumSpecimens is an interactive shiny app that allows any user to visualize the relationship between temperature and butterflies' morphology and physiology taken from museum specimens. 
The app aims to picture what impact climate change can have on butterflies. The data were gathered by [Maclean et al. in 2018](https://royalsocietypublishing.org/doi/full/10.1098/rstb.2017.0404). 

## Prerequisites for opening in Rstudio
Git and Rstudio ([Instructions](https://resources.github.com/whitepapers/github-and-rstudio/))  
Installation of the following R packages:
shiny, tidyverse, leaflet, leaflet.extras, tippy, cowplot, shinyWidgets, cicerone, shinyjs, shinyBS

```
pkgs <- c('shiny', 'tidyverse', 'leaflet', 'leaflet.extras', 'tippy', 'cowplot', 'shinyWidgets', 'cicerone', 'shinyjs', 'shinyBS')
lapply(pkgs, FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
    }
  }
)
```

## Using ButterflyMuseumSpecimens
* Opening in Rstudio:  
Click on "Code" on the top right to copy the link to this repository.  
Click ```File```, ```New Project```, ```Version Control```, ```Git```  
Paste the repository URL and click ```Create Project```.

* Alternatively, go to [this link](https://huckley.shinyapps.io/butterflies/).

We have a google doc with questions to guide through the app for further understanding of the topic.

## Contributing to ButterflyMuseumSpecimens
<!--- If your README is long or you have some specific process or steps you want contributors to follow, consider creating a separate CONTRIBUTING.md file--->
To contribute to ButterflyMuseumSpecimens, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. Create the pull request.

Alternatively see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).
