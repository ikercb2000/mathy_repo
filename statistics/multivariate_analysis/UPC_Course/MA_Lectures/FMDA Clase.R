###FAMD Factorial Analysis Mixed Data
####
library(factoextra)
library(FactoMineR)
###FAMD (base, ncp = 5, sup.var = NULL, ind.sup = NULL, graph = TRUE)

##base : a data frame with n rows (individuals) and p columns (variables).
##ncp: the number of dimensions kept in the results (by default 5)
##sup.var: a vector indicating the indexes of the supplementary variables.
##ind.sup: a vector indicating the indexes of the supplementary individuals.
##graph : a logical value. If TRUE a graph is displayed.
data(wine)
df <- wine[,c(1,2, 16, 22, 29, 28, 30,31)] 
head(df[,], 4)
summary(df)
# Max number of dimensions 6(num)+7(total levels)-2(categ)=11 dim
dim(wine)
#The goal of this study is to analyze the characteristics of the wines.
res.famd <- FAMD(df,ncp=Inf,graph = FALSE) # Here we put false not to obtain directly pca
print(res.famd)
summary(res.famd)
eig.val <- get_eigenvalue(res.famd)
eig.val # We keep just componentes when lambda >=1, as they get a great % of variance
fviz_screeplot(res.famd)
#An eigenvalue >1 indicates that the PD accounts for more variance
#than one of the original variables in standardized data (N.B. This holds true only when the data are standardized.)
#This is commonly used as a cutoff point for which PDs are retained to be used in further analysis.
#In case that these dimensions only accumulates a low percentage of the total inertia, then this suggests that the dataset
#is quite complex, potentially due to 1) the relationships between the variables being non-linear, and/or
#2) some factors (variables) that can account for variance in this dataset are not included in this analysis.

###Variables
var <- get_famd_var(res.famd)
var

#fviz_famd_var() to plot both quantitative and qualitative variables
#fviz_contrib() to visualize the contribution of variables to the principal dimensions

fviz_famd_var(res.famd, repel = TRUE)
# Shows the correlations with the variable and the dimension for each variable

fviz_contrib(res.famd, "var", axes = c(1:2))
fviz_contrib(res.famd, "var", axes = 1)
fviz_contrib(res.famd, "var", axes = 2)


#From the plots above, it can be seen that:

# variables that contribute the most to the first dimension are: Overall.quality and Harmony.

# variables that contribute the most to the second dimension are: Soil and Acidity.
quanti.var <- get_famd_var(res.famd, "quanti.var")
quanti.var 
fviz_famd_var(res.famd, "quanti.var", repel = TRUE,col.var = "black")
quali.var <- get_famd_var(res.famd, "quali.var")
quali.var 
fviz_famd_var(res.famd, "quali.var", repel=TRUE, col.var = "black")
##individuals
ind <- get_famd_ind(res.famd)
ind
# Dispersion and clouds in here show patterns to see whether 
plot(res.famd,habillage=2) # Soil seems to be a very important predictor
plot(res.famd,habillage=1) # This categorical feature hass different patterns for different individuals
fviz_famd_ind(res.famd)
fviz_famd_ind(res.famd,invisible = "quali.var",repel=TRUE)
fviz_ellipses(res.famd, c("Label", "Soil"), repel = TRUE)
summary(df$Label)
summary(df$Soil)
fviz_ellipses(res.famd, 1:2, geom = "point")
###ACTIVITY
### Check this real-life problem about Churn at https://rpubs.com/nchelaru/famd