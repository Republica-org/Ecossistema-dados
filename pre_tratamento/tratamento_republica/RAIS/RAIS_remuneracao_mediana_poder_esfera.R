
# 1. SET UP -----------------------------------------------------------------------
gc()
rm(list=ls())

# Pacotes

library(tidyverse)
library(readxl) 
library(writexl)

# Query usada no big query pra baixar os dados brutos --------------------------------
# WITH tabela_1 AS (
#   SELECT nome,nome_regiao, b.* FROM
#   `basedosdados.br_bd_diretorios_brasil.municipio`  AS a
#   RIGHT JOIN `basedosdados.br_me_rais.microdados_vinculos` AS b 
#   ON a.id_municipio = b.id_municipio )
# 
# SELECT 
# 
# ano, 
# sigla_uf,
# nome AS nome_municipio,  
# id_municipio,
# nome_regiao,
# valor_remuneracao_media,
# 
# 
# -- códigos da natureza jurídica: 
#   --https://concla.ibge.gov.br/estrutura/natjur-estrutura/natureza-juridica-2021.html
# CASE 
# WHEN natureza_juridica IN ('1015','1023', '1031','1104','1139','1112', '1147','1236','1120', '1155','1180','1341') THEN 'Executivo'-- aqui será adicionada autarquias e fundações de direito público. 
# WHEN natureza_juridica IN ('1040','1058', '1066') THEN 'Legislativo'
# WHEN natureza_juridica IN ('1074','1082') THEN 'Judiciário'
# ELSE 'Outros' 
# END AS poderes,
# 
# CASE 
# WHEN natureza_juridica IN ('1015','1040', '1074', '1104','1139', '1163', '1252', '1287', '1317', '1341') THEN 'Federal'
# WHEN natureza_juridica IN ('1023','1058', '1082', '1112', '1147', '1171', '1236','1260',  '1295', '1325') THEN 'Estadual'
# WHEN natureza_juridica IN ('1031','1066', '1120', '1155', '1180', '1244', '1279', '1309', '1333') THEN 'Municipal'
# ELSE 'Outros' 
# END AS esfera,
# 
# 
# 
# FROM tabela_1
# WHERE (natureza_juridica LIKE "1%" 
#        OR natureza_juridica IN ('2011', '2038'))
# AND natureza_juridica != '1228'
# AND cbo_2002 NOT LIKE "0%" 
# AND vinculo_ativo_3112= '1'
# AND ano = 2022



# 2. Abrir dados ----------------------------------------------------------------------

dados <- read.csv("Z:/Temp/Helena/pnad/bq-results-20240823-213143-1724448731074.csv")


names(dados)
class(dados$valor_remuneracao_media)


# Carregar pacotes necessários
library(ggplot2)
library(dplyr)

# Supondo que seus dados estejam no data frame 'dados'
# 'esfera' contém os valores Federal, Estadual, Municipal, etc.
# 'valor_remuneracao_media' contém os valores de salários

# Calcular os decis e quartis

# Total
decis_quartis_tot <- dados %>%
  summarise(
    `1º Decil` = quantile(valor_remuneracao_media, 0.1),
    `2º Decil` = quantile(valor_remuneracao_media, 0.2),
    `1º Quartil` = quantile(valor_remuneracao_media, 0.25),
    `3º Decil` = quantile(valor_remuneracao_media, 0.3),
    `4º Decil` = quantile(valor_remuneracao_media, 0.4),
    `Mediana` = quantile(valor_remuneracao_media, 0.5),
    `6º Decil` = quantile(valor_remuneracao_media, 0.6),
    `7º Decil` = quantile(valor_remuneracao_media, 0.7),
    `3º Quartil` = quantile(valor_remuneracao_media, 0.75),
    `8º Decil` = quantile(valor_remuneracao_media, 0.8),
    `9º Decil` = quantile(valor_remuneracao_media, 0.9)
  ) %>%
  gather(key = "Medida", value = "Valor") %>% 
  mutate(categoria = "Público")

# Esfera
decis_quartis_esfera <- dados %>%
  filter(esfera != "Outros") %>% 
  group_by(esfera) %>%
  summarise(
    `1º Decil` = quantile(valor_remuneracao_media, 0.1),
    `2º Decil` = quantile(valor_remuneracao_media, 0.2),
    `1º Quartil` = quantile(valor_remuneracao_media, 0.25),
    `3º Decil` = quantile(valor_remuneracao_media, 0.3),
    `4º Decil` = quantile(valor_remuneracao_media, 0.4),
    `Mediana` = quantile(valor_remuneracao_media, 0.5),
    `6º Decil` = quantile(valor_remuneracao_media, 0.6),
    `7º Decil` = quantile(valor_remuneracao_media, 0.7),
    `3º Quartil` = quantile(valor_remuneracao_media, 0.75),
    `8º Decil` = quantile(valor_remuneracao_media, 0.8),
    `9º Decil` = quantile(valor_remuneracao_media, 0.9)
  ) %>%
  gather(key = "Medida", value = "Valor", -esfera) %>% 
  dplyr::rename(categoria = esfera)

