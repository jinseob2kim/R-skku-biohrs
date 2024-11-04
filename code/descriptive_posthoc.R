library(data.table);library(magrittr);library(ggpubr)
set.seed(222)


data.aov <- data.frame(group = sample(c("A", "B", "C"), 30, replace = T), tChol = round(rnorm(30, mean = 150, sd = 30)))
rownames(data.aov) <- paste("person", 1:30)
data.aov

res.aov1 <- oneway.test(tChol ~ group, data = data.aov, var.equal = F);res.aov1
res.aov2 <- oneway.test(tChol ~ group, data = data.aov, var.equal = T);res.aov2


## TukeyHSD
res.aov2 <- aov(tChol ~ group, data = data.aov)
TukeyHSD(res.aov2)

library(DescTools)

##  "hsd", "bonferroni", "lsd", "scheffe", "newmankeuls", "duncan"
PostHocTest(res.aov2, method = "scheffe")
