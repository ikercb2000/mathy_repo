###CCA 
### Please install these packages (listed in the library command) before starting 
### 
install.packages("GGally")
library(lme4)
library(CCA) #facilitates canonical correlation analysis
library(CCP)
require(ggplot2)
require(GGally)
###
###
### DATA
# Simulated data set on Job Performance. In the data set, there are 9 variables.
#The dependent data set contains three variables that each are alternative
# measurements of Job Performance:

#ClientSat: A satisfaction rating between 1 and 100 by your main client
#SuperSat: A rating on Job Performance between 1 and 100 by your superior
#ProjCompl: The percentage of your projects that was successfully delivered

#The independent data contains six variables, of which two variables are measurements
#of Social Skills:

#PsychTest1: score between 0 (bad) and 100 (good)
#PsychTest2: score between 0 (bad) and 100 (good)
#It also has two variables on Intellectual Skills:
#YrsEdu: Number of years of higher education followed
#IQ: Score on an IQ test
#And it has two variables on Motivation:
#HrsTrain: Number of hours spent on training
#HrsWrk: Average number of hours in a workweek

#The goal of this analysis is to apply a Canonical Correlation
#Analysis and see whether the three independent concepts
#are also identified by the model as Canonical Variables,
#or whether there are more interesting Canonical Variables to be defined.
#We’ll also check which original variables are found to impact Job Performance.

data <- read.csv('https://articledatas3.s3.eu-central-1.amazonaws.com/CanonicalCorrelationAnalysisData.csv')

#write.csv(data,"dataCCA.csv") 
head(data)
#Divide data into two groups 
X = data[,c('PsychTest1', 'PsychTest2', 'YrsEdu', 'IQ', 'HrsTrn', 'HrsWrk')]
Y = data[,c('ClientSat', 'SuperSat', 'ProjCompl')]

# Fit Canonical Correlation Analysis using built-in cancor function
model <- cancor(X,Y)
model$cor

###or
model2 <- cc(X,Y)
model2$cor
plt.cc(model2, type="v",var.label = TRUE)
### Getting knowledge:

#Project Completion is strongly related to the number of hours spent working
#and training
#SuperSat is also strongly related to the number of hours spent working and training
# Client Satisfaction is located quite elsewhere on the graph. It is down below,
# showing that it is covered by dimension 2 and closer to social skills variables.

###???? IQ and Years of Education????
##Check with dimension 3, so analysis should be done with (1,2) and (2,3)
plt.var(model2, 1, 3, var.label = TRUE)
plt.var(model2, 2, 3, var.label = TRUE)
plt.var(model2, 1, 3, int=0.10,var.label = TRUE)