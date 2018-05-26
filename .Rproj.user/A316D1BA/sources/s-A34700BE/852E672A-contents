library(Rfacebook)
library(rjson)
library(jsonlite)
library(httr)
library(RMongo)
library(mongolite)

setwd("~/fb_event_minor/data/")

fb_oauth = "EAACEdEose0cBAMjfaelTilLZAOwuNAO79F75zXLxodmjC4B0BUtdQMVmoBY3LDeCrVj4rxuS71o2AafeCCgc6Fbl3FEGlQlsmunRAYRytym15XbhyxjOailpsetkZCFbx96rmU1IZAvzCB637HLTZAsCxoEFk4e53z4ZCLYWZCDuHXtnAJe8bom4lKZA2IvtR0BktZCjB30IbAZDZD"

url = "https://graph.facebook.com/v2.12/search?type=event&limit=1000&fields=id&q="
categories = c('travel', 'food', 'music', 'art', 'education')

events_dic = list()
for(cat in categories){
  #print()
  events = fromJSON(paste(url,cat,"&access_token=",fb_oauth,sep=""))
  events_dic[cat] = events$data
}

sum = 0
for(cat in names(events_dic))
{
  print(cat)
  print(length(events_dic[[cat]]))
  sum = sum + length(events_dic[[cat]])
}
print(paste("Total:",sum))

result = toJSON(events_dic)
write(result, "ids.json")

all_possible_events = c('attending_count,declined_count,description,end_time,interested_count,maybe_count,name,noreply_count,start_time,timezone,type,updated_time')
client = mongo(collection = "events", db = "precog_fb_data", url = "mongodb://localhost", verbose=TRUE )
count = 0
url_details  = "https://graph.facebook.com/" 
for(cat in names(events_dic)){
  for(current_id in events_dic[[cat]]){
    if(count<854){
      count=count+1
      next}
    if(count==854 | count==383){print(current_id)}
    #print(paste(url_details,current_id,"?fields=",all_possible_events,"&access_token=",fb_oauth,sep=""))
    temp_event = fromJSON(paste(url_details,current_id,"?fields=",all_possible_events,"&access_token=",fb_oauth,sep=""))
    temp_location = fromJSON(paste(url_details,current_id,"?fields=place&access_token=",fb_oauth,sep=""))
    temp_event$category = cat
    location = temp_location$place$location
    event = c(temp_event,location)
    client$insert(event)
    count = count + 1
    print(count)
    }
}

print(count)

event_all = client$find()
