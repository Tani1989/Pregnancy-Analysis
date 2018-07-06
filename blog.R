# How I created my first animation with ggplot2.

# I wanted to create animation with ggplot2 and using gganimate function.
# But It wasn't that easy for me. I got lots of errors and difficulties while creating this animation.
# Let's start our journey to create my first animation.

# Dataset : The dataset I am considering for this blog is "Prevalence of Anemia in Pregnant Women".

# Introduction : I am creating a map which shows the percentage of pregnant women with anemia.
# and the animated gif is created which automatically display the various years and the percentage will change
# accordingly.

# Load the dataset.

dataset <- read.csv("prevalence-of-anemia-in-pregnant-women-1995-2011.csv",header = TRUE,encoding = "utf-8")

# View Dataset.

head(dataset)
tail(dataset)

# Rename the columns for better understanding.

names(dataset)[1] <- paste("region")
names(dataset)[4] <- paste("Percentage_Anemia")

# Install the packages you need to create your animation.
# For better view I have created seperate file for installing R packages.

source("packages.R")

# Select the columns you need to create the plot.

PregData <- dataset[,c(1,3,4)]

# As you can see that we need geocodes for the countries to create the map.
# Firstly we get the geocodes for all the countries.

worldmap <- map_data("world")
head(worldmap)

# Lets now find the geocodes for the countries in the dataset.
# 1. Find unique countries in the data

data <- as.data.frame(PregData$region)
names(data)[1] <- paste("region")

uniquedata <- unique(data)

# 2. I am using INTERSECT function to delete the colnames that are not countries.

data1 <- intersect(uniquedata$Country,worldmap$region)
intersectdata <- as.data.frame(data1)

# 3. Now that I have the correct countries I will find there geocodes with the GEOCODE function.

geocodedata <- geocode(intersectdata)

# 4. After getting the geocodes I will create two rows in my uniquedata for longitude and latitude and assign them values.

intersectdata$long <- geocodedata$lon
intersectdata$lat <- geocodedata$lat

mergedata <- merge(intersectdata,PregData,by = "region")

# 5. I am only showing you how to create the gif. So I'll be using some data.

sampledata <- head(mergedata,10)

# 6. Create a blank map here and then fill it with your data.

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

p <- world + geom_point(aes(long,lat,frame=Year,size = Percentage_Anemia,color = region),sampledata) + theme(legend.position = "none")
gganimate(p,ani.width = 800,ani.height = 500)

# Unfortunately, my gganimate function doesn't work here. Lots of errors came at first, but after more searching
# on the internet I finally found the solution.

# 7. Solution.
devtools::install_github("dgrtwo/gganimate") 
devtools::install_github("yihui/animation")

# After this I got my gganimate working.
p <- world + geom_point(aes(long,lat,frame=Year,size = Percentage_Anemia,color = region),sampledata) + theme(legend.position = "none")
gganimate(p,ani.width = 800,ani.height = 500)











  
