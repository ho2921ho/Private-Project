rm(list=ls());gc()

## data

setwd("C:/Users/renz/Documents/GitHub/Private-Project/4MAT 클러스터링")
test = read.csv("test.csv", header = T)
test = na.omit(test)

names(test)


rownames(test) = test[,"이름"]
test = test[,-1]

scale.test = scale(test[,-c(6,7)])
team = test$팀
sex = test$X
#---- 계층적 군집분석

# (1) Euclidean dist., complete <- default option

dist.E = dist(scale.test)
cluster.EC = hclust(dist.E) 
plot(cluster.EC, main="Euclidean, complete", cex=1)
rect.hclust(cluster.EC, k=4, border="red") 

# (2) Euclidean dist., average linkage

cluster.EA = hclust(dist.E, method="average")
plot(cluster.EA, main="Euclidean, average")
rect.hclust(cluster.EA, k=4, border="red") 

#--- 2-3. K-means 군집분석(p.73)


# K-means
library(cluster)
set.seed(1)
cluster.K4 = kmeans(scale.test, centers= 4, nstart = 50)
cluster.K4$cluster
table(cluster.K4$cluster)

#--- 다차원 척도법을 이용한 군집분석 시각화(p.81)
k1 = 4
cmds = cmdscale(dist.E, k = 2)

groups = cutree(cluster.EC, k=k1)
plot(cmds, xlab = "coord 1", ylab = "coord 2", main = "MDS-hclust", type = "n")
text(cmds, labels = rownames(cmds), cex=.8, col=groups)

plot(cmds, xlab = "coord 1", ylab = "coord 2", main = "MDS-kmeans", type = "n")
text(cmds, labels = rownames(cmds), cex=.8, col=cluster.K4$cluster)

plot(cmds, xlab = "coord 1", ylab = "coord 2", main = "MDS-team", type = "n")
text(cmds, labels = rownames(cmds), cex=.8, col=team)

plot(cmds, xlab = "coord 1", ylab = "coord 2", main = "MDS-team", type = "n")
text(cmds, labels = rownames(cmds), cex=.8, col=sex)
## k-means 

#--- PCA 를 이용한 군집분석 시각화(p.78)

pca <- princomp(scale.test, cor=T)

groups = cutree(cluster.EC, k=k1)
plot(pca$scores[,1:2], xlab = "coord 1", ylab = "coord 2", main = "PCA-hclust", type = "n")
text(pca$scores[,1:2], labels = rownames(pca$scores), cex=.8, col=groups)

plot(pca$scores[,1:2], xlab = "coord 1", ylab = "coord 2", main = "PCA-kmeans", type = "n")
text(pca$scores[,1:2], labels = rownames(pca$scores), cex=.8, col=cluster.K4$cluster)

plot(pca$scores[,1:2], xlab = "coord 1", ylab = "coord 2", main = "PCA-team", type = "n")
text(pca$scores[,1:2], labels = rownames(cmds), cex=.8, col=team)

## 군집 내 비교 (k-means)

groups = cluster.K4$cluster
for (i in 1:4){
  cat(i,'- th cluster \n')
  tmp = rbind(round(colMeans(test[,-6][which(groups==i),]), 3),
              round(diag(cov(test[,-6][which(groups==i),])), 3)); rownames(tmp) = c("Mean","Var")
  print(tmp)
}
table(groups)

