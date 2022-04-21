library(survey)
a <- haven::read_sav("data/hn20_all.sav")

## See variable label
names(a)
sapply(a, function(x){attr(x, "label")})

## For practice: some variable
a <- haven::read_sav("data/hn20_all.sav", col_select = c("year", "sex", "age", "allownc", "ainc", "marri_1", "edu", "EC1_1", 
                                                        "HE_sbp", "HE_dbp", "HE_glu", "HE_HCHOL", "HE_BMI", "psu", "kstrata", "wt_itvex", "wt_tot"))
                     
sapply(a, function(x){attr(x, "label")})


var.factor <- c("sex", "edu", "allownc", "marri_1", "EC1_1", "HE_HCHOL")
for (v in var.factor){
  a[[v]] <- factor(a[[v]])
}

## survey object
data.design <- svydesign(ids = ~psu, strata = ~kstrata, weights = ~wt_itvex, data = a)  ## Error: missing in weights
data.design <- svydesign(ids = ~psu, strata = ~kstrata, weights = ~wt_itvex, data = filter(a, !is.na(wt_itvex)))

## Table 1
library(jstable)
CreateTableOneJS(vars = setdiff(names(a), c("year", "kstrata", "psu", "wt_itvex", "wt_tot")), strata = "sex", data = a)
svyCreateTableOneJS(vars = setdiff(names(a), c("year", "kstrata", "psu", "wt_itvex", "wt_tot")), strata = "sex", data = data.design)



## Regression
reg1 <- glm(HE_glu ~ age + sex + HE_BMI +  edu + marri_1, data = a)
glmshow.display(reg1)
reg2 <- svyglm(HE_glu ~ age + sex + HE_BMI + edu + marri_1, design = data.design)
svyregress.display(reg2)

## Logistic
reg1 <- glm(HE_HCHOL ~ age + sex + HE_BMI +  edu + marri_1, data = a, family = binomial)
glmshow.display(reg1)
reg2 <- svyglm(HE_HCHOL ~ age + sex + HE_BMI + edu + marri_1, design = data.design, family = quasibinomial())
svyregress.display(reg2)



