library(ggplot2)
library(rpart)
library(ggmap)
library(reshape2)
san <- read.csv("sanfrancisco_incidents_summer_2014.csv", stringsAsFactors=FALSE)
# treat Category field of the crime database as a factor (crime)
san$crime  <- factor((tolower(san$Category)))

# subset crime categories
Data           <- as.data.frame(table(san$crime), stringsAsFactors = FALSE)
# Name the columns
colnames(Data) <- c("Category", "Frequency")

# Reorder caterories of crime within the dataframe
Data           <- Data[order(Data$Frequency, decreasing = TRUE), ]


# force the new order as factor, necessary to force the order in the chart
Data$Category  <- factor(Data$Category, levels = Data$Category)
# filter to the top 10
Data           <- Data[1:10, ]



# create the chart for category
g <- ggplot(Data)
g <- g + geom_histogram(aes(x = Category, y = Frequency, fill = Frequency), stat = "identity")
g <- g + ggtitle(expression(atop("Crime in San Francisco", atop(italic("Top 10 Criminal Incidents (Summer 2014)"), ""))))
g <- g + scale_fill_continuous(low = "cyan", high = "blue")
g <- g + theme(axis.text.x = element_text(angle = 45, hjust = 1))
g







# transform hour into a numeric for plotting
san$hour<-as.numeric(substring(san$Time,1,2))

t<-qplot(san$hour[san$crime=="larceny/theft"], geom="histogram",col=I("blue"),
          fill=I("red"),alpha=I(.9),xlab="Time (hours)",
          binwidth=1,xlim=c(0,24),
          main="Larceny/theft in San Francisco vs time of the day")

p<-qplot(san$hour, geom="histogram",col=I("blue"),
          fill=I("red"),alpha=I(.9),xlab="Time (hours)",
          binwidth=1,xlim=c(0,24),
          main="San Francisco crimes vs time of the day")


p


san$Latitude   <- san$Y
san$Longitude  <- san$X

san$Category   <- factor(san$Category)
sf_sub          <- subset(san, Category %in% c("Larceny/theft", "ASSAULT",
                                              "Vehicle Theft", "Warrants",
                                              "Drug/narcotic"))
sf_sub$Category <- factor(sf_sub$Category)

# reduce Location to a table of frequencies
Data            <- dcast(sf_sub, Latitude + Longitude + Category ~ .)
colnames(Data)  <- c("Latitude", "Longitude", "Category", "Frequency")
 map_loc <- get_map(location = c(lon = mean(san$X), mean(san$Y)), source='google',zoom=14)

# create the chart for Location / Categories
g <- qmplot(Longitude, Latitude, data = Data, color = Category, size = I(1.5),
            source='google')
g <- g + scale_colour_brewer(type = "div")
g <- g + ggtitle(expression(atop("Where it is Happening", atop(italic("Location by Top Categories of Incidents (Summer 2014)"), ""))))
g 
 



