
library(tidyverse)
library(PNADcIBGE)
library(survey)

options(scipen = 999)

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



### Verificar quantidade que recebe supersalários


quantidade_total = svytotal(x=~V4028, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" ), na.rm=TRUE)


quantidade_total

quantidade_super = svytotal(x=~V4028, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" & VD4016>41650 ), na.rm=TRUE)


quantidade_super


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


### Estimando o custo de supersalários para os cofres públicos:ci
despesa_super = svytotal(x=~VD4016, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" & ( VD4016>41650) & V4028=="Sim" ), na.rm=TRUE)

despesa_094 = svytotal(x=~VD4016, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" & (VD4016>27000 & VD4016<41650) & V4028=="Sim" ), na.rm=TRUE)

despesa_04 = svytotal(x=~VD4016, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" & (VD4016>15000 & VD4016<27001) & V4028=="Sim" ), na.rm=TRUE)

despesa_05 = svytotal(x=~VD4016, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" & (VD4016>10000 & VD4016<15000) & V4028=="Sim" ), na.rm=TRUE)

despesa_20 = svytotal(x=~VD4016, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" & (VD4016>5000 & VD4016<10000) & V4028=="Sim" ), na.rm=TRUE)

despesa_70 = svytotal(x=~VD4016, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" & ( VD4016<5001) & V4028=="Sim" ), na.rm=TRUE)


despesa_super
despesa_094
despesa_04
despesa_05
despesa_20
despesa_70




