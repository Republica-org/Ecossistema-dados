library(tidyverse)
library(PNADcIBGE)
library(survey)


setwd("G:\\Drives compartilhados\\República.org\\4. Equipes\\Dados e Comunicação\\DADOS\\460 - Infográficos\\07 - Mulheres no serviço público\\Pasta local\\pnadc_mulheres_servidoras")

## Variáveis escolhidas:

#"V2007" = sexo
#"V2010" = cor/raça
#"V4010" = Codigo da ocupação
#"V4012" = setor
#"V4014" = Nível 
#"V4028" = Nesse trabalho, ... era servidor público estatutário (federal, estadual ou municipal) ?
# VD4016 = remuneracao
#VD4010



vars = c("V2007", "V2010", "V4028", "V4014", "V4012","V4010","VD4016", "VD4010")


dadosPNADc_22 <- get_pnadc(year=2022, quarter=3, vars=vars)
dadosPNADc_21 <- get_pnadc(year=2021, quarter=3, vars=vars)
dadosPNADc_20 <- get_pnadc(year=2020, quarter=3, vars=vars)
dadosPNADc_19 <- get_pnadc(year=2019, quarter=3, vars=vars)
dadosPNADc_18 <- get_pnadc(year=2018, quarter=3, vars=vars)
dadosPNADc_17 <- get_pnadc(year=2017, quarter=3, vars=vars)

dadosPNADc_16 <- get_pnadc(year=2016, quarter=3, vars=vars)
dadosPNADc_15 <- get_pnadc(year=2015, quarter=3, vars=vars)
dadosPNADc_14 <- get_pnadc(year=2014, quarter=3, vars=vars)
dadosPNADc_13 <- get_pnadc(year=2013, quarter=3, vars=vars)


save(dadosPNADc_22,
     dadosPNADc_21,
     dadosPNADc_20,
     dadosPNADc_19,
     dadosPNADc_18,
     dadosPNADc_17,
     dadosPNADc_16 ,
     dadosPNADc_15,~
     dadosPNADc_14 ,
    dadosPNADc_13 , file = "G:\\Drives compartilhados\\República.org\\4. Equipes\\Dados e Comunicação\\DADOS\\415 - Repositório de Dados\\Repositório Local\\IBGEarquivos_pnad.RData")


dadosPNADc_22$variables <- transform(dadosPNADc_22$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_21$variables <- transform(dadosPNADc_21$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_20$variables <- transform(dadosPNADc_20$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_19$variables <- transform(dadosPNADc_19$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_18$variables <- transform(dadosPNADc_18$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_17$variables <- transform(dadosPNADc_17$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_16$variables <- transform(dadosPNADc_16$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_15$variables <- transform(dadosPNADc_15$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_14$variables <- transform(dadosPNADc_14$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))
dadosPNADc_13$variables <- transform(dadosPNADc_13$variables, flag_lideranca=ifelse(V4010 >= '1111' & V4010 <= '1439',1,0))





df_servidor_22 = svytotal(x=~interaction(V2007,V2010, V4028,V4014,flag_lideranca), design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" | V4012== "Militar do exército, da marinha, da aeronáutica, da polícia militar ou do corpo de bombeiros militar" ), na.rm=TRUE)


df= data.frame(df_servidor_22)
view(df_servidor_22)

df = rownames_to_column(df, "row_names") # nolint
view(df)
sum(df$total)


df[1,1]