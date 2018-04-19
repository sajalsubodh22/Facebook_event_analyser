library(shiny)
library(plotly)
library(shinythemes)
library(ggplot2)
library(maps)
library(wordcloud)
ui <-fluidPage( 
  tags$head(
    tags$style('#home,#pie,#geo,#cloud{background-color:#406FFF;color:white}')
  ),
  helpText(HTML("<div style='width:100%;background-color:#406FFF;color:#ffffff;padding:10px'><h1>Facebook Event Analyser</h1></div>")),
  #headerPanel("Facebook Event Analyser"),br(),br(),br(),br(),
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        helpText(HTML("Go to home")),
        actionButton(inputId = "home", label="Home" , width = "100%")
      ),
      wellPanel(
        helpText(HTML("<font size = 6><b>Pie Charts</b></font><br>This section contains the donut charts depicting the count of various parameters of events data")),
        actionButton(inputId = "pie", label="Pie Chart" , width = "100%")
      ),
      
      wellPanel(
        helpText(HTML("<font size = 6><b>Geo Plots</b></font><br>This section shows the distribution of all events in the dataset on the world map")),
        actionButton(inputId = "geo", label="Geo Plot" , width = "100%")
      ),
      wellPanel(
        helpText(HTML("<font size = 6><b>Word Clouds</b></font><br>Get to know the most import words used in event descriptions. Set your own parameters and enjoy!")),
        actionButton(inputId = "cloud", label="Word Cloud" , width = "100%")
      )
      #selectInput(inputId = "param", label = "Select a parameter", choices = colnames(pie_chart_data))
    ),
    mainPanel(
      uiOutput("main")
      #plotlyOutput("donut")
    )
  )
)
