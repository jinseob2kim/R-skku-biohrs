## Drug
library(data.table);library(magrittr)


data.include <- m20[MDCARE_STRT_DT >= 20060101][order(MDCARE_STRT_DT), .SD[1], keyby = "RN_INDI"][, .(RN_INDI, MDCARE_STRT_DT)]

code.drug <- list(
  Glucocorticoids = c("116401ATB", "140801ATB", "141901ATB", "141903ATB", "160201ATB", "170901ATB", "170906ATB", "193302ATB",
                      "193305ATB", "217034ASY", "217035ASY", "217001ATB", "243201ATB", "243202ATB", "243203ATB"),
  MTX = c("192101ATB", "192132BIJ", "192134BIJ", "192136BIJ", "192144BIJ"),
  LEFL = c("434601ATB", "434602ATB"),
  Cytoxan = c("139901ATB", "139005BIJ"),
  MMF = c("451401ATE", "451402ATB", "197830ASS", "197801ACH", "197802ATB"),
  Azathioprine = c("112401ATB", "112402ATB"),
  Tacrolimus = c("234201ACH", "234201ATB", "234203ACH", "234203ATB", "234204ACH", "234204ATB", "234205ACR", "234206ACR", "234207ACR", 
                 "234208ATB", "234230BIJ"),
  Cyclosporine = c("139201ACS", "139204ACS", "194730ALQ", "194701ACS", "194702ACS", "139230BIJ"),
  antiTNF = c("455830BIJ", "455831BIJ", "455803BIJ", "488431BIJ", "488433BIJ", "488430BIJ", "383501BIJ", "621230BIJ", "621231BIJ",
              "621232BIJ"),
  Tocilizumab = c("520433BJ", "520430BIJ", "520431BIJ", "520432BIJ"),
  Rituximab = c("422632BIJ", "422630BIJ", "422631BIJ", "422603BIJ"),
  Aspirin = c("110701ATB", "110702ATB", "111001ACE", "111001ATE", "489700ACR", "517900ACE", "517900ATE", "667500ACE"),
  Clopidogrel = c("136901ATB", "492501ATB", "495201ATB", "498801ATB", "501501ATB", "517900ACE", "517900ATE", "667500ACE")
)


prevmed <- mclapply(code.drug, function(x){
  merge(data.include,
        m60[GNL_NM_CD %in% x][order(MDCARE_STRT_DT), .SD[1], keyby = "RN_INDI"][, .(RN_INDI, inidate = MDCARE_STRT_DT)],
        by = "RN_INDI", all.x = T)[, ev := as.integer(as.integer(MDCARE_STRT_DT) > as.integer(inidate))][, ev := ifelse(is.na(ev), 0, ev)][]$ev
}, mc.cores = 4) %>% do.call(cbind, .)
colnames(prevmed) <- paste0("Prev_", names(code.drug))
