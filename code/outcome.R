## MI after indexdate

source("code/inclusion.R")
info.MI <- merge(data.asd[, .(RN_INDI, Indexdate)], 
                 m40[like(MCEX_SICK_SYM, paste(code.cci[["MI"]], collapse = "|"))][, .(RN_INDI, MIdate = MDCARE_STRT_DT)], by = "RN_INDI", all.x = T) %>% 
  .[Indexdate < as.Date(as.character(MIdate), format = "%Y%m%d")] %>% 
  .[order(MIdate), .(MI = 1, MIday = as.integer(as.Date(as.character(MIdate), format = "%Y%m%d") - Indexdate)[1]), keyby = "RN_INDI"]




data.final <- cbind(data.asd, info.cci, info.prevmed) %>% merge(info.MI, by = "RN_INDI", all.x = T) %>% .[, `:=`(MI = as.integer(!is.na(MI)),
                                                                                                                 MIday = pmin(Day_FU, MIday, na.rm = T))] %>% .[]


var.factor <- c("COD1", "COD2", "SEX", "Death", grep("Prev_", names(data.final), value = T), "MI")

data.final[, (var.factor) := lapply(.SD, factor), .SDcols = var.factor]
