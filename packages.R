list.of.packages <- c("forecast", "shiny", "shinydashboard")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, dependencies=TRUE)
library("forecast")
library("shiny")
library("shinydashboard")