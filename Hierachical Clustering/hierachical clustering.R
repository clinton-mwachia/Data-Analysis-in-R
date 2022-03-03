# loading the libraries
library(cluster)
library(factoextra)

# loading the data and cleaning
data <- USArrests

# check for NA
colSums(is.na(data))

# scaling the data
data <- scale(data)

# Agglomerative Hierarchical Clustering
## euclidean Distance Matrix Computation
dmat <- dist(data)

# hclust
hclustering <- hclust(dmat)

# plotting
plot(hclustering)

# optimal number of clusters
fviz_nbclust(data, kmeans, method = "gap_stat")

