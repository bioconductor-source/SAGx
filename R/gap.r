# Tibshirani, Walther and Hastie (2000) #
# Check added 02JUL04;correction to uniform sampling 15MAY06    #
# se added 10SEP06
gap<-function(data=swiss,class=g,B=500){
# data = swiss; class = cl$cluster; B = 100
library(stats)
if (min(table(class))==1) stop("Singleton clusters not allowed")
if(!(length(class)==nrow(data))) stop("Length of class vector differs from nrow of data") 
data <- as.matrix(data) 
data <- scale(data, center = TRUE, scale = FALSE)
temp1 <- log(sum(by(data,factor(class),intern <- function(x)sum(dist(x)/ncol(x))/2)))
veigen <- svd(data)$v
x1 <- crossprod(t(data),veigen) # project data to pc-dimensions #
z1 <- matrix(data = NA, nrow = nrow(x1), ncol = ncol(x1)) 
tots <- vector(length = B) 
for (k in 1:B){
   for (j in 1:ncol(x1)){
         min.x <- min(x1[,j]);max.x <- max(x1[,j])
         z1[,j] <- runif(nrow(x1), min = min.x, max = max.x) # x1[sample(1:nrow(x1),nrow(x1),replace=TRUE),j]
      }
z <- crossprod(t(z1),t(veigen))
tots[k] <- log(sum(by(crossprod(t(z),veigen),factor(class),intern <-
function(x) sum(dist(x)/ncol(x))/2)))
}
out <- c(mean(tots)-temp1, sqrt(1+1/B)*sd(tots));names(out) <- c("Gap statistic", "one SE of simulation")
return(out)
}

