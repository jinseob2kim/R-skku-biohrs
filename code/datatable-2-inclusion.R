library(data.table);library(magrittr)
# Set core number when data.table
setDTthreads(0)  ## 0: All

## csv
inst <- fread("data/nsc2_inst_1000.csv")
bnc <- fread("data/nsc2_bnc_1000.csv") 

## Death date: last day in month
bnd <- fread("data/nsc2_bnd_1000.csv")[, Deathdate := (lubridate::ym(DTH_YYYYMM) %>% lubridate::ceiling_date(unit = "month") - 1)][]
m20 <- fread("data/nsc2_m20_1000.csv") 
m30 <- fread("data/nsc2_m30_1000.csv") 
m40 <- fread("data/nsc2_m40_1000.csv")[SICK_CLSF_TYPE %in% c(1, 2, NA)]            ## Exclude 3
m60 <- fread("data/nsc2_m60_1000.csv") 
g1e_0915 <- fread("data/nsc2_g1e_0915_1000.csv") 



## after 2006, New I10-15 (Hypertensive disease) in Main Sick
code.HTN <- paste(paste0("I", 10:15), collapse = "|")
data.start <- m20[like(SICK_SYM1, code.HTN) & (MDCARE_STRT_DT >= 20060101), .(Indexdate = min(MDCARE_STRT_DT)), keyby = "RN_INDI"]

## Previous disease: Among all sick code
excl <- m40[(MCEX_SICK_SYM %like% code.HTN) & (MDCARE_STRT_DT < 20060101), .SD[1], .SDcols = c("MDCARE_STRT_DT"), keyby = "RN_INDI"]

## Merge: left anti join
data.incl <- data.start[!excl, on = "RN_INDI"][, Indexdate := as.Date(as.character(Indexdate), format = "%Y%m%d")][]
#data.incl <- data.start[!(RN_INDI %in% excl$RN_INDI)]


## Add age, sex, death
data.asd <- merge(bnd, bnc[, .(SEX = SEX[1]), keyby = "RN_INDI"], by = "RN_INDI") %>% 
  merge(data.incl, by = "RN_INDI") %>% 
  .[, `:=`(Age = year(Indexdate) - as.integer(substr(BTH_YYYY, 1, 4)),
           Death = as.integer(!is.na(DTH_YYYYMM)),
           Day_FU = as.integer(pmin(as.Date("2015-12-31"), Deathdate, na.rm =T) - Indexdate))] %>% .[, -c("BTH_YYYY", "DTH_YYYYMM", "Deathdate")] 



