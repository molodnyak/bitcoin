#Cryptocurrency Data

###data download
download.file(file.path("http://api.bitcoincharts.com/v1/csv", "bitstampUSD.csv.gz"), 
              destfile = file.path("Bitcoincopy/dataset", "bitstampUSD.csv.gz"))
bitcoin <- read.csv(gzfile(file.path("Bitcoincopy/dataset", "bitstampUSD.csv.gz")), header=T)
names(bitcoin) <- c("date","price","amount")
bitcoin$date <- as.Date(as.POSIXct(bitcoin$date, origin="1970-01-01"))

###select last 365 values
bitcoin <- bitcoin[bitcoin$date >= Sys.Date()-365, ]
row.names(bitcoin) <- 1:nrow(bitcoin)

###calculate trade volume
bitcoin$volume <- round(bitcoin$price*bitcoin$amount, 3)

###aggregate by date
bitcoin <- aggregate(x = bitcoin[c("amount", "volume")], by=list(date=bitcoin$date), FUN=sum)

###calculate average weighted price
bitcoin$wprice <- bitcoin$volume/bitcoin$amount
View(bitcoin)

###create final time serie
library(forecast)
y <- ts(bitcoin$wprice, start=as.numeric(strsplit(as.character(min(bitcoin$date)), '-')[[1]]), frequency=365.25)