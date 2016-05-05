Make a web application with Shiny!
==================================
author: Julin Maloof
date: May 05, 2016

Goal
=====
incremental: true

* Make and deploy interactive web applications with [Shiny](http://shiny.rstudio.com/).
* Shiny allows you to display your R analysis on the web to anyone.  For example:  
* I used Shiny to write an app to visualize a [Markov Chain simulation of genetic drift](http://symposium.plb.ucdavis.edu:3838/MarkovDrift/).  
* A student from last years BIS180L is now working in my lab and is working up a [visualizer for QTL data and gene expression](http://symposium.plb.ucdavis.edu:3838/QTL-Visualization/).  
* The Shiny website has plenty of [additional examples](http://shiny.rstudio.com/gallery/).

Components of a Shiny App
==========================

A ShinyApp consists of two R scripts:

* __ui.R__ This script controls the user interface (i.e. the design of the webpage, the input and the output).
* __server.R__ This script does the work of performing any analysis, creating graphs, and creating tables

These two scripts must be saved together in a single directory.  Each app much be saved in a different directory.

Show scripts
============

Moving information between `ui.R` and `server.R`
=============================================

* information is passed via the `input` and `output` variables.

ui.R

```r
radioButtons("trait", #the input variable that the value will go into
             "Choose a trait to display:", #title
             c("Sepal.Length","Sepal.Width",
               "Petal.Length","Petal.Width") ) #options
```
server.R

```r
pl <- ggplot(data = iris,aes_string(x="Species",y=input$trait, fill="Species"))
```

`trait` in `ui.R` becomes `input$trait` in `server.R`

Moving information between `ui.R` and `server.R`
=============================================

ui.R

```r
mainPanel(plotOutput("boxPlot"))
```

server.R

```r
  output$boxPlot <- renderPlot({
        pl <- ggplot(data = iris,aes_string(x="Species", y=input$trait, fill="Species"))
        pl + geom_boxplot()
  })
```

`output$boxPlot` in `server.R` is accessed as `boxPlot` in `server.R`
  
Keep your script fast
=====================

* Anything within a `renderNNN` statement will be run **every** time that the plot changes.
* So load data files and do one-time calculations at the **begining** of your server.R script.

```r
library(shiny)
library(ggplot2)

#load files and do one-time calculations here!

shinyServer(function(input, output) {
  output$boxPlot <- renderPlot({
    
  # Anything here gets re-run every time user input changes!
...
```


Running on your computer
=========================

To try the app on your computer, save the above scripts in ui.R and server.R, respectively, in a directory for this app.
Then from the R console:


```r
library(shiny)
runApp('PATH_TO_APP_DIRECTORY')    
```

Sharing
=========
Now that we have our awesome application how do we share it?

Multiple options:

If you are sharing it with someone that uses R and has the shiny library installed, then you can just send it to them, they can download it, and run it as above.

Sharing: GitHub
===============

If you have it on GitHub and the person you want to share it with has R they can use:

```r
library(shiny)
runGitHub(repo = "HamiltonDemos",username = "jnmaloof", subdir = "BinomialDrift")
```

Sharing: www.shinyapps.io
==========================

You can use Rstudio's __free__ [shiny server](http://www.shinyapps.io/)
Once you have signed up for an account and authenticated it a simple as:

```r
library(shinyapps)
shinyapps::deployApp('path/to/your/app')
```
You can see my version [here](https://jnmaloof.shinyapps.io/irisApp/)

Sharing: set up your own server
===============================
If you are advanced you can [run your own server](http://www.rstudio.com/products/shiny/shiny-server/)

(I actually set up a server my lab--it isn't that hard)

Teams
======

Today we will work in teams of three.

Each team will produce and deploy a Shiny app that will be collectively graded.

| Student 1              | Student 2              | Student 3      | Repository                 |
|------------------------|------------------------|----------------|----------------------------|
| Alla Hussein           | Dylan Antonious        | Chris Campbell |                            |
| Avery Wang             | Caitlin Clark-Wiest    | Gina De La O   |                            |
| Siddharth Bhadra-Lobo  | Jay Boinapalli         | Anh Nguyen     |                            |
| Weston Selna           | Smia Sahebi            | Miranda Stever |                            |
| Amanda Everitt         | Brianna Daniels        | Saghi Nojoomi  |                            |
| Ellis Anderson         | Claudia Dastmalchi     | Joyce Yu       |                            |
| Garrett Eliot          | Henry Knight           | Anushriya Subedy|                            |
| Jordan Anderson        | Andy Pham              | Paul Zaman     |                            |
| Alina Orozco           | An Nguyen              | Kathleen Furtado|                             |
| John Davis             | Shawn Higdon           | Maisee Yang    |                            |
| Bowen Noack            | Francesca Macarandang  | Xiaomeng Yang  |                            |
| Chynna Gabotero        | Alexander Duveneck     | Jennifer Koo   |                            |
| Aaron Baer             | Jacob North            | Sam Deck       |                            |
| Andrew Katznelson      | Livingstone Nganga     | Mai Khanh Tran |                            |
| Cassandra Baker        | Anh Nguyen             | Sarah Stinson  |                            |

Assignment
==========

Your team should work together to create and deploy a ShinyApp that plots some aspect of the data from the BLAST or RICE labs.  The app should allow user input that modifies the plot in a useful way.

I have listed some ideas below, __but feel free to choose something else__

BLAST ideas
===========

* Interactive plot to explore different hypotheses for Exercise 13 from the [R Intro lab]({{site.url}}/{% post_url 2015-04-14-R-intro %}).
  * The user could select which trait might affect the sequence length vs score relationship.  The plot could be a scatter plot of score vs sequence length colored by the value of the user-selected variable.  If you want to get fancy add a [slider-bar](http://shiny.rstudio.com/gallery/sliders.html) that allows the user to set the limits of the data ploted.    
  * Or the plot could be a boxplot of score faceted by high and low sequence length and high and low values of the user-selected variable (you could split these by median length).  Again you could add a [slider-bar](http://shiny.rstudio.com/gallery/sliders.html) that allows the user to set the split point for the graph facets.
  
RICE data ideas
================

__You might want to limit the user input to 5 or 10 traits in the examples below, just to save yourself some typing and to keep the radio button list not too long__

* Interactive plot showing histograms or violin plots or boxplots of user-selected phenotypic data split by ancestral population assignment or region.  You could also allow the user to choose whether it was a histogram or a violin plot, etc.
* scatter plot of any two traits (user chosen), colored by the values of a third (user chosen).
* If you want to get fancy in either of the above then you could use the [selectize](http://shiny.rstudio.com/gallery/selectize-examples.html) tool to allow the user to select from all of the possible phenotypes.

Scoring (out of 20 points)
==========================

16 points for a functional, interactive web app deployed on shinyapps.io and pushed to GitHub.  

\+ 2 points for using two or more input types.  
\+ 2 points for good annotation on the web page (a new user would understand what the app is about).  
\- 2 points for each student that does not make at least 2 commits to the team repository.
