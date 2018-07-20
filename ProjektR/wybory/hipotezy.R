set.seed(42)
datasim     <- seq(0,1000,by=1)
y <- dbinom(datasim,1000,0.5)
y
plot(y)
plot(ecdf(y))

dbinom(1,3,0.5)
  
dbinom(2,9,1/13)

dbinom(2,5,0.07)
sum(sapply(seq(0,2,by=0.0001),function(x) dbinom(x,5,0.07)))

?pnorm
sum(sapply(seq(0,2,by=0.0001),function(x) dnorm(x,0,1)))

pnorm(-3,0,1)

set.seed(42)
plot(ecdf(rnorm(1000,2,0.5))) 
pnorm(2,2,0.5)
ecdf

empirical.cdf <- function(vector,x)
{
  return(ecdf(vector)(x))
}

X <- c(1, 11, 2, 3, 1, 3, 3, 1, 1, 1)
hist(X)
plot(density(log(X)))

install.packages("USArrests")
require(USArrests)
data("USArrests")
USArrests
View(USArrests)
plot(density(sqrt(USArrests$Murder)))
e1071::skewness(USArrests$Murder)
plot(density(sqrt(USArrests$Rape)))
e1071::skewness(USArrests$Rape)
plot(density(sqrt(USArrests$Assault)))
e1071::skewness(USArrests$Assault)

pres <- c(1.5,2.9,0.9,3.9,3.2,2.1)
pres_mean <- mean(pres)
pres_sd <- sd(pres)
emp_sd <- sqrt(sum((pres - pres_mean)^2) / 5)

error <- emp_sd / sqrt(6)


pres <- c(15.6, 16.2, 22.5,
          20.5, 16.4, 19.4 , 16.6, 17.9, 12.7, 13.9)
pres_mean <- mean(pres)
pres_sd <- sd(pres)
emp_sd <- sqrt(sum((pres - pres_mean)^2) / 9)

error <- emp_sd / sqrt(10)
(pres_mean - 16.5) / error
pnorm(-0.71) + pnorm(0.71, lower.tail = F)
