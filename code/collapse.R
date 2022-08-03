library(magrittr)
library(data.table) 
library(dplyr)
library(collapse)
library(microbenchmark)


## Exam data: 09-15
df <- read.csv("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv")
dt <- fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv")



## data.table(Only specific column)
dt <- fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv",select = c("EXMD_BZ_YYYY", "RN_INDI", "HME_YYYYMM"))
dt <- fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv", select = 1:5)
dt <- fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv", drop = 6:10)
## collapse(Only specific column)
dt <- fselect(fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv"),EXMD_BZ_YYYY, RN_INDI, HME_YYYYMM)
dt <- fselect(fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv"),1:5)
dt <- fselect(fread("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv"),-(6:10))



## data.table(row)
dt[1:10]                                                            
dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25)]
dt[order(HME_YYYYMM)]
dt[order(HME_YYYYMM, -HGHT)]
dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25)][order(HGHT)]        
dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25)] %>% .[order(HGHT)]  
## collapse(row)                                       # ss()함수는 컬럼명이 아닌 인덱스로 행,열을 출력을 할 때 사용 가능. fsubset() 보다 빠르지만 기능이 제한적임
fsubset(dt, 1:10)                                      # ss(dt,1:10)
fsubset(dt, EXMD_BZ_YYYY %in% 2009:2012 & BMI >= 25 )               
roworder(dt, HME_YYYYMM)                                            
roworder(dt, HME_YYYYMM, -HGHT)
roworder(dt, HGHT) %>% fsubset(EXMD_BZ_YYYY %in% 2009:2012 & BMI >= 25)
## benchmarking
microbenchmark(data.table = dt[1:10] ,
               collapse = fsubset(dt, 1:10))
microbenchmark(data.table = dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25)],
               collapse = fsubset(dt, EXMD_BZ_YYYY %in% 2009:2012 & BMI >= 25 ))
microbenchmark(data.table = dt[order(HME_YYYYMM, -HGHT)],
               collapse = roworder(dt, HME_YYYYMM, -HGHT))
microbenchmark(data.table = dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25)][order(HGHT)],
               collapse = roworder(dt, HGHT) %>% fsubset(EXMD_BZ_YYYY %in% 2009:2012 & BMI >= 25))




## data.table(column)
dt[, 1:10]
dt[, c("HGHT", "WGHT")]
dt[, .(HGHT, WGHT)]
dt[, .(Height = HGHT, Weight = WGHT)]   

dt[, .(HGHT)] 
dt[, "HGHT"]
dt[, HGHT]

colvars <- grep("Q_", names(dt), value = T)
dt[, ..colvars]
dt[, colvars, with = FALSE]
dt[, .SD, .SDcols = colvars]
dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25), ..colvars]
dt[, !..colvars]
dt[, -..colvars]
dt[, .SD, .SDcols = -colvars]
## collapse(column)               #get_var()는 fselect()함수와 유사하지만, 수행속도가 좀 더 빠르며 벡터, 정수 형태로 값을 전달
fselect(dt, 1:10)                 #get_vars(dt, 1:10)
fselect(dt, c("HGHT", "WGHT"))    #get_vars(dt, c("HGHT", "WGHT"))
fselect(dt, HGHT, WGHT) 
fselect(dt, Height = HGHT, Weight = WGHT)

fselect(dt, .(HGHT))              #ERROR
qM(dt$HGHT)                       #qM() converts matrix


colvars <-get_vars(dt, "Q_", regex = TRUE, return = "names")    #regex = TRUE 정규식 사용/ return = "names" 컬럼명 출력
fselect(dt, colvars)                                            #fselect(dt, c(colvars))
get_vars(dt, colvars)                                           #get_var(dt, c(colvars))
fsubset(dt,EXMD_BZ_YYYY %in% 2009:2012 & BMI >= 25, colvars)
fselect(dt, -(4:12))
fselect(dt, -(Q_PHX_DX_STK:Q_DRK_FRQ_V09N))

get_vars(dt, "HGHT")                                            #fselect()와 다르게 ""를 사용해야 에러없이 수행
## benchmarking
microbenchmark(data.table = dt[, 1:10],
               collapse = fselect(dt, 1:10))
microbenchmark(data.table = dt[, .(Height = HGHT, Weight = WGHT)],
               collapse = fselect(dt, Height = HGHT, Weight = WGHT))
microbenchmark(data.table = colvars <- grep("Q_", names(dt), value = T),
               collapse = colvars <-get_vars(dt, "Q_",regex = TRUE, return = "names")) #base::grep() more faster 
microbenchmark(data.table = dt[, ..colvars],
               collapse = get_vars(dt, colvars))
microbenchmark(data.table = dt[, ..colvars],
               collapse = fselect(dt, colvars) )
microbenchmark(data.table = dt[(EXMD_BZ_YYYY %in% 2009:2012) & (BMI >= 25), ..colvars],
               collapse = fsubset(dt,EXMD_BZ_YYYY %in% 2009:2012 & BMI >= 25, colvars))




## data.tanble(Column summary)
dt[, .(mean(HGHT), mean(WGHT), mean(BMI))]
dt[, .(HGHT = mean(HGHT), WGHT = mean(WGHT), BMI = mean(BMI))]
dt[, lapply(.SD, mean), .SDcols = c(13, 14, 16)]
#collapse(Column summary)
fselect(dt,HGHT,WGHT,BMI) %>% fmean()     #fmean(fselect(dt,HGHT,WGHT,BMI))
dapply(fselect(dt,HGHT,WGHT,BMI),fmean)
## benchmarking
microbenchmark(data.table = dt[, .(mean(HGHT), mean(WGHT), mean(BMI))],
               collapse = fmean(fselect(dt,HGHT,WGHT,BMI)))
