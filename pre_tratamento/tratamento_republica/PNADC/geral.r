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


########### Super salários! 
### Pegando os quartis para pirâmide 


## Aqui eu pego o valor para cada corte

#Até 70%: 
corte_70<- svyquantile(x=~VD4016, design=subset(dadosPNADc_22,((V4012=="Empregado do setor público (inclusive empresas de economia mista)" ) & (V4028=="Sim") & (VD4016>1199))),quantiles=0.70, ci=FALSE, na.rm=TRUE)
corte_70
#Até 5.000

#Até 90%:
corte_90<- svyquantile(x=~VD4016, design=subset(dadosPNADc_22,((V4012=="Empregado do setor público (inclusive empresas de economia mista)" ) & (V4028=="Sim") & (VD4016>1199))),quantiles=0.90, ci=FALSE, na.rm=TRUE)
corte_90
# Até 10.000

#Até 95%
corte_95<- svyquantile(x=~VD4016, design=subset(dadosPNADc_22,((V4012=="Empregado do setor público (inclusive empresas de economia mista)" ) & (V4028=="Sim") & (VD4016>1199))),quantiles=0.95, ci=FALSE, na.rm=TRUE)

corte_95
# Até 15.000

# Até 99%
corte_99<- svyquantile(x=~VD4016, design=subset(dadosPNADc_22,((V4012=="Empregado do setor público (inclusive empresas de economia mista)" ) & (V4028=="Sim") & (VD4016>1199))),quantiles=0.99, ci=FALSE, na.rm=TRUE)

corte_99
#Até 27.000

#Até 99,94%

corte_9994<- svyquantile(x=~VD4016, design=subset(dadosPNADc_22,((V4012=="Empregado do setor público (inclusive empresas de economia mista)" ) & (V4028=="Sim") & (VD4016>1199))),quantiles=0.9994, ci=FALSE, na.rm=TRUE)

corte_9994
#Até 41.650,92


### Verificar quantidade que recebe supersalários


quantidade_total = svytotal(x=~V4028, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" ), na.rm=TRUE)
quantidade_total

quantidade_super = svytotal(x=~V4028, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" & VD4016>41650 ), na.rm=TRUE)
quantidade_super

#### Fazendo df com valores dos cortes e todos os decis: 



