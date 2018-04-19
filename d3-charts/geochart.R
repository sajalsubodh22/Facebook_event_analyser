library(mongolite)
library(ggplot2)

client = mongo(collection = "events", db = "precog_fb_data", url = "mongodb://localhost", verbose=TRUE )

categories = c('travel','food','music','art','education')

category = vector()
longitude = list()
latitude = list()

for(cat in categories){
  temp_cursor = client$find(paste('{"category":"',cat,'"}',sep=""))
  len = length(unlist(temp_cursor$longitude))
  temp_cat = unlist(temp_cursor$category)
  category = c(category,temp_cat[1:len])
  timezone = strsplit(unlist(temp_cursor$timezone),'/')
  for(cont in timezone){
    continent = c(continent, cont[1])
  }
  longitude = c(longitude, temp_cursor$longitude)
  print(length(unlist(longitude)))
  latitude = c(latitude, temp_cursor$latitude)
  }
longitude = unlist(longitude)
latitude = unlist(latitude)
geo_data = data.frame(category,longitude,latitude,continent)


category = vector()
continent = vector()
for(cat in categories){
  temp_cursor = client$find(paste('{"category":"',cat,'"}',sep=""))
  if(cat == 'music'){
    temp_cursor[temp_cursor$category!="NULL" & temp_cursor$timezone=='NULL',]$timezone = 'America'
  }
  category = c(category,unlist(temp_cursor$category))
  timezone = strsplit(unlist(temp_cursor$timezone),'/')
  for(cont in timezone){
    continent = c(continent, cont[1])
  }
}

geo_data_continent = data.frame(category,continent)

setwd('~/fb_event_minor/d3-charts')
write.csv(geo_data, "geo_data.csv")
write.csv(geo_data_continent, "geo_data_continent.csv")

ggplot(data = geo_data_continent[geo_data_continent$category=='travel',], aes(x = continent))+geom_bar()
