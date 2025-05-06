#-----------------------------------------------------------------------#
#                          BANK NOTES EXERCISE                          #
#-----------------------------------------------------------------------#

# Load the data and obtain

SwissBanknotes <- read.csv("~/Downloads/SwissBanknotes.dat",sep="")
mean_vec <- colMeans(SwissBanknotes)
std_vec <- sqrt(diag(var(SwissBanknotes)))

print(SwissBanknotes)
print(mean_vec)
print(std_vec)

# 1st Exercise

SwissBanknotes1 <- data.frame(matrix(0,ncol=ncol(SwissBanknotes),
                                     nrow=nrow(SwissBanknotes)))

for (i in 1:ncol(SwissBanknotes)){
  SwissBanknotes1[,i] <- SwissBanknotes[,i]-mean_vec[i]
  colnames(SwissBanknotes1) <- colnames(SwissBanknotes)
  mean_vec1 <- colMeans(SwissBanknotes1)
  std_vec1 <- sqrt(diag(var(SwissBanknotes1)))
}

print(SwissBanknotes1)
print(mean_vec1)
print(std_vec1)

# 2nd Exercise

SwissBanknotes2 <- data.frame(matrix(0,ncol=ncol(SwissBanknotes),
                                     nrow=nrow(SwissBanknotes)))

for (i in 1:ncol(SwissBanknotes)){
  SwissBanknotes2[,i] <- (SwissBanknotes[,i]-mean_vec[i])/std_vec[i]
  colnames(SwissBanknotes2) <- colnames(SwissBanknotes)
  mean_vec2 <- colMeans(SwissBanknotes2)
  std_vec2 <- sqrt(diag(var(SwissBanknotes2)))
}

print(SwissBanknotes2)
print(mean_vec2)
print(std_vec2)

# 3rd Exercise

cov(SwissBanknotes)
cor(SwissBanknotes)
