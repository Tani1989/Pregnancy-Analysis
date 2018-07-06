
source("packages.R")

# Why this dataset?

# The reason for selecting this dataset is to gain more information related to pregnancy,
# while myself being pregnant. I have my blood test for anemia,thyroid, etc during early pregnancy 
# i.e I was 9 weeks pregnant at that time. The test was normal, but in middle of pregnancy my 
# Haemoglobin levels droped. I have to take some vitamins to increase the iron levels. 
# That's the reason I want to analyze the dataset: "Prevalence of anemia in Pregnant Women".


# Prevalence of anemia in Pregnant Women - (1995-2011)
# Prevalence of anemia in pregnant women, measured as the percentage of pregnant women with a hemoglobin level less than 110 grams per liter at sea level.


# Load the dataset
dataset <- read.csv("prevalence-of-anemia-in-pregnant-women-1995-2011.csv",header = TRUE,encoding = "utf-8")

# View the data
head(dataset) # "head funtion displays the first 6 records"

# Rename the columns to get a better understanding
names(dataset)[1] <- paste("region")
names(dataset)[4] <- paste("Percentage_Anemia")

head(dataset)

# Statistical View
summary(dataset)
str(dataset)

# Questions from the data(?)
# 1. Percentage of ANEMIA according to the countries.
# 2. Top 10 countries with high percentage of ANEMIA in pregnant women.
# 3. Yearly analysis of the data.

# Start analyzing the data to answer our first question.
# 1. Percentage of ANEMIA according to the countries.
# a. Extract the data you need
PregData <- dataset[,c(1,3,4)]
head(PregData)

# b. Aggregate the data for better analysis

groupCountry <- aggregate( Percentage_Anemia ~ Country_Name,data = PregData ,FUN = sum)
groupCountry

# Let's create a world map first
# Installing Packages
geocode("Afghanistan")


worldmap <- map_data("world")
dim(worldmap)
head(worldmap,10)

#ggplot() + geom_polygon(data = worldmap, aes(x = long, y = lat, group = group)) + coord_fixed(1.3)
# What is this coord_fixed()?
# It fixes the relationship between one unit in the y direction and one unit in the x direction.
# Then, even if you change the outer dimensions of the plot (i.e. by changing the window size or the size of the pdf file you are saving it to (in ggsave for example)), the aspect ratio remains unchanged.
# In the above case, I decided that if every y unit was 1.3 times longer than an x unit, then the plot came out looking good.
# A different value might be needed closer to the poles.




mergedata <- merge(PregData,worldmap,by = "region")
mergedata$subregion <- NULL
head(mergedata)


head(unique(mergedata,mergedata$region,incomparables = NULL))




checkdata <- head(mergedata,10)
checkdata$order <- NULL
checkdata
#groupCountry <- aggregate( Percentage_Anemia ~ year , data = PregData , FUN = sum)
#groupCountry
# Caveat : Merging the data will delete the region that are not present in the worldmap dataset.

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

world


map <- world +
  geom_point(aes(x = long, y = lat, size = Percentage_Anemia,group = group),
             data = checkdata, 
             colour = 'purple', alpha = .5)
map

