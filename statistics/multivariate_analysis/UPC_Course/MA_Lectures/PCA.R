##### PCA ####################################
##### On many occasions, to study a phenomenon, a large number of variables are available, some of which are correlated with each other,
##### which complicates their analysis. In these situations, it is convenient to apply a method, such as the principal components method,
##### which allows reducing the number of variables without substantial loss of information, and ensuring that these new variables are uncorrelated,
##### thus avoiding redundant information.

##### DATABASE
##### In this case study we are going to reduce the number of economic-financial variables that describe a group of companies
##### dedicated to road transport, preserving as much information as possible. The starting point is the economic-financial information
##### for the year 2016 of 459 companies. For each company, data is available for the following variables:
#   Financial leverage: leverage (%)
#   capital: share capital (thousands of euros)
#   Earnings Before Interest Taxes Depreciation and Amortization: ebitda.sales (%)
#   employees: company workforce (people)
#   funds: own funds (thousands of euros)
#   income: operating income (thousands of euros)
#   reco: economic profitability (%)
#   rfin: financial return (%)
#   res.sales: result of the year on sales (%)
####### File is available as dataCompanies.csv

##### Importing the dataset in R
##### Please be sure that dataCompanies.csv is available in your current working directory or change your working directory in R at the same position where
##### dataCompanies.csv is located.
db<-read.csv("dataCompanies.csv",header=TRUE,sep=";",dec=".") ###depending in your computer setup, please use read.csv or read.csv2
##### give a check in your data 
dim(db) ###You should have a dataframe with 459 rows and 9 variables (numeric)
class(db)
str(db)
summary(db)
apply(X = db, MARGIN = 2, FUN = mean)
apply(X = db, MARGIN = 2, FUN = var) ##### Look at the high variance amongst features, so as it was studied, we need to scale our data for PCA.
##### Correlations, a quick view
Correlations <- cor(db)
print(Correlations)
corrplot::corrplot(Correlations) 
corrplot::corrplot(Correlations, method = "number",number.cex = 0.75) 

################### EXTRACTION of PCs#####################################
pca1<-princomp(db,cor=TRUE) 
names(pca1)   #####  "sdev"     "loadings" "center"   "scale"    "n.obs"    "scores"   "call"
#####
pca2 <- prcomp(db, scale = TRUE)
names(pca2) #####  "sdev"     "rotation" "center"   "scale"    "x"     
####
print(pca1)
print(pca2)
##################Look that results for pca1 and pca2 are the same
summary(pca1)
###Components as a linear combination of the variables
pca1$loadings[,1:9]
############################Pc1=Comp.1=0.0066Zleverage+0.4791⋅Zcapital+0.0621⋅ebitda.sales+...−0.0116Zrfin+0.0934Zres.ventas
#######
####Company scores on the components
head(pca1$scores)
dim(pca1$scores)
####Determination of the number of components to retain
eigenvalues <- pca1$sdev^2
eigenvalues ###Choose components with eigenvalue>>1 
####or use Scree plot
plot(pca1, type="lines", main = "Scree Plot")
abline(h=1, lty=3, col="red")
###or check % o acc.variance >>60-80%
#######INTERPRETATION of the COMPONENTS
Correl<- cor(db, pca1$scores)###see PCA tips.pdf
###or--- by using these function
####Coordinates
var_coord_func <- function(loadings, comp.sdev){
  loadings*comp.sdev
}
loadings <- pca1$loadings
sdev <- pca1$sdev
var.coord <- t(apply(loadings, 1, var_coord_func, sdev)) 
####or by using 
#### factoextra::get_pca_var(pca1)
## Principal Component Analysis Results for variables
##  ===================================================
##   Name       Description                                    
## 1 "$coord"   "Coordinates for the variables"                
## 2 "$cor"     "Correlations between variables and dimensions"
## 3 "$cos2"    "Cos2 for the variables"                       
## 4 "$contrib" "contributions of the variables"
### We are going to keep three PCAs
Coordinates3<-Correl[,1:3]
####Quality of variables into PCAs (cos^2)
Quality<-Correl^2
Quality<-Quality[,1:3]
corrplot::corrplot(factoextra::get_pca_var(pca1)$cos2[, 1:3], is.corr = F)
factoextra::fviz_pca_var(pca1, col.var = "cos2", 
                         gradient.cols = c("green", "orange", "red"),
                         repel = TRUE,
                         title = "Cos2 of the variables in PC 1-2")
factoextra::fviz_cos2(pca1, choice = "var", 
                      axes = 1:3, # axes recoge los componentes a utilizar
                      title = "Cos2 of the variables for PC 1 to 3") 
apply(factoextra::get_pca_var(pca1)$cos2[, 1:3], 1, sum)

####Calculation of contributions
###Contributions of variables for PCAs
Contrib<-Quality[,1]/eigenvalues[1] ### Here, contribution of variables in PC1, for other PCi, change 1 to "i" as a number.
###or
factoextra::get_pca_var(pca1)$contrib
###Contrib*100 equals to factoextra::get_pca_var(pca1)$contrib

####Description of the components
Coordinates3 ##or also by looking at the loadings of the PCs

#Component 1: The variables capital, employees, funds and income show correlations with component 1
#greater than 0.7, indicating that they are highly correlated with it.
#That is, the higher the value of these four variables in a company, the higher its score in this
# component. Given the nature of these variables, this component represents the size of the company.

#Component 2: The variables ebitda.sales, reco and res.sales show correlations greater than 0.85
## with component 2. This component could therefore represent the profitability of the company.
## The more profitable the company, the higher the score for the second component.

#Component 3: Finally, the variables leverage and rfin define component 3, which is related,
## in this way, to the company's indebtedness. The higher the leverage of a company and the lower
## the financial profitability, the higher the score it will achieve in the component,
## which will normally indicate a greater indebtedness of the company.

plot(Coordinates3[, 1], Coordinates3[, 2], pch = 20, 
     xlab = "Dim1", ylab = "Dim2",
     main = "Variables in PC 1 and 2") # 

text(Coordinates3[, 1], Coordinates3[, 2], 
     labels = row.names(Coordinates3),  # Labels of the variables
     cex= 0.8, pos = 4) 
###Final Biplot
fviz_pca_biplot(pca1, repel = TRUE,
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969"  # Individuals color
)

factoextra::fviz_pca_ind(pca1, axes = c(1, 2),
                         select.ind = list(cos2=250), # 250 best represented companies in PC1 &2 (They have the greatest value of cos2) 
                         title = "Companies with the highest cosine in dimensions 1-2") 


Individuals
Ind<- pca1$scores[ , 1:3]
plot(Ind)
factoextra::fviz_pca_ind(pca1, axes = c(1, 2), 
                         title = "Companies into Space Pc1 & Pc2") 