# Poder
decis_quartis_poderes <- dados %>%
  filter(poderes != "Outros") %>% 
  group_by(poderes) %>%
  summarise(
    `1º Decil` = quantile(valor_remuneracao_media, 0.1),
    `2º Decil` = quantile(valor_remuneracao_media, 0.2),
    `1º Quartil` = quantile(valor_remuneracao_media, 0.25),
    `3º Decil` = quantile(valor_remuneracao_media, 0.3),
    `4º Decil` = quantile(valor_remuneracao_media, 0.4),
    `Mediana` = quantile(valor_remuneracao_media, 0.5),
    `6º Decil` = quantile(valor_remuneracao_media, 0.6),
    `7º Decil` = quantile(valor_remuneracao_media, 0.7),
    `3º Quartil` = quantile(valor_remuneracao_media, 0.75),
    `8º Decil` = quantile(valor_remuneracao_media, 0.8),
    `9º Decil` = quantile(valor_remuneracao_media, 0.9)
  ) %>%
  gather(key = "Medida", value = "Valor", -poderes) %>% 
  dplyr::rename(categoria = poderes)

# Junta esfera e poder
decis_quartis_esfera_poderes <- dados %>%
  filter(esfera != "Outros",
         poderes != "Outros") %>% 
  mutate(esfera_poder = paste(poderes, esfera, by = " ")) %>% 
  group_by(esfera_poder) %>%
             summarise(
               `1º Decil` = quantile(valor_remuneracao_media, 0.1),
               `2º Decil` = quantile(valor_remuneracao_media, 0.2),
               `1º Quartil` = quantile(valor_remuneracao_media, 0.25),
               `3º Decil` = quantile(valor_remuneracao_media, 0.3),
               `4º Decil` = quantile(valor_remuneracao_media, 0.4),
               `Mediana` = quantile(valor_remuneracao_media, 0.5),
               `6º Decil` = quantile(valor_remuneracao_media, 0.6),
               `7º Decil` = quantile(valor_remuneracao_media, 0.7),
               `3º Quartil` = quantile(valor_remuneracao_media, 0.75),
               `8º Decil` = quantile(valor_remuneracao_media, 0.8),
               `9º Decil` = quantile(valor_remuneracao_media, 0.9)
             ) %>%
             gather(key = "Medida", value = "Valor", -esfera_poder) %>% 
  dplyr::rename(categoria = esfera_poder)



# Junta tudo
decis <- decis_quartis_tot %>% 
  bind_rows(decis_quartis_esfera) %>% 
  bind_rows(decis_quartis_poderes) %>% 
  bind_rows(decis_quartis_esfera_poderes) %>% 
  mutate(categoria = str_trim(categoria))

# Reordena 
decis$categoria2 <- factor(decis$categoria, 
                           levels = c("Judiciário Estadual", "Judiciário Federal",
                                      "Legislativo Municipal", "Legislativo Estadual", "Legislativo Federal",
                                      "Executivo Municipal", "Executivo Estadual", "Executivo Federal",
                                      "Judiciário", "Legislativo", "Executivo",
                                      "Municipal", "Estadual", "Federal", "Público"))


decis$Medida2 <- factor(decis$Medida, 
                           levels = c("1º Decil", "1º Quartil", "2º Decil", "3º Decil", "4º Decil",
                                      "Mediana", "6º Decil", "7º Decil",  "3º Quartil",
                                      "8º Decil", "9º Decil"))

# Criar o gráfico de calor
ggplot(decis, aes(x = Medida2, y = categoria2, fill = Valor)) +
  geom_tile() +
  scale_fill_gradientn(
    colors = c("#FFE4B5", "#FFA07A", "#E9967A", "#CD5C5C", "#8B0000"),
    breaks = c(10000,20000, 30000, 40000),
    labels = c("10 Mil",  "20 Mil", "30 Mil", "40 Mil")
  ) +
  labs(
    title = "Decis, quartis e mediana das remunerações públicas, 2022",
    x = "",
    y = "",
    fill = "Salário"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# salvar
ggsave(filename = 'Z:/Temp/Helena/indicador_salarios_rais2022.png', plot = last_plot(), device = 'png',
       width = 22, height = 18, units = 'cm', bg = 'white')

# salvar base
write_xlsx(decis, path = "Z:/Temp/Helena/indicador_salarios_rais2022.xlsx")
