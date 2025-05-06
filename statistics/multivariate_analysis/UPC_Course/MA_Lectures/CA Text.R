############################
TEXTUAL DATA ANALYSIS WITH R (CA APPROACH)

########## LOAD FACTOMINER
#install.packages("FactoMineR") (use this line only if you do not have FactoMineR installed)
library(FactoMineR)

########## EXAMPLE 1: SURVEY (Definition of health)
data(health)
?health
health[1,] # Tres últimas columnas indican cosas del individuo (3 ultimas
# palabras que aparecen)

########## PERFORM CORRESPONDENCE ANALYSIS (CA)
?CA ###CA in Factominer Package
res.ca<-CA(health[,1:115],ncp=Inf,graph = FALSE)
res.ca

########## EIGENVALUES
res.ca$eig

########## RESPONDENTS
names(res.ca$row)
res.ca$row$coord
res.ca$row$cos2
res.ca$row$contr
res.ca$row$inertia

########## WORDS
names(res.ca$col)
res.ca$col$coord
res.ca$col$cos2
res.ca$col$contr
res.ca$col$inertia

########## WEIGHTS
names(res.ca$call)
res.ca$call$marge.row
res.ca$call$marge.col
res.ca$call$N
res.ca$call$ncp

########## SUMMARY
summary(res.ca)

########## HIGHER CONTRIBUTIONS OF THE FREQUENCIES
res.ca$col$contr[order(apply(res.ca$col$contr[,1:2],1,sum),decreasing=TRUE)[1:10],1:2]
res.ca$col$contr[order(apply(res.ca$col$contr[,3:4],1,sum),decreasing=TRUE)[1:10],3:4]

########## CA PLOTS
?plot.CA
plot.CA(res.ca,invisible="row")
plot.CA(res.ca,invisible="row",autoLab="yes")

plot.CA(res.ca,invisible="col")
plot.CA(res.ca,invisible="col",autoLab="yes")

#juntando ambos (columnas y filas) se puede ver una relación en el gráfico
plot.CA(res.ca, autolab="yes")

plot.CA(res.ca,invisible="row",axes=c(3,4),autoLab="yes")
plot.CA(res.ca,invisible="col",axes=c(3,4))

########## PERFORM CORRESPONDENCE ANALYSIS ON GENERALISED AGGREGATED LEXICAL TABLE (CA-GALT)
?CaGalt
res.cagalt<-CaGalt(Y=health[,1:115],X=health[,116:118],type="n") # Y = words, X = Categorical 
# + type = "n". It can also be numbers with letter "s"

res.cagalt # Mejor combinar textual data + categorical/numerical variables (es mucho 
# más útil para interpretar y reducir dimensiones)

########## EIGENVALUES
res.cagalt$eig

########## RESPONDENTS
names(res.cagalt$ind)
res.cagalt$ind$coord
res.cagalt$ind$cos2

########## WORDS
names(res.cagalt$freq)
res.cagalt$freq$coord
res.cagalt$freq$cos2
res.cagalt$freq$contr

########## QUALITATIVE VARIABLES
names(res.cagalt$quali.var)
res.cagalt$quali.var$coord
res.cagalt$quali.var$cos2

########## SUMMARY
summary(res.cagalt)

########## CA-GALT PLOTS
?plot.CaGalt
plot.CaGalt(res.cagalt,choix="freq",axes=c(1,2))
plot.CaGalt(res.cagalt,choix="freq",axes=c(1,2),select = "contrib 49") # Select just words until 49
plot.CaGalt(res.cagalt,choix="quali.var",axes=c(1,2))
plot(res.cagalt, choix = "quali.var", conf.ellip = TRUE, axes = c(1, 2))
plot(res.cagalt, choix = "freq", cex = 1.5, col.freq = "darkgreen",select = "contrib 10")
