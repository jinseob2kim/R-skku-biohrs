library(data.table);library(magrittr);library(ggpubr)
set.seed(222)

## T-test
data.t <- data.frame(sex = sample(c("Male", "Female"), 30, replace = T), tChol = round(rnorm(30, mean = 150, sd = 30)))
rownames(data.t) <- paste("person", 1:30)
data.t

nev.ttest <- t.test(tChol ~ sex, data = data.t, var.equal = F);nev.ttest
ev.ttest <- t.test(tChol ~ sex, data = data.t, var.equal = T);ev.ttest

ggarrange(
  ggboxplot(data.t, "sex", "tChol", fill = "sex"),
  ggbarplot(data.t, "sex", "tChol", fill = "sex", add = "mean_sd")
)

ggboxplot(data.t, "sex", "tChol", fill = "sex", add = "dotplot") + 
  stat_compare_means(method = "t.test", method.args = list(var.equal = F))


ggviolin(data.t, "sex", "tChol", fill = "sex", add = "boxplot") + 
  stat_compare_means(method = "t.test", method.args = list(var.equal = T), label.y = 250)


## Wilcox
res.wilcox <- wilcox.test(tChol ~ sex, data = data.t);res.wilcox

ggboxplot(data.t, "sex", "tChol", fill = "sex") + 
  stat_compare_means(method = "wilcox.test")



## ANOVA
data.aov <- data.frame(group = sample(c("A", "B", "C"), 30, replace = T), tChol = round(rnorm(30, mean = 150, sd = 30)))
rownames(data.aov) <- paste("person", 1:30)
data.aov

res.aov1 <- oneway.test(tChol ~ group, data = data.aov, var.equal = F);res.aov1
res.aov2 <- oneway.test(tChol ~ group, data = data.aov, var.equal = T);res.aov2

ggboxplot(data.aov, "group", "tChol", fill = "group", order = c("A", "B", "C")) + 
  stat_compare_means(method = "anova")


ggboxplot(data.aov, "group", "tChol", fill = "group", order = c("A", "B", "C")) + 
  stat_compare_means(method = "anova", label.y = 250) + 
  stat_compare_means(method = "t.test", comparisons = list(c("A", "B"), c("B", "C"), c("C", "A")))

## Kruskal test
res.kruskal <- kruskal.test(tChol ~ group, data = data.aov);res.kruskal

ggboxplot(data.aov, "group", "tChol", fill = "group", order = c("A", "B", "C")) + 
  stat_compare_means(method = "kruskal.test")


## Categorical: Chisq test
data.chi <- data.frame(HTN_medi = round(rbinom(50, 1, 0.4)), DM_medi = round(rbinom(50, 1, 0.4)))
rownames(data.chi) <- paste("person", 1:50)
data.chi

tb.chi <- table(data.chi);tb.chi
res.chi <- chisq.test(tb.chi);res.chi

## Fisher
data.fisher <- data.frame(HTN_medi = round(rbinom(50, 1, 0.2)), DM_medi = round(rbinom(50, 1, 0.2)))
rownames(data.fisher) <- paste("person", 1:50)

tb.fisher <- table(data.fisher);tb.fisher
chisq.test(tb.fisher)
res.fisher <- fisher.test(tb.fisher);res.fisher


## Paired test: continuous
data.pt <- data.frame(SBP_hand = round(rnorm(30, mean = 125, sd = 5)), SBP_machine = round(rnorm(30, mean = 125, sd = 5)))
rownames(data.pt) <- paste("person", 1:30)

pt.ttest <- t.test(data.pt$SBP_hand, data.pt$SBP_machine);pt.ttest
pt.ttest.pair <- t.test(data.pt$SBP_hand, data.pt$SBP_machine, paired = T);pt.ttest.pair

ggpaired(data.pt, cond1 = "SBP_hand", cond2 = "SBP_machine", fill = "condition", palette = "jco") + 
  stat_compare_means(method = "t.test", paired = T)

pt.wilcox.pair <- wilcox.test(data.pt$SBP_hand, data.pt$SBP_machine, paired = T);pt.wilcox.pair

ggpaired(data.pt, cond1 = "SBP_hand", cond2 = "SBP_machine", fill = "condition", palette = "jco") + 
  stat_compare_means(method = "wilcox.test", paired = T)


## Paired test: categorical
data.mc <- data.frame(Pain_before = round(rbinom(30, 1, 0.5)), Pain_after = round(rbinom(30, 1, 0.5)))
rownames(data.mc) <- paste("person", 1:30)

table.mc <- table(data.mc);table.mc
mc.chi <- chisq.test(table.mc);mc.chi
mc.mcnemar <- mcnemar.test(table.mc);mc.mcnemar


## Paired test: >= 3 category
#install.packages("rcompanion")
library(rcompanion)
data(AndersonRainGarden)  # Example data
AndersonRainGarden
nominalSymmetryTest(AndersonRainGarden)




