# Task_description: AirBnB in New York City

Results are in [Airbnbs_in_NYC_Toby_Law.html](./Airbnbs_in_NYC_Toby_Law.html).

# Data

## AirBnB

The data for AirBnB contains detailed information on all of the approximately 
fifty thousand private apartment listings for rent through the site in New York City. 
The data is for a time before the COVID pandemic because I wanted to remove that 
additional complication for data analysis.

**Selected Variables:**

-   `id`: ID number of the listing
-   `transit`: description of the transit options
-   `host_id`: a unique ID for the host
-   `host_listings_count`: how many places does the host rent out?
-   `latitude`/`longitude`: the Geo coordinates
-   `room_type` / `accommodates` / `bathrooms` / `bedrooms`: some info about the 
place, like number of bed- and bathrooms, whether it is shared etc.
-   `price`: nightly price
-   `availability_365`: What part of the year is the property available to be rented?
-   Number of reviews / Review scores

There are many other variables included, many of which you won't need for the exercise.
 Feel free to discard them.

## Maps

I am providing three types of maps:

-   a vector map of NYC boroughs, as we used them lecture
-   a map of NYC neighborhoods
-   a map of subway lines and stations

To add any other map features, in particular background maps, please feel free to 
use raster maps from google, stamen etc., 
use [NYC's open data page](http://www1.nyc.gov/site/planning/data-maps/open-data.page), 
or use the Columbia Library overview page for 
[NYC map data](http://library.columbia.edu/locations/dssc/data/nyc.html).

### Maps: Neighborhoods of NYC

The file `neighbourhoods.geojson` is a GeoJSON file of NYC neighborhoods. 
Make sure to read it in with the appropriate command.

## Task

In the first three parts, I explore the key variables of AirBnB use, the locations of AirBnB places, and some (potential) indications on how it 
impacts the rental market. 
In the fourth part (optional), I explore whether or not we can find a relationship between the location of subway stations 
and location, type, and features of AirBnB places. 

In each task description, specific visualizations or data analyses are provided, along with some brief 
written explanations as well to situate the visualizations provided. 
To see the code used to create all visualizations, please check out [Airbnbs_in_NYC_Toby_Law.Rmd](./Airbnbs_in_NYC_Toby_Law.Rmd)

### 1. Overall Location

a)  Provide a map to show where in New York City AirBnB listings are located.

b)  Provide a map in which you summarize the density of the AirBnB listings and 
highlight the hot-spots for AirBnB locations. Make sure to annotate a few hot-spots 
on the map.

### 2. Renting out your apartment vs. permanent rentals

An Airbnb host can set up a calendar for their listing so that it is only available 
for a few days or weeks a year. Other listings are available all year round (except 
for when it is already booked). Entire homes or apartments highly available and 
rented frequently year-round to tourists probably don't have the owner present, 
are illegal, and more importantly, are displacing New Yorkers.

Hint: The variable `availability_365`: *What part of the year is the property 
available to be rented?* is a possible choice to categorize rentals.

a)  Choose a combination of *both maps and non-mapping visualizations (graphs or tables)*
 to explore where in NYC listings are available sporadically vs. year-round. 
Make sure to highlight the neighborhoods were most listings appear to be permanent or 
semi-permanent rentals.

b)  Some hosts (identified by `host_id`) operate multiple rentals. 
Provide a data table of the the top hosts, the total number of listings they are 
associated with, the average nightly price, and the estimated average monthly total 
income from these listings.

### 3. Top Reviewed Rentals

Provide an interactive map which shows the Top 100 most expensive and Top 100 best 
reviewed rentals in NYC. The map should differentiate these two groups and upon 
clicking on a point on the map should show some basic information 
(at least 3 pieces of information) in a tool tip.

## ***OPTIONAL*** AirBnB and Subway Access

To be added.

### Maps: NYC subway

In the sub-folder `nyc_subway_map` are the shapefiles for the subway map. 
For parts of the exercise, I want you to use the spatial objects on subway routes 
and subway stops for mapping and some calculations.

#### Subway Access

The second set of data are the locations of all subway stations (and entrances) 
in New York City. While this data would allow us to draw a simple subway map 
(e.g. using `geom_path()` for each line), I also included shapefiles for the 
subway map.

Let's explore how the location, type, and features of AirBnB listings are related 
to subway access. For this part, *select a single neighborhood* that lends itself 
to such an analysis (i.e. has multiple subway stations, different types of AirBnB 
listings etc.). If you are unsure, most neighborhoods in Manhattan will work fine 
(e.g. Midtown, Financial District, East Village). If you feel ambitious you can 
complement this with an analysis of the entire city or an entire borough, but don't 
get bogged down with analyzing 40,000 listings; focus on a single neighborhood.

You should decide what are some interesting questions and patterns to explore and 
map here. But please make sure to incorporate the following pieces of analysis:

-   Use the information about the location of subway stations and AirBnB listings 
to calculate distances from each listing to the next (nearest) subway.
-   Calculate (and display) how many listings are in different perimeters around a 
subway station. Make sure to map the subway stations (and lines) to give the reader 
an idea of what you are doing.
-   Explore whether the price of listings is related to having access to the subway 
nearby. Try to control for some other obvious determinants of price: how many people 
the space sleeps, whether it's an entire property or a private room, the type of 
property (apartment, boat, house, loft), and the number of reviews. 
Display and describe your findings.