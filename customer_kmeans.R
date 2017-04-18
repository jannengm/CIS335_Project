# Run k-means with between 2 and n clusters
n <- 20
ans <- matrix(0,n-1,2)
for(i in 2:n){
  clst <- kmeans(na.omit(cust[,2:14]),i)
  ans[i-1,2] <- clst$tot.withinss
  ans[i-1,1] <- i
  }
plot(ans,type="l")

# Select a k value to use
k <- 5
clst <- kmeans(na.omit(cust[,2:14]),k)

# Display cluster centers
clst$centers