## LOWESS in ggplot 
library(ggplot2)
library(survival)   ## for colon data

dd <- lapply(seq(0.1, 0.8, by = 0.2), function(span){
  ggplot(colon, aes(age, nodes)) + geom_point() + geom_smooth(method  = "loess", span = span) + ggtitle(paste0("Span =", span))
})

cowplot::plot_grid(plotlist = dd, nrow = 2)


## Cubic spline in R
library(splines)
cs1 <- glm(time ~ bs(age, knots = c(40, 50, 60, 70)) + sex, data = colon)
cs2 <- glm(time ~ bs(age, df = 4) + sex, data = colon)
ns1 <- glm(time ~ ns(age, knots = c(40, 50, 60, 70)) + sex, data = colon)
ns2 <- glm(time ~ ns(age, df = 4) + sex, data = colon)

age.grid <- seq(min(colon$age), max(colon$age), by = 1)
with(colon, plot(age,time,col="grey",xlab="Age",ylab="Time"))
points(age.grid, predict(cs1, newdata = data.frame(age=age.grid, sex = 1)), col=1, lwd=1, type="l")
points(age.grid, predict(cs2, newdata = data.frame(age=age.grid, sex = 1)), col=2, lwd=2, type="l")
points(age.grid, predict(ns1, newdata = data.frame(age=age.grid, sex = 1)), col=3, lwd=3, type="l")
points(age.grid, predict(ns2, newdata = data.frame(age=age.grid, sex = 1)), col=4, lwd=4, type="l")
# adding cutpoints
abline(v = c(40, 50, 60, 70), lty=2, col="black")
legend("topleft", c("cs:knots" ,"cs:df", "ns:knots", "ns:df"), col = 1:4, lwd = 1:4)


## Show gam result
library(mgcv)
m1 <- gam(time ~ s(age) + sex, data = colon)
summary(m1)
# Lambda
m1$sp
#m1 <- gam(time ~ s(age, sp = 0.04120719) + sex, data = colon)
plot(m1, shade = T)   ## plot(m1, select = 1)


## Basis function
model_matrix <- predict(m1, type = "lpmatrix", newdata = data.frame(age = sort(colon$age), sex = 1))
round(model_matrix, 2)
matplot(sort(colon$age), model_matrix[,-c(1:2)], type = "l", lty = 1, xlab = "Age", ylab = "Basis function")

## Compare plot
coef(m1)
par(mfrow = c(1, 2))
plot(sort(colon$age), model_matrix[,-c(1:2)] %*% coef(m1)[-c(1:2)], type = "l")
plot(m1, shade = T, se = F)   ## plot(m1, select = 1)

## Change basis to "cr"
m2 <- gam(time ~ s(age, bs = "cr") + sex, data = colon)
model_matrix2 <- predict(m2, type = "lpmatrix", newdata = data.frame(age = sort(colon$age), sex = 1))
matplot(sort(colon$age), model_matrix2[,-c(1:2)], type = "l", lty = 1, xlab = "Age", ylab = "Basis function")

## Restricted df
m3 <- gam(time ~ s(age, bs = "cr", k = 6) + sex, data = colon)
model_matrix3 <- predict(m3, type = "lpmatrix", newdata = data.frame(age = sort(colon$age), sex = 1))
matplot(sort(colon$age), model_matrix3[,-c(1:2)], type = "l", lty = 1, xlab = "Age", ylab = "Basis function")

## Fix lambda
m4 <- gam(time ~ s(age, sp = 1000) + sex, data = colon)
plot(m4)


## Other distribution
m5 <- gam(status ~ s(age) + sex, data = colon, family = binomial)
zz <- plot(m5, ylab = "Log Odds")
plot(m5, trans = exp, ylab = "Odds Ratio", shade = T, shift = -min(zz[[1]]$fit))
abline(h = 1, lty = 3)


m6 <-  gam(time ~ s(age) + sex + s(nodes), family=cox.ph, data= colon, weights = status)
zz <- plot(m6, select = 1, ylab = "Log Hazard")
plot(m6, select = 1, trans = exp, ylab = "Hazard Ratio", shade = T, shift = -min(zz[[1]]$fit))
abline(h = 1, lty = 3)


mort <- read.csv("https://raw.githubusercontent.com/jinseob2kim/R-skku-biohrs/main/docs/gam/mort.csv")
m7 <- gam(nonacc ~ s(meanpm10) + s(meantemp), data = mort, family = poisson)
zz <- plot(m7, select = 1, ylab = "Log RR")
plot(m7, select = 1, trans = exp, ylab = "Risk Ratio", shade = T, shift = -min(zz[[1]]$fit))
abline(h = 1, lty = 3)

## Quasi-poisson
c(mean(mort$nonacc), var(mort$nonacc))
m7$scale.estimated

m8 <- gam(nonacc ~ s(meanpm10) + s(meantemp), data = mort, family = quasipoisson)
zz <- plot(m8, select = 1, ylab = "Log RR")
plot(m8, select = 1, trans = exp, ylab = "Risk Ratio", shade = T, shift = -min(zz[[1]]$fit))
abline(h = 1, lty = 3)




