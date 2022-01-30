## Calculate CCI: based previous records
library(haven);library(data.table);library(magrittr);library(parallel)
# Set core number when data.table
setDTthreads(0)  ## 0: All

m20 <- fread("data/nsc2_m20_1000.csv") 
m40 <- fread("data/nsc2_m40_1000.csv") 

code.cci <- list(
  MI = c("I12", "I22","I252"),                                            
  CHF = c("I099", "I110", "I130", "I132", "I255", "I420",                 
          paste0("I42",5,9), "I43", "I50", "P290"),
  PVD = c("I70", "I71", "I731", "I738", "I739",                          
          "I771", "I790", "I792", "K551", "K558", 
          "K559", "Z958", "Z959"),
  CD = c("G45", "G46", "H340", paste0("I",60:69)),                       
  DE = c(paste0("F0",1:3), "F051", "G30", "G311"),                        
  CPD = c("I278", "I279", paste0("J",c(40:47, 60:67)),                   
          "J684", "J701", "J703"),
  RD = c("M05","M06", "M315", paste0("M",32:34), "M351",                   
         "M353", "M360"),
  PUD = paste("K", 25:28),                                                   
  MLD = c("B18", paste0("K",700:703) , "K709", "K713", "K714",                
          "K715", "K717", paste0("K",730:749), "K760", "K762",
          "K763", "K764", "K768", "K769", "Z944"),
  DWOCC = c("E100", "E101", "E106", "E108",                                   
            "E109", "E110", "E111", "E116", 
            "E118", "E119", "E120", "E121", 
            "E126", "E128", "E129", "E130", 
            "E131", "E136", "E138", "E139", 
            "E140", "E141", "E146", "E148", 
            "E149"),
  DWCC = c(paste0("E",c(102:105, 112:115, 122:125, 132:135, 142:145)), "E107",                                           # 2점
           "E117",  "E127", "E137", "E147"),
  HOP = c("G041", "G114", "G801", "G802", "G81",                             # 2점 
          "G82", paste0("G",830:834), "G839"),
  AMILALEMNOS =                                                              # 2점
    c(paste0("C0",1:10), paste0("C",c(11:27, 30:34, 37:41, 43, 45:58, 60:76, 81:85, 88, 90:97))),
  MOSLD = c("I850", "I859", "I864", "I982", "K704",                          # 3점
            "K711", "K721", "K729", "K765", "K766", 
            "K767"),
  MST = paste0("C",77:80),                                                   # 6점
  AH = paste0("B",c(20:22, 24)),                                             # 6점
  Renal = c("N18", "N19", "I120", "I131", "N032", "N033", "N034", "N035", "N036", "N037", "N052", "N053", "N054", "N055", "N056", "N057", "N250",
            "Z490", "Z491", "Z492", "Z940", "Z992")                          # 2점
)
cciscore <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 6, 6, 2)
names(cciscore) <- names(code.cci)


data.include <- m20[, .(RN_INDI, MDCARE_STRT_DT)]

info.cci <- mclapply(names(code.cci), function(x){
  nc <- unique(nchar(code.cci[[x]]))
  zz <- lapply(nc, function(cc){
    m40[substr(MCEX_SICK_SYM, 1, cc) %in% code.cci[[x]][which(nchar(code.cci[[x]]) == cc)]]
  }) %>% rbindlist()
  
  merge(data.include[, .(RN_INDI, MDCARE_STRT_DT)], 
        zz[order(MDCARE_STRT_DT), .SD[1], keyby = "RN_INDI"][, .(RN_INDI, inidate = MDCARE_STRT_DT)],
        by = "RN_INDI", all.x = T)[, ev := as.integer(as.integer(MDCARE_STRT_DT) > as.integer(inidate))][, ev := ifelse(is.na(ev), 0, ev)][]$ev * cciscore[x]
}, mc.cores = 4) %>% do.call(cbind, .)
colnames(info.cci) <- names(code.cci)
