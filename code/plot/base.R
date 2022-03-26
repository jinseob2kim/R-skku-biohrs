library(dplyr); library(ggplot2); library(ggpubr)

# Load data
data <- read.csv("https://raw.githubusercontent.com/jinseob2kim/R-skku-biohrs/main/data/example_g1e.csv")
head(data)

# Base package
## histogram
hist(data$HGHT, main="Distribution of height", xlab="height(cm)")

hist(data$HGHT, main="Distribution of height", xlab="height(cm)",
     breaks = 30, freq=F, col="grey", border="white")

## bar plot
table <- table(data$Q_SMK_YN)
print(table)
barplot(table, main="Distribution of smoking", names.arg=c("Never", "Ex-smoker", "Current"), ylab="frequency")

table2 <- table(data$Q_SMK_YN, data$EXMD_BZ_YYYY)
print(table2)
barplot(table2, main="Distribution of smoking by year", ylab="frequency",
        legend=c("Never", "Ex-smoker", "Current"))

barplot(table2, main="Distribution of smoking by year", ylab="frequency",
        legend=c("Never", "Ex-smoker", "Current"), beside=T)

## box plot
boxplot(BP_SYS ~ Q_SMK_YN, data = data, names=c("Never", "Ex-smoker", "Current"), 
        main="SBP average by smoking", ylab="SBP(mmHg)", xlab="Smoking")

## scatter plot
plot(HGHT ~ WGHT, data=data,
     ylab="Height(cm)", xlab="Weight(kg)",
     pch=16, cex=0.5)

data2 <- data %>% filter(EXMD_BZ_YYYY %in% c(2009, 2015))
plot(HGHT ~ WGHT, data=data2, col=factor(EXMD_BZ_YYYY),
     ylab="Height(cm)", xlab="Weight(kg)",
     pch=16, cex=0.5)
legend(x="bottomright", legend=c("2009", "2015"), col=1:2, pch = 19)

## line plot
table3 <- data %>% group_by(EXMD_BZ_YYYY) %>% 
  summarize(smoker= mean(Q_SMK_YN==3, na.rm=T))
print(table3)

plot(table3$EXMD_BZ_YYYY, table3$smoker, type="l",
     xlab="Year", ylab="prop of current smoker")
