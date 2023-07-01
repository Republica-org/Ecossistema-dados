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


### Pegando os quartis para pirâmide ##Oficial

teste_quantil4 <- svyquantile(x=~VD4016, design=subset(dadosPNADc_22,((V4012=="Empregado do setor público (inclusive empresas de economia mista)" ) & (V4028=="Sim") & (VD4016>1199))),quantiles=0.99842, ci=FALSE, na.rm=TRUE)

teste_quantil4

## Vendo os supersalários. 
quantidade <- svytotal(x=~V4014, design=subset(dadosPNADc_22,((V4012=="Empregado do setor público (inclusive empresas de economia mista)" ) & (V4028=="Sim") & (VD4016>1199))), na.rm=TRUE)
quantidade_super <- svytotal(x=~V4014, design=subset(dadosPNADc_22,((V4012=="Empregado do setor público (inclusive empresas de economia mista)" ) & (V4028=="Sim") & (VD4016>41650))), na.rm=TRUE)


quantidade_super = data.frame(quantidade_super)
quantidade = data.frame(quantidade)

sum(quantidade_super$total)/sum(quantidade$total)*100


#Até 70%: 
#Até 5.000

#Até 90%:
#até 10.000

#Até 95%
#até 15000

# Até 99%
#27000

#Até 99,85%
#39200



### Verificar supersalarios
### Vendo os dados da pirâmide!! 
#quantidade total: 
6927827+1628540

quantidade = svytotal(x=~V4028, design=subset(dadosPNADc_22,V4012=="Empregado do setor público (inclusive empresas de economia mista)" ), na.rm=TRUE)


quantidade_estatutarios = svytotal(x=~V4012, design=subset(dadosPNADc_22,V4028=="Sim"), na.rm=TRUE)
quantidade_estatutarios_teto = svytotal(x=~V4012, design=subset(dadosPNADc_22,VD4016>39200 & V4028=="Sim"), na.rm=TRUE)

df = data.frame(quantidade)
view(df_estatutario)


df_total = data.frame(quantidade_com_militares)
df_estatutario = data.frame(quantidade_estatutarios)
df_quantidade_estatutarios_teto = data.frame(quantidade_estatutarios_teto)

view(df_estatutario)
view(quantidade_estatutarios_teto)

## 2022: 
#10708/6927827
#0,15%

