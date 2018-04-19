library(shiny)
library(plotly)
library(shinythemes)
library(ggplot2)
library(maps)
server <- function(input, output){
  
  ####---------code for button toggling ---------------- #####
  values <- reactiveValues(home = 0, pie = 0, geo = 0, cloud = 0)
  
  observeEvent(input$home, {
    values$home <- 1
    values$pie <- 0
    values$geo <- 0
    values$cloud <-0
  })
  
  observeEvent(input$pie, {
    values$home <- 0
    values$pie <- 1
    values$geo <- 0
    values$cloud <- 0
  })
  
  observeEvent(input$geo, {
    values$home <- 0
    values$pie <- 0
    values$geo <- 1
    values$cloud <-0
  })
  
  observeEvent(input$cloud, {
    values$home <- 0
    values$pie <- 0
    values$geo <- 0
    values$cloud <-1
  })
  
  output$main <- renderUI(
    {
      
      if(values$home)
      {
        tagList(
          h2("About the project"),hr(),paste("Facebook Event Analysis and Interested Count Predictor is a project for analysis of Facebook Events and for getting interested count prediction.A Random Forest model was used for training on a large dataset of ~1000 events.Feature engineering,Data cleaning, Data selection and many other techniques were used for this task.")
        )
      }else
        if(values$pie)
        {
          tagList(
            tabsetPanel(
              type = "tab",
              tabPanel("Total",plotlyOutput("donut1")),
              tabPanel("Attending",plotlyOutput("donut2")),
              tabPanel("Average",plotlyOutput("donut3")),
              tabPanel("Interested",plotlyOutput("donut4")),
              tabPanel("No Reply",plotlyOutput("donut5"))
            )
          ) 
        }
      else
        if(values$geo)
        {
          tagList(
            selectInput('geo_cat','Select an event type', choices = c("All","Travel","Food","Music","Art","Education")),
            plotOutput("geoplot"),
            plotOutput("geo_continent", width = 800, height = 300),br(),br(),br()
          )
        }
      else
        if(values$cloud)
        {
          tagList(
            sidebarPanel(
              selectInput("cloud_cat", "Select event type:",
                          choices = c("Travel","Food","Music","Art","Education"))),
            sidebarPanel(
              sliderInput("freq",
                          "Minimum Frequency:",
                          min = 1,  max = 50, value = 15)),
            sidebarPanel(
              sliderInput("max",
                          "Maximum Number of Words:",
                          min = 1,  max = 300,  value = 100)
            ),
            mainPanel(
              plotOutput("cloud", height = 450, width = 800)
            )
          )
        }
      else{
        tagList(
          h2("About the project"),hr(),paste("This is created by Sajal Subodh")
        )
      }
      
    })
  
  
  ################# end of toggling ########################
  
  ######################### Pie charts #################################3
  pie_chart_data = read.csv("~/fb_event_minor/d3-charts/pie_chart_data.csv")  
  output$donut1 <- renderPlotly({
    p<-pie_chart_data %>%
      plot_ly(labels = ~categories, values = ~total_count, 
              textposition = 'inside', textinfo = 'value', hoverinfo = '%',
              insidetextfont = list(color = '#FFFFFF')) %>%
      add_pie(hole = 0.6) %>%
      #layout(plot_bgcolor='rgb(254, 247, 234)') %>%
      layout(title = "",showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
  })
  output$donut2 <- renderPlotly({
    p<-pie_chart_data %>%
      plot_ly(labels = ~categories, values = ~attending_count, 
              textposition = 'inside', textinfo = 'value', hoverinfo = '%',
              insidetextfont = list(color = '#FFFFFF')) %>%
      add_pie(hole = 0.6) %>%
      layout(title = "Attending count",  showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  output$donut3 <- renderPlotly({
    p<-pie_chart_data %>%
      plot_ly(labels = ~categories, values = ~average_count, 
              textposition = 'inside', textinfo = 'value', hoverinfo = '%',
              insidetextfont = list(color = '#FFFFFF')) %>%
      add_pie(hole = 0.6) %>%
      layout(title = "Average Attending Count",showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  output$donut4 <- renderPlotly({
    p<-pie_chart_data %>%
      plot_ly(labels = ~categories, values = ~interested_count, 
              textposition = 'inside', textinfo = 'value', hoverinfo = '%',
              insidetextfont = list(color = '#FFFFFF')) %>%
      add_pie(hole = 0.6) %>%
      layout(title = "Interested Count",  showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  output$donut5 <- renderPlotly({
    p<-pie_chart_data %>%
      plot_ly(labels = ~categories, values = ~noreply_count, 
              textposition = 'inside', textinfo = 'value', hoverinfo = '%',
              insidetextfont = list(color = '#FFFFFF')) %>%
      add_pie(hole = 0.6) %>%
      layout(title = "No Reply Count",  showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  ######################### Geo Plot ###############################
  geo_data = read.csv("~/fb_event_minor/d3-charts/geo_data.csv")
  world_map <- map_data("world")
  
  base_map <- ggplot() + coord_fixed() + xlab("") + ylab("")
  base_world_messy <- base_map + geom_polygon(data=world_map, aes(x=long, y=lat, group=group), 
                                              colour="light green", fill="light green")
  
  #Strip the map down so it looks super clean (and beautiful!)
  cleanup <- 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          panel.background = element_rect(fill = 'white', colour = 'white'), 
          axis.line = element_line(colour = "white"), legend.position="none",
          axis.ticks=element_blank(), axis.text.x=element_blank(),
          axis.text.y=element_blank())
  
  base_world <- base_world_messy + cleanup
  #input$geoplot <- reactiveVal("All")
  #print(input$geo_plot)
  output$geoplot <- renderPlot({
    if(input$geo_cat=='All'){
      base_world + geom_point(data = geo_data, 
                              aes(x=longitude, y=latitude, fill = category),
                              pch=21,size=4, alpha=I(0.7), show.legend = TRUE)}
    else {
      if(input$geo_cat == "Travel") geo_cat = "travel"
      else if(input$geo_cat == "Food") geo_cat = "food"
      else if(input$geo_cat == "Music") geo_cat = "music"
      else if(input$geo_cat == "Art") geo_cat = "art"
      else if(input$geo_cat == "Education") geo_cat = "education"
      base_world + geom_point(data = geo_data[geo_data$category == geo_cat,], 
                              aes(x=longitude, y=latitude), fill = "Red",
                              pch=21,size=4, alpha=I(0.7), show.legend = TRUE)
    }
    
  })
   ############################# geo continent histograms #######################3
  
  geo_data_continent = read.csv("~/fb_event_minor/d3-charts/geo_data_continent.csv")
  output$geo_continent = renderPlot({
    
    if(input$geo_cat=='All'){
      ggplot(data = geo_data_continent, aes(x = continent, fill = category))+geom_bar()
    }
    else {
      if(input$geo_cat == "Travel") geo_cat = geo_data_continent[geo_data_continent$category=='travel',]
      else if(input$geo_cat == "Food") geo_cat = geo_data_continent[geo_data_continent$category=='food',]
      else if(input$geo_cat == "Music") geo_cat = geo_data_continent[geo_data_continent$category=='music',]
      else if(input$geo_cat == "Art") geo_cat = geo_data_continent[geo_data_continent$category=='art',]
      else if(input$geo_cat == "Education") geo_cat = geo_data_continent[geo_data_continent$category=='education',]
      ggplot(data = geo_cat , aes(x = continent))+geom_bar(fill = 'orange')
      
    }
  })
  
  ######################### word cloud ###################################
  
  output$cloud <- renderPlot({
    if(input$cloud_cat == "Travel") cloud_cat = "travel"
    else if(input$cloud_cat == "Food") cloud_cat = "food"
    else if(input$cloud_cat == "Music") cloud_cat = "music"
    else if(input$cloud_cat == "Art") cloud_cat = "art"
    else if(input$cloud_cat == "Education") cloud_cat = "education"
    print(cloud_cat)
    d <- read.csv(paste0("~/fb_event_minor/d3-charts/dtm-",cloud_cat,".csv"))
    set.seed(1234)
    wordcloud(words = d$word, freq = d$freq, min.freq = input$freq,
              max.words=input$max, random.order=FALSE, rot.per=0.35, 
              colors=brewer.pal(8, "Dark2"))
  })
}
