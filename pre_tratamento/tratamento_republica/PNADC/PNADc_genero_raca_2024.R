
# 1. SET UP -----------------------------------------------------------------------
gc()
rm(list=ls())

# Pacotes

library(PNADcIBGE)
library(haven)
library(survey)
library(srvyr)
library(writexl)
library(tidyverse)
library(scales)

# 2. Abrir dados ----------------------------------------------------------------------

# vars importantes
# V2007 [sexo]
# V2010 [raça]
# VD4008 [var emprego]
# V4014 [esfera]
# VD4008 [funcao de lideranca]
# V403311 [faixa salarial]


# Acessar dados pesquisa 2024 primeiro tri
dadosPNADc = get_pnadc(year = 2024, quarter = 1)
#dadosPNADc_brutos = get_pnadc(year = 2024, quarter = 1, design = FALSE)

# trabalhadores do setor público
setorpublico = subset(dadosPNADc,  VD4008 == "Empregado no setor público (inclusive servidor estatutário e militar)")


# transforma em objeto survey que consegue ser tratado com funçoes do tidyverse
setorpublico_srvyr <- as_survey(dadosPNADc) %>% 
  filter(VD4008 == "Empregado no setor público (inclusive servidor estatutário e militar)")

# cria nova categoria de cor
setorpublico_srvyr <- setorpublico_srvyr %>% 
  mutate(cor = case_when(V2010 == "Branca" ~ "Branca",
                         V2010 %in% c("Preta", "Parda") ~ "Negra",
                         V2010 %in% c("Amarela", "Indígena") ~ "Outra",
                         TRUE ~ NA))

#### 1. Quantidade e porcentagem de pessoas que trabalham no setor público por gênero #####

# setor publico por genero [prop]
setorpublico_srvyr %>% 
  group_by(V2007) %>% 
  summarise(freq = survey_mean())

# setor publico por genero [sum]
t1 = setorpublico_srvyr %>% 
  group_by(V2007) %>% 
  summarise(sum = survey_total()) %>% 
  rename(sexo = V2007) %>% 
  dplyr::select(-sum_se) %>% 
  mutate(prop = round(100*(sum / sum(sum)), 1 ))

t1


