library(haven);library(data.table);library(magrittr)
# Set core number when data.table
setDTthreads(0)  ## 0: All

## Drug code
code.ppi <-  c("367201ACH", "367201ATB", "367201ATD", "367202ACH", "367202ATB", 
               "367202ATD", "498001ACH", "498002ACH", "509901ACH", "509902ACH", 
               "670700ATB", "204401ACE", "204401ATE", "204402ATE", "204403ATE", 
               "664500ATB", "640200ATB", "664500ATB", "208801ATE", "208802ATE", 
               "656701ATE", "519201ATE", "519202ATE", "656701ATE", "519203ATE", 
               "222201ATE", "222202ATE", "222203ATE", "181301ACE", "181301ATD", 
               "181302ACE", "181302ATD", "181302ATE", "621901ACR", "621902ACR", 
               "505501ATE")


## drug user: select max TOT_MCNT among RK_KEY
m60.drug <- m60[GNL_NM_CD %in% code.ppi][order(MDCARE_STRT_DT, TOT_MCNT), .SD[.N], keyby = "RN_KEY"] 


## Change to date
m60.drug[, MDCARE_STRT_DT := lubridate::ymd(MDCARE_STRT_DT)]
#m60.drug[, MDCARE_STRT_DT := as.Date(MDCARE_STRT_DT, format = "%Y%m%d")]

## Function- duration: Drug duration, Gap: gap
dur_conti <- function(indi, duration = 180, gap = 30){
  data.ind <- m60.drug[RN_INDI == indi, .(start = MDCARE_STRT_DT, TOT_MCNT)]
  
  ## Drug date list
  datelist <- lapply(1:nrow(data.ind), function(x){data.ind[x, seq(start, start + TOT_MCNT, by = 1)]}) %>% 
    do.call(c, .) %>% unique %>% sort
  df <- diff(datelist)
  ## Gap change
  df[df <= gap] <- 1
  
  ## New datelist
  datelist2 <- datelist[1] + c(0, cumsum(as.integer(df)))
  
  ## Conti duration 
  res <- data.table(RN_INDI = indi, 
                    start = datelist, 
                    dur_conti = sapply(seq_along(datelist2), function(v){
                      zz <- datelist2[v:length(datelist2)]
                      return(ifelse(any(diff(zz) > 1), which(diff(zz) > 1)[1] - 1, length(zz) - 1))
                    }))
  return(res[dur_conti >= duration][1])
}

## Result: Use multicore
parallel::mclapply(unique(m60.drug$RN_INDI), dur_conti, duration = 180, mc.cores = 4) %>% rbindlist() %>% .[!is.na(RN_INDI)]
