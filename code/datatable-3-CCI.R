## Calculate CCI: based previous records
library(parallel)

source("code/datatable-2-inclusion.R")
data.asd  ## Inclusion data

code.cci <- list(
  MI = c("I21", "I22", "I252"),
  CHF = c(paste0("I", c("099", 110, 130, 132, 255, 420, 425:429, 43, 50)), "P290"),
  Peripheral_VD = c(paste0("I", 70, 71, 731, 738, 739, 771, 790, 792), paste0("K", c(551, 558, 559)), "Z958", "Z959"),
  Cerebro_VD = c("G45", "G46", "H340", paste0("I", 60:69)),
  Dementia = c(paste0("F0", c(0:3, 51)), "G30", "G311"),
  Chronic_pulmonary_dz = c("I278", "I279", paste0("J", c(40:47, 60:67, 684, 701, 703))),
  Rheumatologic_dz = paste0("M", c("05", "06", 315, 32:34, 351, 353, 360)),
  Peptic_ulcer_dz = paste0("K", 25:28),
  Mild_liver_dz = c("B18", paste0("K", c(700:703, 709, 713:715, 717, 73, 74, 760, 762:764, 768, 769)), "Z944"),
  DM_no_complication = paste0("E", c(100, 101, 106, 108:111, 116, 118:121, 126, 128:131, 136, 138:141, 146, 148, 149)),
  DM_complication = paste0("E", c(102:105, 107, 112:115, 117, 122:125, 127, 132:135, 137, 142:145, 147)),
  Hemi_paraplegia = paste0("G", c("041", 114, 801, 802, 81, 82, 830:834, 839)),
  Renal_dz = c("I120", "I131", paste0("N", c("032", "033", "034", "035", "036", "037", "052", "053", "054", "055", "056", "057",
                                             18, 19, 250)), paste0("Z", c(490:492, 940, 992))),
  Malig_with_Leuk_lymphoma = paste0("C", c(paste0("0", 0:9), 10:26, 30:34, 37:41, 43, 45:58, 60:76, 81:85, 88, 90, 97)),
  Moderate_severe_liver_dz = c(paste0("I", c(85, 859, 864, 982)), paste0("K", c(704, 711, 721, 729, 765:767))),
  Metastatic_solid_tumor = paste0("C", 77:80),
  AIDS_HIV = paste0("B", c(20:22, 24))
)
cciscore <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 6, 6, 2)
names(cciscore) <- names(code.cci)



info.cci <- mclapply(names(code.cci), function(x){
  merge(data.asd[, .(RN_INDI, Indexdate)], 
        m40[like(MCEX_SICK_SYM, paste(code.cci[[x]], collapse = "|"))][order(MDCARE_STRT_DT), .SD[1], keyby = "RN_INDI"][, .(RN_INDI, inidate = MDCARE_STRT_DT)],
        by = "RN_INDI", all.x = T)[, ev := as.integer(Indexdate > as.Date(as.character(inidate), format = "%Y%m%d"))][, ev := ifelse(is.na(ev), 0, ev)][]$ev * cciscore[x]
}, mc.cores = 4) %>% do.call(cbind, .) %>% cbind(rowSums(.))
colnames(info.cci) <- c(paste0("Prev_", names(code.cci)), "CCI")