# plot
ggplot(data = t1, mapping = aes(x = '', y = prop, fill = sexo)) +
  geom_bar(stat = 'identity') +
  ggrepel::geom_label_repel(
  
    mapping = aes(label =  str_c(round(sum/1000000,1),  "M",  ' ; ', format(round(prop, digits = 1), nsmall = 1, decimal.mark = ','), '%')), 
      position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_fill_manual(name = 'Porcentagem de pessoas \n no setor público por gênero:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')


ggsave(filename = 'Z:/Temp/Helena/indicador_pnad1.png', plot = last_plot(), device = 'png',
       width = 15, height = 15, units = 'cm', bg = 'white')

#### 2. Quantidade e porcentagem de pessoas que trabalham no setor público por gênero e por esfera ####

# setor publico por genero e esfera [prop]
setorpublico_srvyr %>% 
  group_by(V2007, V4014) %>% 
  summarise(freq = survey_mean())

# Calculate proportion and standard error
t2_cv <- setorpublico_srvyr %>%
  group_by(V2007, V4014) %>%
  summarise(
    proportion = survey_mean(),
    standard_error = survey_mean(se = TRUE)
  ) %>%
  ungroup() %>% 
  mutate(
    cv = (proportion_se / proportion) * 100  # Coefficient of Variation as a percentage
  ) %>% 
  rename(sexo = V2007,
         esfera = V4014) %>% 
  dplyr::select(sexo, esfera, cv)



# setor publico por genero e esfera [sum]
t2 = setorpublico_srvyr %>% 
  group_by(V2007, V4014) %>% 
  summarise(sum = survey_total())  %>% 
  rename(sexo = V2007,
         esfera = V4014) %>% 
  dplyr::select(-sum_se)  %>% 
  group_by(esfera) %>% 
  mutate(prop = round(100*(sum / sum(sum)), 1 ))  %>% left_join(t2_cv)

t2



# plot
ggplot(data = t2, mapping = aes(x = '', y = prop, fill = sexo)) +
  facet_wrap(~esfera) +
  geom_bar(stat = 'identity') +
  ggrepel::geom_label_repel(
  
    mapping = aes(label =  str_c(round(sum/1000000,1),  " M",  ' ; ', format(round(prop, digits = 1), nsmall = 1, decimal.mark = ','), '%')), 
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_fill_manual(name = 'Porcentagem de pessoas \n no setor público por gênero e esfera:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')


ggsave(filename = 'Z:/Temp/Helena/indicador_pnad2.png', plot = last_plot(), device = 'png',
       width = 26, height = 10, units = 'cm', bg = 'white')


### 3. Quantidade e porcentagem de pessoas que trabalham no setor público por raça ####

# setor publico por raça [prop]
setorpublico_srvyr %>% 
  group_by(cor) %>% 
  summarise(freq = survey_mean())

# setor publico por raça [sum]
t3 = setorpublico_srvyr %>% 
  drop_na(cor) %>% 
  group_by(cor) %>% 
  summarise(sum = survey_total())  %>% 
  dplyr::select(-sum_se)   %>% 
  mutate(prop = round(100*(sum / sum(sum)), 1 ))

t3

# plot
ggplot(data = t3, mapping = aes(x = '', y = prop, fill = cor)) +
  geom_bar(stat = 'identity') +
  ggrepel::geom_label_repel(
    #mapping = aes(label = str_c(prop, '%')), 
    mapping = aes(label =  str_c(round(sum/1000000,1),  " M",  ' ; ', format(round(prop, digits = 1), nsmall = 1, decimal.mark = ','), '%')), 
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_fill_manual(name = 'Porcentagem de pessoas \n no setor público por raça:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')


ggsave(filename = 'Z:/Temp/Helena/indicador_pnad3.png', plot = last_plot(), device = 'png',
       width = 15, height = 15, units = 'cm', bg = 'white')



### 4. Quantidade e porcentagem de pessoas que trabalham no setor público por raça e por esfera ####

# setor publico por raça e esfera [prop]
setorpublico_srvyr %>% 
  group_by(cor, V4014) %>% 
  summarise(freq = survey_mean())

# Calculate proportion and standard error
t4_cv <- setorpublico_srvyr %>%
  drop_na(cor) %>% 
  group_by(cor, V4014) %>% 
  summarise(
    proportion = survey_mean(),
    standard_error = survey_mean(se = TRUE)
  ) %>%
  ungroup() %>% 
  mutate(
    cv = (proportion_se / proportion) * 100  # Coefficient of Variation as a percentage
  ) %>% 
  rename(esfera = V4014) %>% 
  dplyr::select(cor, esfera, cv)



# setor publico por raça e esfera [sum]
t4 = setorpublico_srvyr %>% 
  drop_na(cor) %>% 
  group_by(cor, V4014) %>% 
  summarise(sum = survey_total()) %>% 
  rename(esfera = V4014) %>% 
  dplyr::select(-sum_se)  %>% 
  group_by(esfera) %>% 
  mutate(prop = round(100*(sum / sum(sum)), 1 )) %>% 
  left_join(t4_cv)

t4


# plot
ggplot(data = t4, mapping = aes(x = '', y = prop, fill = cor)) +
  facet_wrap(~esfera) +
  geom_bar(stat = 'identity') +
  ggrepel::geom_label_repel(
  
    mapping = aes(label =  str_c(round(sum/1000000,2),  " M",  ' ; ', format(round(prop, digits = 1), nsmall = 1, decimal.mark = ','), '%')), 
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_fill_manual(name = 'Porcentagem de pessoas \n no setor público por raça e esfera:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')


ggsave(filename = 'Z:/Temp/Helena/indicador_pnad4.png', plot = last_plot(), device = 'png',
       width = 30, height = 12, units = 'cm', bg = 'white')


### 5. Quantidade e porcentagem de pessoas que trabalham no setor público por raça e gênero ####

# setor publico por raça e genero [prop]
setorpublico_srvyr %>% 
  group_by(cor, V2007) %>% 
  summarise(freq = survey_mean())

# setor publico por raça e gênero [sum]
t5 = setorpublico_srvyr %>% 
  drop_na(cor) %>% 
  group_by(cor, V2007) %>% 
  summarise(sum = survey_total()) %>% 
  rename(sexo = V2007) %>% 
  dplyr::select(-sum_se)   %>% 
  group_by(sexo) %>% 
  mutate(prop = round(100*(sum / sum(sum)), 1 ))

t5


# plot
# ggplot(data = t5, mapping = aes(x = '', y = prop, fill = sexo)) +
#   facet_wrap(~cor) +
#   geom_bar(stat = 'identity') +
#   ggrepel::geom_label_repel(
#     mapping = aes(label = str_c(prop, '%')), 
#     position = position_stack(vjust = 0.5),
#     show.legend = FALSE
#   ) +
#   scale_fill_manual(name = 'Porcentagem de pessoas \n no setor público por gênero e raça:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
#   coord_polar(theta = 'y') +
#   theme_void() +
#   theme(legend.position = 'right')


# plot 2

t5 <- t5 %>% 
  mutate(cor = factor(cor, levels = c("Outra", "Negra", "Branca")))


ggplot(data = t5, mapping = aes(x = cor, y = prop, fill = sexo, group = as.factor(sexo))) +
  geom_bar(stat = 'identity') +
  scale_fill_manual(values= rep( MetBrewer::met.brewer(name = 'VanGogh3', n = 2, type = 'discrete'),3)) +
  coord_flip() +
  ggrepel::geom_label_repel(
  #  mapping = aes(label = str_c(prop, '%')),
    mapping = aes(label =  str_c(format(round(sum, digits = 0),big.mark = ".", decimal.mark = ",") , "\n (",
                                 format(round(prop, digits = 1), nsmall = 1, decimal.mark = ','), '%)')),
    
    position = position_stack(vjust = 0.5),
    #nudge_y = 0.02, # Adjust as needed
  #  nudge_x = 0, # Adjust as needed
    hjust = 0.2, # Center-align text horizontally
    vjust = 0.5, # Center-align text vertically
    
    show.legend = FALSE
  ) +
  labs(y = '(%)', x = '', fill = "", title = "Porcentagem de pessoas no setor público por gênero e raça:") +
  theme_bw()

ggsave(filename = 'Z:/Temp/Helena/indicador_pnad5.png', plot = last_plot(), device = 'png',
       width = 18, height = 15, units = 'cm', bg = 'white')



### 6. Quantidade e porcentagem de pessoas que trabalham no setor público por raça, gênero e por esfera ####

# setor publico por raça e genero e esfera [prop]
setorpublico_srvyr %>% 
  group_by(cor, V2007, V4014) %>% 
  summarise(freq = survey_mean())


# Calculate proportion and standard error
t6_cv <- setorpublico_srvyr %>%
  drop_na(cor) %>% 
  group_by(cor, V2007, V4014) %>% 
  summarise(
    proportion = survey_mean(),
    standard_error = survey_mean(se = TRUE)
  ) %>%
  ungroup() %>% 
  mutate(
    cv = (proportion_se / proportion) * 100  # Coefficient of Variation as a percentage
  ) %>% 
  rename(esfera = V4014,
         sexo = V2007) %>% 
  dplyr::select(cor, sexo, esfera, cv)



# setor publico por raça e gênero e esfera [sum]
t6 = setorpublico_srvyr %>% 
  drop_na(cor) %>% 
  group_by(cor, V2007, V4014) %>% 
  summarise(sum = survey_total())%>% 
  rename(esfera = V4014,
         sexo = V2007) %>% 
  dplyr::select(-sum_se) %>%
  group_by(esfera) %>% 
  mutate(prop = round(100*(sum / sum(sum)), 1 )) %>% 
  left_join(t6_cv)

t6


# plot
# ggplot(data = t6, mapping = aes(x = '', y = prop, fill = esfera)) +
#   facet_wrap(~sexo+cor) +
#   geom_bar(stat = 'identity') +
#   ggrepel::geom_label_repel(
#     mapping = aes(label = str_c(prop, '%')), 
#     position = position_stack(vjust = 0.5),
#     show.legend = FALSE
#   ) +
#   scale_fill_manual(name = 'Porcentagem de pessoas \n no setor público por gênero \n e raça e esfera:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
#   coord_polar(theta = 'y') +
#   theme_void() +
#   theme(legend.position = 'right')


# plot 2

t6 <- t6 %>% 
  mutate(cor = factor(cor, levels = c("Outra", "Negra", "Branca")))

# plot 2
ggplot(data = t6, mapping = aes(x = cor, y = prop, fill = sexo, group = as.factor(sexo))) +
  geom_bar(stat = 'identity') +
  facet_wrap(~esfera)+
  scale_fill_manual(values= rep( MetBrewer::met.brewer(name = 'VanGogh3', n = 2, type = 'discrete'),3)) +
  coord_flip() +
  ggrepel::geom_label_repel(
    #  mapping = aes(label = str_c(prop, '%')),
    mapping = aes(label =  str_c(format(round(sum, digits = 0),big.mark = ".", decimal.mark = ",") , "\n (",
                                 format(round(prop, digits = 1), nsmall = 1, decimal.mark = ','), '%)')),
    
    position = position_stack(vjust = 0.5),
    #nudge_y = 0.02, # Adjust as needed
    #  nudge_x = 0, # Adjust as needed
    hjust = .6, # Center-align text horizontally
    vjust = 0.2, # Center-align text vertically
    
    show.legend = FALSE
  ) +
  scale_y_continuous(breaks = pretty_breaks(n = 5)) +
  labs(y = '(%)', x = '', fill = "", title = "Porcentagem de pessoas no setor público por gênero e raça e esfera:") +
  theme_bw()

ggsave(filename = 'Z:/Temp/Helena/indicador_pnad6.png', plot = last_plot(), device = 'png',
       width = 28, height = 15, units = 'cm', bg = 'white')




### 7. Quantidade e porcentagem de pessoas que trabalham no setor público por raça, gênero e posição em cargo de liderança ####

# setor publico por raça e genero e cargo de liderança [prop]
setorpublico_srvyr %>% 
  filter(VD4011 == "Diretores e gerentes") %>% 
  group_by(cor, V2007) %>% 
  summarise(freq = survey_mean())



# Calculate proportion and standard error
t7_cv <- setorpublico_srvyr %>%
  drop_na(cor) %>% 
  filter(VD4011 == "Diretores e gerentes") %>% 
  group_by(cor, V2007) %>% 
  summarise(
    proportion = survey_mean(),
    standard_error = survey_mean(se = TRUE)
  ) %>%
  ungroup() %>% 
  mutate(
    cv = (proportion_se / proportion) * 100  # Coefficient of Variation as a percentage
  ) %>% 
  rename(sexo = V2007) %>% 
  dplyr::select(sexo,cor, cv)


# setor publico por raça e gênero e cargo de liderança [sum]
t7 = setorpublico_srvyr %>% 
  drop_na(cor) %>% 
  filter(VD4011 == "Diretores e gerentes") %>% 
  group_by(cor, V2007) %>% 
  summarise(sum = survey_total()) %>% 
  rename(sexo = V2007) %>% 
  dplyr::select(-sum_se)  %>% 
  group_by(sexo) %>% 
  mutate(prop = round(100*(sum / sum(sum)), 1 )) %>% 
  left_join(t7_cv)

t7

# plot
# ggplot(data = t7, mapping = aes(x = '', y = prop, fill = sexo)) +
#   facet_wrap(~cor) +
#   geom_bar(stat = 'identity') +
#   ggrepel::geom_label_repel(
#     mapping = aes(label = str_c(prop, '%')), 
#     position = position_stack(vjust = 0.5),
#     show.legend = FALSE
#   ) +
#   scale_fill_manual(name = 'Porcentagem de pessoas \n no setor público por gênero e raça \n em posições de liderança:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
#   coord_polar(theta = 'y') +
#   theme_void() +
#   theme(legend.position = 'right')


# plot 2

t7 <- t7 %>% 
  mutate(cor = factor(cor, levels = c("Outra", "Negra", "Branca")))

ggplot(data = t7, mapping = aes(x = cor, y = prop, fill = sexo, group = as.factor(sexo))) +
  geom_bar(stat = 'identity') +
  scale_fill_manual(values= rep( MetBrewer::met.brewer(name = 'VanGogh3', n = 2, type = 'discrete'),3)) +
  coord_flip() +
  ggrepel::geom_label_repel(
    mapping = aes(label =  str_c(format(round(sum, digits = 0),big.mark = ".", decimal.mark = ",") , "\n (",
                                 format(round(prop, digits = 1), nsmall = 1, decimal.mark = ','), '%)')),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_y_continuous(breaks = pretty_breaks(n = 5)) +
  labs(y = '(%)', x = '', fill = "", title = "Porcentagem de pessoas no setor público por gênero e raça em posições de liderança:") +
  theme_bw()


ggsave(filename = 'Z:/Temp/Helena/indicador_pnad7.png', plot = last_plot(), device = 'png',
       width = 26, height = 15, units = 'cm', bg = 'white')



### 8. Quantidade e porcentagem de pessoas que trabalham no setor público por raça, gênero e por faixa de remuneração ####

# vars de faixa de remuneracao
# normalmente: V403311 [escolhemos essa] ou no mês de referência V403411

setorpublico_srvyr %>% 
  group_by(cor, V2007,V403311) %>% 
  summarise(freq = survey_total())


# Calculate proportion and standard error
t8_cv <- setorpublico_srvyr %>%
  drop_na(cor, V403411) %>% 
  group_by(cor, V2007,V403311) %>% 
  summarise(
    proportion = survey_mean(),
    standard_error = survey_mean(se = TRUE)
  ) %>%
  ungroup() %>% 
  mutate(
    cv = (proportion_se / proportion) * 100  # Coefficient of Variation as a percentage
  ) %>% 
  rename(sexo = V2007,
         salario = V403311) %>% 
  dplyr::select(cor, sexo, salario, cv)


t8 = setorpublico_srvyr %>% 
  drop_na(cor, V403411) %>% 
  group_by(cor, V2007,V403311) %>% 
  summarise(sum = survey_total()) %>% 
  rename(sexo = V2007,
         salario = V403311) %>% 
  dplyr::select(-sum_se)   %>% 
  group_by(salario) %>% 
  mutate(prop = round(100*(sum / sum(sum)), 1 )) %>% 
  left_join(t8_cv)

t8

# plot
# ggplot(data = t8, mapping = aes(x = '', y = prop, fill = salario)) +
#   facet_wrap(~cor+sexo) +
#   geom_bar(stat = 'identity') +
#   ggrepel::geom_label_repel(
#     mapping = aes(label = str_c(prop, '%')), 
#     position = position_stack(vjust = 0.5),
#     show.legend = FALSE
#   ) +
#   scale_fill_manual(name = 'Porcentagem de pessoas \n no setor público por gênero e raça \n e faixa de remuneração:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 8, type = 'discrete')) +
#   coord_polar(theta = 'y') +
#   theme_void() +
#   theme(legend.position = 'right')
# 

# plot 2
t8 <- t8 %>% 
  mutate(cor = factor(cor, levels = c("Outra", "Negra", "Branca"))) %>% 
  mutate(categ_salario = case_when(salario == "1 a [0,5SM]" ~ "De 0 a 0,5 SM" ,
                                   salario == "[0,5SM]+1 a [1SM]" ~ "De 0,5 SM a 1 SM",
                                   salario == "[1SM]+1 a [2SM]" ~ "De 1 SM a 2 SM",
                                   salario == "[2SM]+1 a [3SM]" ~ "De 2 SM a 3 SM",
                                   salario == "[3SM]+1 a [5SM]" ~ "De 4 SM a 5 SM",
                                   salario == "[5SM]+1 a [10SM]" ~ "De 5 SM a 10 SM",
                                   salario == "[10SM]+1 a [20SM]" ~ "De 10 SM a 20 SM",
                                   salario == "[20SM]+1 ou mais" ~ "Superior a 20 SM",
                                   TRUE ~ NA)) %>% 
  mutate(categ_salario = factor(categ_salario, levels = c("De 0 a 0,5 SM", "De 0,5 SM a 1 SM","De 1 SM a 2 SM",
                                                "De 2 SM a 3 SM", "De 4 SM a 5 SM", "De 5 SM a 10 SM",
                                                "De 10 SM a 20 SM", "Superior a 20 SM")))

# plot 2
ggplot(data = t8, mapping = aes(x = cor, y = prop, fill = sexo, group = as.factor(sexo))) +
  geom_bar(stat = 'identity') +
  facet_wrap(~categ_salario)+
  scale_fill_manual(values= rep( MetBrewer::met.brewer(name = 'VanGogh3', n = 2, type = 'discrete'),3)) +
  coord_flip() +
  ggrepel::geom_label_repel(
    mapping = aes(label =  str_c(format(round(sum, digits = 0),big.mark = ".", decimal.mark = ",") , "\n (",
                                 format(round(prop, digits = 1), nsmall = 1, decimal.mark = ','), '%)')),
    position = position_stack(vjust = 0.4),
    #nudge_y = 0.02, # Adjust as needed
    #  nudge_x = 0, # Adjust as needed
    hjust = .8, # Center-align text horizontally
    vjust = 0.5, # Center-align text vertically
    
    show.legend = FALSE
  ) +
  scale_y_continuous(breaks = pretty_breaks(n = 5)) +
  labs(y = '(%)', x = '', fill = "", title = "Porcentagem de pessoas no setor público por gênero e raça e faixa de remuneração:") +
  theme_bw()

ggsave(filename = 'Z:/Temp/Helena/indicador_pnad8.png', plot = last_plot(), device = 'png',
       width = 30, height = 26, units = 'cm', bg = 'white')




# Exportar tudo em um unico excel e abas separadas

# Create a named list of data frames
df_list <- list("Dados1" = t1, 
                "Dados2" = t2,
                "Dados3" = t3, 
                "Dados4" = t4,
                "Dados5" = t5, 
                "Dados6" = t6,
                "Dados7" = t7, 
                "Dados8" = t8)

# Write the list to an Excel file
write_xlsx(df_list, path = "Z:/Temp/Helena/pnad_tabelas_graficos.xlsx")
