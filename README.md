# Facebook_event_analyser
R based facebook event analyser and predictor of interested and going count

# Data Source and Dataset

The data of events from around the world was collected from Facebook using its Graph API belonging to following five categories :
I. Travel
II. Food
III. Music
IV. Art
V. Education
Approximately 250 events from each of these categories (total 1250 events) was fetched from the Graph Api and stored into a MongoDB database.

The dataset consists of 14 major attributes listed below:
1. Name (String) - The event name
2. Description (String) - The description posted by owner for the event
3. Start Time (Time) - Start time of the event
4. End Time (Time) - End Time of the event
5. Timezone (String) - The timezone of the event. This is of the form Country-code/Region.
6. Latitude (Real) - The latitude of the event
7. Longitude (Real) - The longitude of the event.
8. Type (String) - The category of the event i.e travel, food, music, art or education.
9. Attending_count (integer) - count of people attending the event
10. Declined_count (integer) - count of people who declined the event 
11. Interested_count (integer) - count of people who marked “Interested” in the event
12. Maybe_count (integer) - same as interested count
13. Noreply_count (integer) - count of no-reply of invitees in an event.
14. Updated_time (Time) - The most recent time of the event (if updated by the owner).
 


# Tools/ Techniques and Libraries used

I. First the event id for the category wise events was extracted and stored in a JSON file.

II. The stored ids were used to create API calls and make GET requests to Facebook and fetch the event data. This data was stored in a MongoDB database.
	Packages used -Rfacebook, rjson, jsonlite, httr, RMongo, mongolite.

III. The web application for the analysis tool was created using RShiny library of R. Shiny is an R package that makes it easy to build interactive web apps straight from R. The applications consists of a user interface and the server side controls all user inputs and generates necessary outputs/plots. 
A. ui.R- The R script is uses a R package ‘Shiny’ to provide UI to our application.
Packages used- shiny, plotly, shinythemes, ggplot2, maps.

B.  server.R- The R script provides the backend to our application.This file
load data into the application based on the user input and is responsible for creating all kinds of plots. 
Packages used- shiny, plotly, shinythemes, ggplot2, maps.
 


IV. 3 different kind of plots for analysis are created- Donut charts, Geoplots and Word Clouds. All the scripts are present in the folder d3-charts.

A. d3-charts/piechart.R : This script reads data from the database, separates the attributes like Attending Count, Interested Count, Maybe Count, No Reply Count , Declined Count and creates a dataset pie_chart_data.csv  for creating useful pie charts for analysis and comparing values of these attributes across categories. Packages used - RMongo, Mongolite.

B. d3-charts/geochart.R : The script is used to generate geo-map based on the event type.. This script creates by dataset geo_chart_data.csv by separating the latitude and longitude from the original dataset.
Packages Used- mongolite, ggplot2

C.  d3-charts/DataPreProcessing.R : The script fetches data from MongoDB database and performs text pre-processing on the Description attribute of dataset. The NLP techniques are applied for preprocessing to compute word frequencies and create document-term matrix for each category and saves it into 5 five separate file namely dtm-travel.csv, dtm-food.csv, dtm-music.csv, dtm-art.csv and dtm-education.csv. The tm package is used for text preprocessing and text mining. 
Packages Used- mongolite, tm, SnowballC
	 	 	
V.      After analysis we applied machine learning algorithms for prediction of interested count in future based on features like Attending_count, Maybe_count, Can_guest invite, Guest_list_enabled, No_reply_Count.
Two models namely Random Forest and XGBoost ere applied which resulted in approx 85% accuracy. Here accuracy measure is correlation coefficient.We also prepared plots to find importance of feature in prediction.
Packages Used- caTools,randomForest, xgboost
