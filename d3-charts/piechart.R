library(mongolite)
library(ggplot2)

client = mongo(collection = "events", db = "precog_fb_data", url = "mongodb://localhost", verbose=TRUE )

categories = c('travel','food','music','art','education')
total_count = rep(0,5)
attending_count = rep(0,5)
interested_count = rep(0,5)
maybe_count = rep(0,5)
noreply_count = rep(0,5)
average_count = rep(0,5)

i=0
for(cat in categories){
  i = i+1
  temp_cursor = client$find(paste('{"category":"',cat,'"}',sep=""))
  total_count[i] = length(temp_cursor[[1]])
  for(j in 1:total_count[i]){
    attending_count[i] = attending_count[i] + temp_cursor$attending_count[[j]]
    interested_count[i] = interested_count[i] + temp_cursor$interested_count[[j]]
    maybe_count[i] = maybe_count[i] + temp_cursor$maybe_count[[j]]
    noreply_count[i] = noreply_count[i] + temp_cursor$noreply_count[[j]]
  }
  average_count[i] = round(attending_count[i]/total_count[i], 2)
}

pie_chart_data = data.frame(categories,total_count,attending_count,average_count,interested_count,maybe_count,noreply_count)
setwd("~/fb_event_minor/d3-charts")
write.csv(pie_chart_data, "pie_chart_data.csv")

#plot 1 - total count
ggplot(pie_chart_data, aes(x=factor(1), y=total_count, fill = factor(categories))) +geom_bar(width = 1, stat = "identity")+coord_polar("y", start=0)+scale_fill_brewer(palette="Reds")

library(plotly)
p1 <- pie_chart_data %>%
  plot_ly(labels = ~categories, values = ~total_count, 
          textposition = 'inside', textinfo = 'label+value', 
          insidetextfont = list(color = '#FFFFFF')) %>%
  add_pie(hole = 0.6) %>%
  layout(title = "Total Count Chart",  showlegend = T,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

p1

p2 <- pie_chart_data %>%
  plot_ly(labels = ~categories, values = ~attending_count, 
          textposition = 'inside', textinfo = 'value', hoverinfo = 'value',
          insidetextfont = list(color = '#FFFFFF')) %>%
  add_pie(hole = 0.6) %>%
  layout(title = "Attending Count Chart",  showlegend = T,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

p2

