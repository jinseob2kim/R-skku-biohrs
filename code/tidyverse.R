a <- read.csv("https://raw.githubusercontent.com/jinseob2kim/R-skku-biohrs/main/data/smc_example1.csv")
library(magrittr)

a %>% head
head(a)


a %>% head(10)

10 %>% head(a, .)



subset(a, Sex == "M")
a %>% subset(Sex == "M")

a$Sex
a[["Sex"]]
a[, "Sex"]

a %>% .$Sex
a %>% .[["Sex"]]
a %>% .[, "Sex"]

head(subset(a, Sex == "M"))

b <- subset(a, Sex == "M")
head(b)


a %>% 
  subset(Sex == "M") %>% 
  head


b <- subset(a, Sex == "M")
model <- glm(DM ~ Age + Weight + BMI, data = b, family = binomial)
summ.model <- summary(model)
summ.model$coefficients

a %>% 
  subset(Sex == "M") %>% 
  glm(DM ~ Age + Weight + BMI, data = ., family = binomial) %>% 
  summary %>% 
  .$coefficients



b <- subset(a, Age >= 50) 
aggregate(. ~ Sex + Smoking, data = b, 
          FUN = function(x){c(mean = mean(x), sd = sd(x))})

a %>% 
  subset(Age >= 50) %>% 
  aggregate(. ~ Sex + Smoking, data = ., 
            FUN = function(x){c(mean = mean(x), sd = sd(x))})




library(dplyr)                                  ## 따로 magrittr 불러올 필요 없음.
a %>% 
  filter(Age >= 50) %>%
  select(-STRESS_EXIST) %>%       ## 범주형 변수 제외
  group_by(Sex, Smoking) %>% 
  summarize_all(list(mean = mean, sd = sd))


a[order(a$Age), ]

arrange(a, Age, Sex)

arrange(a, "Age", "Sex")


a[, c("Age", "Sex", "Height")]

select(a, Age, Sex, Height)

select(a, Sex:Height)

a %>% filter(Sex == "M") %>% select(Sex:HTN) %>% arrange(Age)


a$old <- as.integer(a$Age >= 65) 
a$overweight <- as.integer(a$BMI >= 27)

a %>% transmute(Old = as.integer(Age >= 65), Overweight = as.integer(BMI >= 27))

zz <- a %>% 
  group_by(Sex, Smoking) %>% 
  summarize_all(funs(mean = mean, sd = sd))
