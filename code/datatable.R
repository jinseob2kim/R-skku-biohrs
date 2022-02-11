library(data.table);library(magrittr)

## Exam data: 09-15
df <- read.csv("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv")
dt <- fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv")
class(df);class(dt)

# fwrite(dt, "exam0915.csv")

# Only specific column
#dt <- fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv", select = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM"))
#dt <- fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv", select = 1:5)
#dt <- fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv", drop = 6:10)


## Row 
dt[1:10]    # or dt[1:10, ]
dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25)]
dt[order(HME_YYYYMM)]
dt[order(HME_YYYYMM, -HGHT)]
dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25)][order(HGHT)]        ## chain
dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25)] %>% .[order(HGHT)]  ## same


## Column
dt[, 1:10]
dt[, c("HGHT", "WGHT")]
dt[, .(HGHT, WGHT)]
dt[, .(Height = HGHT, Weight = WGHT)]   # rename

dt[, .(HGHT)] 
dt[, "HGHT"]
dt[, HGHT]   ## vector


colvars <- grep("Q_", names(dt), value = T)
dt[, ..colvars]
dt[, colvars, with = F]
dt[, .SD, .SDcols = colvars]
dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25), ..colvars]
dt[, !..colvars]
dt[, -..colvars]
dt[, .SD, .SDcols = -colvars]

## Column summary
dt[, .(mean(HGHT), mean(WGHT), mean(BMI))]
dt[, .(HGHT = mean(HGHT), WGHT = mean(WGHT), BMI = mean(BMI))]
dt[, lapply(.SD, mean), .SDcols = c("HGHT", "WGHT", "BMI")]

## By 
dt[, .(HGHT = mean(HGHT), WGHT = mean(WGHT), BMI = mean(BMI)), by = EXMD_BZ_YYYY]
dt[, .(HGHT = mean(HGHT), WGHT = mean(WGHT), BMI = mean(BMI)), by = "EXMD_BZ_YYYY"]
dt[, lapply(.SD, mean), .SDcols = c("HGHT", "WGHT", "BMI"), by = EXMD_BZ_YYYY]

dt[HGHT >= 175, .N, by= .(EXMD_BZ_YYYY, Q_SMK_YN)]        # .N: specical symbol
dt[HGHT >= 175, .N, by= c("EXMD_BZ_YYYY", "Q_SMK_YN")]

dt[HGHT >= 175, .N, keyby= c("EXMD_BZ_YYYY", "Q_SMK_YN")] ## Keyby: keep order

dt[HGHT >= 175, .N, keyby= .(EXMD_BZ_YYYY >= 2015, Q_PHX_DX_STK == 1)]
dt[HGHT >= 175, .N, keyby= .(get("EXMD_BZ_YYYY") >= 2015, get("Q_PHX_DX_STK") == 1)]
dt[HGHT >= 175, .N, keyby= .(Y2015 = ifelse(EXMD_BZ_YYYY >= 2015, ">=2015", "<2015"))]


## Merge example
dt1 <- dt[1:10, .SD, .SDcols = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM", colvars)]
dt2 <- dt[6:15, -..colvars]

merge(dt1, dt2, by = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM"), all = T)    # Full join
merge(dt1, dt2, by = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM"), all = F)    # Inner join
merge(dt1, dt2, by = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM"), all.x = T)  # left join
merge(dt1, dt2, by = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM"), all.y = T)  # right join

dt2[dt1, on = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM")]  # left join2
dt1[dt2, on = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM")]  # right join2

dt1[!dt2, on = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM")] # left anti join
dt2[!dt1, on = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM")] # right anti join


## New variable 
dt[, BMI2 := round(WGHT/(HGHT/100)^2, 1)]
dt[, `:=`(BP_SYS140 = factor(as.integer(BP_SYS >= 140)), BMI25 = factor(as.integer(BMI >= 25)))]
dt[, BMI2 := NULL]                                         # remove


## Specific symbol .N, .SD, .SDcols
dt[, .SD]   # all column
dt[, lapply(.SD, class)]
dt[order(EXMD_BZ_YYYY), .SD[1], keyby = "RN_INDI"]
dt[order(EXMD_BZ_YYYY), .SD[1], .SDcols = colvars, keyby = "RN_INDI"]
dt[, .N, keyby = "RN_INDI"]


## Melt(wide to long), dcast(long to wide)

dt.long1 <- melt(dt, 
                id.vars = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM"),  ## keep variable
                measure.vars = c("TOT_CHOL", "TG", "HDL", "LDL"),        ## wide to long variable
                variable.name = "Lipid",                               ## name
                value.name = "Value")

# Enhanced melt: multiple group
col1 <- c("BP_SYS", "BP_DIA")
col2 <- c("VA_LT", "VA_RT")
dt.long2 <- melt(dt,
                 id.vars = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM"),
                 measure = list(col1, col2),
                 value.name = c("BP", "VA"))

dt.long2[, variable := factor(variable, labels = c("SBP/VA_LT", 'DBP/VA_RT'))]


# dcast: long to wide
dt.wide1 <- dcast(dt.long1, EXMD_BZ_YYYY + RN_INDI + HME_YYYYMM ~ Lipid, value.var = "Value")

# aggregate
dt.wide2 <- dcast(dt.long1, RN_INDI ~ Lipid, value.var = "Value", fun.aggregate = mean, na.rm =T)

# Enhanced dcast
dt.wide3 <- dcast(dt.long2,... ~ variable, value.var = c("BP", "VA"))