microbenchmark(data.table = dt[, .(HGHT = mean(HGHT), WGHT = mean(WGHT), BMI = mean(BMI))],
               collaspe = fmean(fselect(dt,HGHT,WGHT,BMI)))
microbenchmark(data.table = dt[, lapply(.SD, mean), .SDcols = c(13, 14, 16)],
               collapse = dapply(fselect(dt,HGHT,WGHT,BMI),fmean))




##data.table(By)
dt[, .(HGHT = mean(HGHT), WGHT = mean(WGHT), BMI = mean(BMI)), by = EXMD_BZ_YYYY]
dt[, .(HGHT = mean(HGHT), WGHT = mean(WGHT), BMI = mean(BMI)), by = "EXMD_BZ_YYYY"]
dt[, lapply(.SD, mean), .SDcols = c("HGHT", "WGHT", "BMI"), by = EXMD_BZ_YYYY]

dt[HGHT >= 175, .N, by= .(EXMD_BZ_YYYY, Q_SMK_YN)]        
dt[HGHT >= 175, .N, by= c("EXMD_BZ_YYYY", "Q_SMK_YN")]
dt[HGHT >= 175, .N, keyby= c("EXMD_BZ_YYYY", "Q_SMK_YN")]
#collapse(By)                                                  #collap()는 'Fast Statistical Functions' 사용하여 각 열에 여러 함수를 적용
collap(dt, ~ EXMD_BZ_YYYY, fmean, cols = c(13,14,16))          # ~ ≒ by
fmean(fselect(dt,EXMD_BZ_YYYY,HGHT,WGHT,BMI), dt$EXMD_BZ_YYYY)

add_stub(count(fsubset(dt, HGHT >= 175, EXMD_BZ_YYYY,Q_SMK_YN),EXMD_BZ_YYYY,Q_SMK_YN),"N") #add_stub() 열을 추가할 수 있는 함수
## benchmarking
microbenchmark(data.table = dt[, .(HGHT = mean(HGHT), WGHT = mean(WGHT), BMI = mean(BMI)), by = EXMD_BZ_YYYY],
               collapse.collap = collap(dt, ~ EXMD_BZ_YYYY, fmean, cols = c(13,14,16)),
               collapse.fmean = fmean(fselect(dt,EXMD_BZ_YYYY,HGHT,WGHT,BMI), dt$EXMD_BZ_YYYY))  
microbenchmark(data.table = dt[, lapply(.SD, mean), .SDcols = c("HGHT", "WGHT", "BMI"), by = EXMD_BZ_YYYY],
               collapse = fmean(fselect(dt,EXMD_BZ_YYYY,HGHT,WGHT,BMI), dt$EXMD_BZ_YYYY))
microbenchmark(data.table = dt[HGHT >= 175, .N, by= .(EXMD_BZ_YYYY, Q_SMK_YN)],
               collapse = add_stub(count(fsubset(dt, HGHT >= 175, EXMD_BZ_YYYY,Q_SMK_YN),EXMD_BZ_YYYY,Q_SMK_YN),"N") ) #data.table more faster




  
## data.table(New variable)
dt[, BMI2 := round(WGHT/(HGHT/100)^2, 1)]
dt[, `:=`(BP_SYS140 = factor(as.integer(BP_SYS >= 140)), BMI25 = factor(as.integer(BMI >= 25)))]
dt[, BMI2 := NULL]
## collapse(New variable)
ftransform(dt, BMI2 = round(WGHT/(HGHT/100)^2, 1))
ftransform(dt,BP_SYS140 = factor(as.integer(BP_SYS >= 140)),BMI25 = factor(as.integer(BMI >= 25)))
ftransform(dt, BMI2 = NULL)



## data.table(Specific symbol .N, .SD, .SDcols)
dt[, .SD]   
dt[, lapply(.SD, class)]
dt[, .N, keyby = "RN_INDI"]
## collapse
fselect(dt,1:32)
dapply(dt,class)
add_stub(count(dt,RN_INDI),"N")                             #.N 유사한 Specific symbol이 없기 때문에 count() 사용
## benchmarking
microbenchmark(data.table = dt[, .SD],
               collapse = fselect(dt,1:32))
microbenchmark(data.table = dt[, lapply(.SD, class)],
               collapse = dapply(dt,class))
microbenchmark(data.table = dt[, .N, keyby = "RN_INDI"],
               collapse = add_stub(count(dt,RN_INDI),"N"))  #data.table more faster



#data.table(order)
dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY] [order(BMI)]
dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY] [order(-BMI)]
#collapse(order)
fmean(fselect(dt,EXMD_BZ_YYYY,HGHT,WGHT,BMI), dt$EXMD_BZ_YYYY) %>% roworder(BMI)
fmean(fselect(dt,EXMD_BZ_YYYY,HGHT,WGHT,BMI), dt$EXMD_BZ_YYYY) %>% roworder(-BMI)
## benchmarking
microbenchmark(data.table = dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY] [order(BMI)],
               collapse = fmean(fselect(dt,EXMD_BZ_YYYY,HGHT,WGHT,BMI), dt$EXMD_BZ_YYYY) %>% roworder(BMI))
microbenchmark(data.table = dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY] [order(-BMI)],
               collapse = fmean(fselect(dt,EXMD_BZ_YYYY,HGHT,WGHT,BMI), dt$EXMD_BZ_YYYY) %>% roworder(-BMI))



## Reference
#Fast Statistical Functions: fsum, fprod, fmean, fmedian, fmode, fvar, fsd, fmin, fmax, fnth, ffirst, flast, fnobs,fndistinct


