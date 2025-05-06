dd<-CO2

help(CO2) #METADATA

# Basic descriptive analysis

summary(dd)
str(CO2)
barplot(table(dd$Treatment))
boxplot(dd$conc)
hist(dd$conc)

table(dd[,2])

# Dades contained in the dataset

dades<-dd
K<-dim(dades)[2]
par(ask=TRUE)


# P must contain the categorical variable

P<-dd[,2]

nc<-length(levels(factor(P)))
nc
nameP<-names(dd)[2]
n<-dim(dades)[1]

for(k in 3:K){
  if (is.numeric(dades[,k])){ 
    print(paste("Analisi bivariant de la Variable:", names(dades)[k]))
    
    boxplot(dades[,k]~P, main=paste("Boxplot of", names(dades)[k], "vs", nameP ), horizontal=TRUE)
    
    barplot(tapply(dades[[k]], P, mean),main=paste("Means of", names(dades)[k], "by", nameP ))
    abline(h=mean(dades[[k]]))
    legend(0,mean(dades[[k]]),"global mean",bty="n")
    print("Estadistics per groups:")
    for(s in levels(as.factor(P))) {print(summary(dades[P==s,k]))}
    #o<-oneway.test(dades[,k]~P)
    #print(paste("p-valueANOVA:", o$p.value))
    kw<-kruskal.test(dades[,k]~P)
    print(paste("p-value Kruskal-Wallis:", kw$p.value))
    #pvalk[,k]<-ValorTestXnum(dades[,k], P)
    #print("p-values ValorsTest: ")
    #print(pvalk[,k])      
  }else{
    if(class(dd[,k])=="Date"){
      print(summary(dd[,k]))
      print(sd(dd[,k]))
      #decide breaks: weeks, months, quarters...
      hist(dd[,k],breaks="weeks")
    }else{
      #qualitatives
      print(paste("Variable", names(dades)[k]))
      table<-table(P,dades[,k])
      #   print("Cross-table")
      #   print(table)
      rowperc<-prop.table(table,1)
      
      colperc<-prop.table(table,2)
      
      dades[,k]<-as.factor(dades[,k])
      
      
      marg <- table(as.factor(P))/n
      print(append("Categories=",levels(as.factor(dades[,k]))))
      
      
      table<-table(dades[,k],P)
      print("Cross Table:")
      print(table)
      print("Distribucions condicionades a columnes:")
      print(colperc)
      
      #diagrames de barres apilades                                         
      
      paleta<-rainbow(length(levels(dades[,k])))
      barplot(table(dades[,k], as.factor(P)), beside=FALSE,col=paleta, main = paste("Multiple barplot of",names(dades)[k]))
      
      barplot(table(dades[,k], as.factor(P)), beside=FALSE,col=paleta, main = paste("Multiple barplot of",names(dades)[k]) )
      legend("topright",levels(as.factor(dades[,k])),pch=1,cex=0.5, col=paleta)
      
      #diagrames de barres adosades
      
      barplot(table(dades[,k], as.factor(P)), beside=TRUE,col=paleta, main = paste("Multiple barplot of",names(dades)[k]) )
      
      barplot(table(dades[,k], as.factor(P)), beside=TRUE,col=paleta, main = paste("Multiple barplot of",names(dades)[k]))
      legend("topright",levels(as.factor(dades[,k])),pch=1,cex=0.5, col=paleta)
      
      print("Test Chi quadrat: ")
      print(chisq.test(dades[,k], as.factor(P)))
      
      #calcular els pvalues de les quali
    }
  }
}#endfor


# KRUSKAL WALLACE TEST SAYS IF THE MEDIAN BETWEEN GROUPS IS EQUAL (H0) or NOT

# WE NEED TO CONVEY THE INFORMATION THE RIGHT WAY (GRAPHICAL OR NUMBERS)

