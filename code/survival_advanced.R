library(survival);library(jskm)

## Example data
veteran 
sfit <- survfit(Surv(time, status) ~ trt, data = veteran)
summary(sfit, times = c(100, 200, 300, 365), extend = T)

## jskm
jskm(sfit)
jskm(sfit, ystrataname = "Treat", ystratalabs = c("Standard", "Test"), table = T, pval = T)
jskm(sfit, ystrataname = "Treat", ystratalabs = c("Standard", "Test"), table = T, pval = T, marks = F, cumhaz = T, surv.scale = "percent" )
jskm(sfit, ystrataname = "Treat", ystratalabs = c("Standard", "Test"), table = T, pval = T, marks = F, pval.coord = c(100, 0.1), legendposition = c(0.85, 0.6), linecols = "black")
jskm(sfit, ystrataname = "Treat", ystratalabs = c("Standard", "Test"), table = T, pval = T, marks = F, cut.landmark = 365) # Landmark analysis


## Best cutoff in km plot
library(maxstat)
mtest <- maxstat.test(Surv(time, status) ~ karno, data = veteran, smethod = "LogRank")
mtest
cut <- mtest$estimate  #40
veteran$karno_cat <- factor(as.integer(veteran$karno >= cut))

sfit2 <- survfit(Surv(time, status) ~ karno_cat, data = veteran)
jskm(sfit2, ystrataname = "Karno", ystratalabs = paste(c("<", "≥"), cut), table = T, pval = T)


## Proportional hazarad assumption
# log(t) vs log(-log(S(t)))
plot(sfit, fun="cloglog", lty=1:2, col=c("Black", "Grey50"), lwd=2, font.lab=2, main="Log-log KM curves by Treat", 
     ylab="log-log survival", xlab="Time (log scale)")
legend("bottomright",lty=1:2,legend=c("Standard", "Test"), bty="n", lwd=2, col=c("Black", "Grey50"))


plot(sfit, lty="dashed", col=c("Black", "Grey50"), lwd=2, font=2, font.lab=2, main="Observed Versus Expected Plots by Treat", 
     ylab="Survival probability", xlab="Time")
par(new = T)

# Observed vs expected
exp <- coxph(Surv(time, status) ~ trt, data = veteran)
new_df <- data.frame(trt = c(1, 2))
kmfit.exp <- survfit(exp, newdata = new_df)
plot(kmfit.exp, lty = "solid", col=c("Blue", "Red"), lwd=2, font.lab=2)

# Goodness of fit
cox.zph(exp)
plot(cox.zph(exp), var = "trt")
abline(h = 0, lty = 3)


## Compare model
exp$loglik
exp2 <- coxph(Surv(time, status) ~ trt + age, data = veteran)
exp3 <- coxph(Surv(time, status) ~ trt + age + celltype, data = veteran)
anova(exp, exp2, exp3)

step(exp3, scope = list(lower = ~ 1)) # stepwise selection



## Time dependent(1): Landmark analysis(time dependent coefficients)
# Survsplit
vet2 <- survSplit(Surv(time, status) ~ ., data = veteran, cut=c(90, 180), episode = "tgroup", id = "id")
vet2

# strata(tgroup)
vfit2 <- coxph(Surv(tstart, time, status) ~ trt + prior + karno:strata(tgroup), data=vet2)
summary(vfit2)


## Time dependent(2): time dependent covariates

# Simulated data
library(survsim)
N <- 100 # number of patients
set.seed(123)
df.tf <- simple.surv.sim(n=N, foltime=500, dist.ev=c('llogistic'), anc.ev=c(0.68), beta0.ev=c(5.8), anc.cens=1.2,
  beta0.cens=7.4, z=list(c("unif", 0.8, 1.2)), beta=list(c(-0.4),c(0)), x=list(c("bern", 0.5), c("normal", 70, 13)))

for (v in 4:7){
  df.tf[[v]] <- round(df.tf[[v]])
}
names(df.tf)[c(1,4,6,7)]<-c("id", "time", "grp","age")
df.tf <- df.tf[, -3]

df.tf


# Simulated data: time dependent covariates
nft <- sample(1:10, N, replace = T) #number of follow up time points
crp <- round(abs(rnorm(sum(nft)+N,
                     mean=0.5,sd=5)),1)
time <- id <- NA
i = 0
for(n in nft){
  i=i+1
  time.n<-sample(1:500,n)
  time.n<-c(0,sort(time.n))
  time<-c(time,time.n)
  id.n<-rep(i,n+1)
  id<-c(id,id.n)
}
df.td <- cbind(data.frame(id,time)[-1,],crp)
df.td


# Apply tmerge to data, to make tstart/tstop/status1
df <- tmerge(df.tf, df.tf, id = id, status1 = event(time, status))
df

# Make final data
df2 <- tmerge(df, df.td, id = id, crp = tdc(time, crp))
df2

# marginal cox model: cluster option
model.td <- coxph(Surv(tstart, tstop, status1) ~ grp + age + crp, data = df2, cluster = id)
summary(model.td)



## Parametric(Weibull) model
model.weibull <- survreg(Surv(time, status) ~ trt, data = veteran)
summary(model.weibull)
model.weibull$scale # scale parameter

pcut <- seq(0.01, 1, by = 0.01)  ## 1%-99%
ptime <- predict(model.weibull, newdata = data.frame(trt = 1), type = "quantile", p = pcut, se = T)
matplot(cbind(ptime$fit, ptime$fit + 1.96*ptime$se.fit, ptime$fit - 1.96*ptime$se.fit), 1 - pcut,
        xlab = "Days", ylab = "Survival", type = 'l', lty = c(1, 2, 2), col=1)

# compare to cox
model.cox <- exp
kmfit.exp <- survfit(exp, newdata = data.frame(trt = 1))
plot(kmfit.exp, lty = c(1, 2, 2), col=1, lwd=2, xlab = "Days", ylab = "Survival")
