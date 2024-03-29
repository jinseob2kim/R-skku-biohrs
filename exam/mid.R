####### Midterm ########

## data URL: 문제 1-3 모두 이 데이터를 이용합니다.
"https://raw.githubusercontent.com/jinseob2kim/R-skku-biohrs/main/data/example_g1e.csv"

## R코드와 실행결과를 모두 메일로 보내주십시오. (panthree@skku.edu, yumin.kim@zarathu.com)


## 데이터를 읽은 후
## Problem 1:  "Q_" 로 시작하는 변수는 범주형(factor)으로, 나머지 변수는 숫자로 만들어라.
library(data.table);library(magrittr);library(ggpubr)

a <- fread("https://raw.githubusercontent.com/jinseob2kim/R-skku-biohrs/main/data/example_g1e.csv")
var.factor <- grep("Q_", names(a), value = T)

for (v in var.factor){
  a[[v]] <- factor(a[[v]])
}

a[, (var.factor) := lapply(.SD, factor), .SD = var.factor]

sapply(a, class)


## Problem 2: RN_INDI, HME_YYYYMM 제외한 모든 연속변수의 연도별 평균과 표준편차를 구하라.
a[, .SD, .SDcols = -c("RN_INDI", "HME_YYYYMM", var.factor)][, lapply(.SD, sd, na.rm = T), keyby = "EXMD_BZ_YYYY"]



## Problem 3: 연도별 FBS의 Boxplot을 그리고 pptx로 저장하라.

dd <- ggboxplot(a, "EXMD_BZ_YYYY", "FBS")

plot_file <- read_pptx() %>%
  add_slide() %>% ph_with(dml(ggobj = dd), location=ph_location_type(type="body"))
print(plot_file, target = "plot_file.pptx")
