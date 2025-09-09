##' import data from the GitHub repository and produce appropriate subsets.
##' Import datasets loads the URLs to every dataset, but only downloads those presently used.
##' Subset datasets produces the subsets of the data used in the analysis.
##' @Dependencies this file is source by Stan.Wrapper, and the latter is sensitive to the variable names used in this file.

####Import datasets####
#Load the URLs to the raw csv datasets in the GitHub repository.
url.daily <- "https://raw.githubusercontent.com/JonathanClarke42/streamflow_jonkershoek/refs/heads/main/data/data_daily_2025-07-09.csv"
url.hourly <- "https://raw.githubusercontent.com/JonathanClarke42/streamflow_jonkershoek/refs/heads/main/data/data_hourly_2025-07-09.csv"
url.meta.daily <- "https://raw.githubusercontent.com/JonathanClarke42/streamflow_jonkershoek/refs/heads/main/data/metadata_daily_2025-07-09.csv"
url.meta.hourly <- "https://raw.githubusercontent.com/JonathanClarke42/streamflow_jonkershoek/refs/heads/main/data/metadata_hourly_2025-07-09.csv"

#import the datasets presently used in the analysis.
dat.daily_raw <- read.csv(url.daily)
meta.dat.daily <- read.csv(url.meta.daily)
#dat.hourly_raw <- read.csv(url.hourly)
#meta.dat.daily <- read.csv(url.meta.daily)
#meta.dat.hourly <- read.csv(url.meta.hourly)

####Subset datasets for the scope of the model####
##' ly == last year only.
##' fr == streamFLOW and RAINfall only.

dat.daily_ly.fr <- na.omit(dat.daily_raw[c(4474:4839),c(1,2,5)]) #note that this version of the model simply omits missing values.
c(4013:4368)#year 2023
c(4474:4839)#most recent 365 entires.
####Extract sample size, response, and predictor variables####
N <- length(dat.daily_ly.fr$Date)
streamflow <- dat.daily_ly.fr$Streamflow.Ave*86400*1000 #litres daily = seconds in a day * number of cumsecs * number of litres to a cubic meter.
rainfall <- dat.daily_ly.fr$Rainfall.Total*2460000 #litres of rainfall = rainfall (in millimeters) * catchment area size (in metres square).
                                                   #catchment area size of 2.46 Km^2 taken from Mokua, Glenday, and Mazvimavi (2024).
p <- rep(1,times = N)
