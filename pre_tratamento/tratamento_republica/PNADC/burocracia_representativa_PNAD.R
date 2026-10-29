library(PNADcIBGE)
library(tidyverse)

anos <- 2013:2025

vars_check <- c(
  "V2007",   # sexo
  "V2010",   # raça
  "VD4008",  # setor público
  "V4014",   # esfera
  "V4010",   # ocupação (liderança)
  "V403311"  # faixa salarial
)

resultado_vars <- map_df(anos, function(ano) {
  
  pnadc <- get_pnadc(year = ano, quarter = 1)
  
  tibble(
    ano = ano,
    V2007   = "V2007"   %in% names(pnadc),
    V2010   = "V2010"   %in% names(pnadc),
    VD4008  = "VD4008"  %in% names(pnadc),
    V4014   = "V4014"   %in% names(pnadc),
    V4010   = "V4010"   %in% names(pnadc),
    V403311 = "V403311" %in% names(pnadc)
  )
})

resultado_vars
