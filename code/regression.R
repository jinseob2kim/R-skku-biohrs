library(survival)

head(colon)

cor.test(colon$age, colon$time)

lm(time ~ age, data = colon) %>% summary %>% .$coefficients
lm(age ~ time, data = colon) %>% summary %>% .$coefficients

lm(time ~ sex, data = colon) %>% summary %>% .$coefficients
t.test(time ~ sex, data = colon, var.equal = T)

lm(status ~ rx, colon) %>% summary %>% .$coefficients


lm(time ~ rx, colon) %>% anova



library(jstable)
glm_gaussian <- glm(status ~ sex + age + rx, data = colon, family = binomial)
glmshow.display(glm_gaussian, decimal = 2)$table



glm(status ~ sex + age + rx, data = colon, family = binomial)
glm(status ~ age + rx, data = subset(colon, sex == 1), family = binomial)
glm(status ~ age + rx, data = subset(colon, sex == 0), family = binomial)

glm(status ~ sex*age + rx, data = colon, family = binomial)
