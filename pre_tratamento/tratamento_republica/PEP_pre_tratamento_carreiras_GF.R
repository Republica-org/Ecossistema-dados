# cleaning workspace
rm(list = ls())
gc()

# packages
library(tidyverse)
library(readxl)
library(writexl)

# PEP: leitura dos dados brutos ----
pep <- 'Dados/Carreiras GF - d248cf93e92f4e17ba721ec734c69b4d.xlsx' %>% 
  read_xlsx(sheet = 'Document_CH1035', .name_repair = janitor::make_clean_names) %>% 
  filter(row_number() <= n()-3) %>% 
  filter(cargo_em_extincao_indicador == 0)

# Quantidade e porcentagem de planos/carreiras por faixa de número de cargos - 2024 ----
# planos/carreiras == agrupamentos_de_cargos_1
# cargos == cargo_com_codigo
indicador <- pep %>%
  distinct(agrupamentos_de_cargos_1, cargo_com_codigo) %>% 
  count(agrupamentos_de_cargos_1) %>% 
  mutate(
    faixa_cargos = case_when(n == 1 ~ 1, n >= 2 & n <= 10 ~ 2, n >= 11 & n <= 40 ~ 3,
                             n >= 41 & n <= 99 ~ 4, n >= 100 ~ 5) %>% 
      factor(x = ., levels = 1:5, labels = c('1', '2 a 10', '11 a 40',
                                             '41 a 99', 'Acima de 100'))
  ) %>%
  count(faixa_cargos, name = 'qtde_planos') %>% 
  mutate(perc_planos = qtde_planos / sum(qtde_planos) * 100)

# Exportando tabela
write_xlsx(x = indicador, path = 'Outputs/indicador_PEP_1.xlsx')

# Exportando gráfico
ggplot(data = indicador, mapping = aes(x = '', y = qtde_planos, fill = faixa_cargos)) +
  geom_bar(stat = 'identity') +
  ggrepel::geom_label_repel(
    mapping = aes(label = str_c(qtde_planos, '; ', format(round(perc_planos, digits = 1), nsmall = 1, decimal.mark = ','), '%')), 
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_fill_manual(name = 'Faixa de número\nde cargos:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')

ggsave(filename = 'Outputs/indicador_PEP_1.png', plot = last_plot(), device = 'png',
       width = 15, height = 15, units = 'cm', bg = 'white')

dev.off()

rm(indicador)
gc()

# Quantidade e porcentagem de planos/carreiras por faixas de número de servidores - 2024 ----
# número de servidores == qtd_cargos_ocupados
indicador <- pep %>%
  group_by(agrupamentos_de_cargos_1) %>% 
  summarise(n = sum(qtd_cargos_ocupados, na.rm = TRUE), .groups = 'drop') %>% 
  mutate(
    faixa_servidores = case_when(n <= 99 ~ 1, n >= 100 & n <= 499 ~ 2, n >= 500 & n <= 1000 ~ 3,
                                 n >= 1000 & n <= 5000 ~ 4, n > 5000 ~ 5) %>% 
      factor(x = ., levels = 1:5, labels = c('Até 99', '100 a 499', '500 a 1.000',
                                             '1.001 a 5.000', 'Acima de 5 mil'))
  ) %>%
  count(faixa_servidores, name = 'qtde_planos') %>% 
  mutate(perc_planos = qtde_planos / sum(qtde_planos) * 100)

# Exportando tabela
write_xlsx(x = indicador, path = 'Outputs/indicador_PEP_2.xlsx')

# Exportando gráfico
ggplot(data = indicador, mapping = aes(x = '', y = qtde_planos, fill = faixa_servidores)) +
  geom_bar(stat = 'identity') +
  ggrepel::geom_label_repel(
    mapping = aes(label = str_c(qtde_planos, '; ', format(round(perc_planos, digits = 1), nsmall = 1, decimal.mark = ','), '%')), 
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_fill_manual(name = 'Faixa de número\nde servidores:', values = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')

ggsave(filename = 'Outputs/indicador_PEP_2.png', plot = last_plot(), device = 'png',
       width = 15, height = 15, units = 'cm', bg = 'white')

dev.off()

rm(indicador)
gc()

# Dez planos/carreiras com maior representatividade na força de trabalho da administração pública federal - 2024 ----
indicador1 <- pep %>%
  group_by(agrupamentos_de_cargos_1) %>% 
  summarise(n_servidores = sum(qtd_cargos_ocupados, na.rm = TRUE), .groups = 'drop') %>% 
  mutate(perc_servidores = n_servidores / sum(n_servidores) * 100) %>% 
  arrange(desc(n_servidores)) %>% 
  slice(1:10)

indicador2 <- pep %>%
  distinct(agrupamentos_de_cargos_1, cargo_com_codigo) %>% 
  count(agrupamentos_de_cargos_1, name = 'n_cargos') %>% 
  filter(agrupamentos_de_cargos_1 %in% indicador1$agrupamentos_de_cargos_1)

indicador <- left_join(indicador1, indicador2, by = 'agrupamentos_de_cargos_1')

rm(indicador1, indicador2)
gc()

# Exportando tabela
write_xlsx(x = indicador, path = 'Outputs/indicador_PEP_3.xlsx')

# Exportando gráfico
indicador %>% 
  mutate(
    agrupamentos_de_cargos_1 = str_wrap(agrupamentos_de_cargos_1, width = 50)
  ) %>% 
  ggplot(mapping = aes(x = fct_reorder(agrupamentos_de_cargos_1, n_servidores), y = n_servidores)) +
  geom_bar(stat = 'identity', fill = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')[3]) +
  geom_text(
    mapping = aes(label = str_c(format(n_servidores, big.mark = '.', decimal.mark = ','), '\n (', format(round(perc_servidores, digits = 1), nsmall = 1, decimal.mark = ','), '%)')),
    show.legend = FALSE,
    nudge_y = 7500
  ) +
  coord_flip() +
  labs(x = 'Planos/carreiras com maior representatividade\nna força de trabalho da administração pública federal', y = 'Número de servidores') +
  scale_y_continuous(breaks = seq(0, 120000, 20000), limits = c(0, 120000), labels = scales::comma_format(big.mark = '.', decimal.mark = ',')) +
  theme_bw()

ggsave(filename = 'Outputs/indicador_PEP_3.png', plot = last_plot(), device = 'png',
       width = 20, height = 15, units = 'cm', bg = 'white')

dev.off()

rm(indicador)
gc()

# Desigualdades da amplitude salarial da carreira de analista administrativo entre órgãos da administração pública federal - 2024 ----
indicador <- pep %>% 
  filter(nome_do_cargo == 'ANALISTA ADMINISTRATIVO' | nome_do_cargo == 'ANALISTA TECNICO ADMINISTRATIVO') %>% 
  mutate(
    carreiras = case_when(codigo_do_cargo == '441001' | codigo_do_cargo == '433003' ~ 'Analista administrativo Agências',
                          codigo_do_cargo == '616002' ~ 'Analista administrativo PREVIC', 
                          codigo_do_cargo == '461002' ~ 'Analista administrativo DNIT',
                          codigo_do_cargo == '439002' ~ 'Analista administrativo DNPM',
                          codigo_do_cargo == '428004' ~ 'Analista administrativo IBAMA, ICMBIO e MMA',
                          codigo_do_cargo == '474022' ~ 'Analista técnico administrativo SUFRAMA',
                          codigo_do_cargo == '480042' ~ 'Analista técnico administrativo PGPE',
                          codigo_do_cargo == '421032' ~ 'Analista administrativo INCRA'),
    salario_inicial = as.numeric(remuneracao_minimo_valor_inicial),
    salario_final = as.numeric(remuneracao_maximo_valor_final)
  ) %>% 
  filter(!is.na(carreiras)) %>% 
  select(carreiras, salario_inicial, salario_final) %>%
  distinct() %>% 
  arrange(desc(salario_final))

# Exportando tabela
write_xlsx(x = indicador, path = 'Outputs/indicador_PEP_4.xlsx')

# Exportando gráfico
indicador %>% 
  mutate(carreiras = str_wrap(carreiras, width = 25)) %>% 
  ggplot(mapping = aes(x = fct_reorder(carreiras, salario_final, .desc = TRUE))) +
  geom_linerange(mapping = aes(ymin = salario_inicial, ymax = salario_final), linewidth = 1) +
  geom_point(mapping = aes(y = salario_inicial), shape = 15, size = 3) +
  geom_point(mapping = aes(y = salario_final), shape = 15, size = 3) +
  geom_text(nudge_y = -600, mapping = aes(y = salario_inicial, label = scales::dollar(salario_inicial, prefix = 'R$', big.mark = '.', decimal.mark = ','))) +
  geom_text(nudge_y = 600, mapping = aes(y = salario_final, label = scales::dollar(salario_final, prefix = 'R$', big.mark = '.', decimal.mark = ','))) +
  labs(x = 'Cargos', y = 'Amplitude salarial') +
  scale_y_continuous(breaks = seq(3000, 23000, 2000), limits = c(3000, 23000), labels = scales::dollar_format(prefix = 'R$', big.mark = '.', decimal.mark = ',', accuracy = 0.01)) +
  theme_bw()

ggsave(filename = 'Outputs/indicador_PEP_4.png', plot = last_plot(), device = 'png',
       width = 30, height = 15, units = 'cm', bg = 'white')

dev.off()

rm(indicador)
gc()

# Distribuição dos cargos por remuneração inicial e amplitude salarial ----
indicador <- pep %>% 
  mutate(
    salario_inicial = as.numeric(remuneracao_minimo_valor_inicial),
    salario_final = as.numeric(remuneracao_maximo_valor_final),
    amplitude_salarial = (salario_final - salario_inicial) / salario_final
  ) %>%
  select(cargo_com_codigo, salario_inicial, salario_final, amplitude_salarial) %>% 
  drop_na() %>% 
  distinct()

# Exportando tabela
write_xlsx(x = indicador, path = 'Outputs/indicador_PEP_5.xlsx')

# Exportando gráfico
ggplot(data = indicador, mapping = aes(x = amplitude_salarial, y = salario_inicial)) +
  geom_point(size = 2, colour = 'slateblue') +
  labs(x = 'Amplitude salarial', y = 'Remuneração inicial') +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1), labels = scales::comma_format(accuracy = 0.01)) +
  scale_y_continuous(breaks = seq(0, 30000, 5000), limits = c(0, 30000), labels = scales::dollar_format(prefix = 'R$', big.mark = '.', decimal.mark = ',', accuracy = 0.01)) +
  theme_bw()

ggsave(filename = 'Outputs/indicador_PEP_5.png', plot = last_plot(), device = 'png',
       width = 20, height = 13, units = 'cm', bg = 'white')

dev.off()

rm(indicador)
gc()

# Estatísticas descritivas das amplitudes remuneratórias por faixas da remuneração inicial ----
indicador <- pep %>% 
  mutate(
    salario_inicial = as.numeric(remuneracao_minimo_valor_inicial),
    salario_final = as.numeric(remuneracao_maximo_valor_final),
    amplitude_salarial = (salario_final - salario_inicial) / salario_final
  ) %>%
  select(cargo_com_codigo, salario_inicial, salario_final, amplitude_salarial) %>% 
  drop_na() %>% 
  distinct() %>% 
  mutate(
    faixas = case_when(salario_inicial <= 5000 ~ 1,
                       salario_inicial > 5000 & salario_inicial <= 10000 ~ 2,
                       salario_inicial > 10000 & salario_inicial <= 15000 ~ 3,
                       salario_inicial > 15000 ~ 4) %>% 
      factor(levels = 1:4, labels = c('Até 5 mil', 'Entre 5 e 10 mil', 'Entre 10 e 15 mil', 'Acima de 15 mil'))
  )

# Exportando tabela
indicador %>% 
  group_by(faixas) %>% 
  summarise(
    quantidade = n(),
    maximo = max(amplitude_salarial, na.rm = TRUE),
    minimo = min(amplitude_salarial, na.rm = TRUE),
    media = mean(amplitude_salarial, na.rm = TRUE),
    mediana = median(amplitude_salarial, na.rm = TRUE),
    desvpad = sd(amplitude_salarial, na.rm = TRUE),
  ) %>% 
  write_xlsx(path = 'Outputs/indicador_PEP_6.xlsx')

# Exportando gráfico
ggplot(data = indicador, mappin = aes(y = amplitude_salarial, x = faixas)) +
  geom_boxplot(fill = 'slateblue') +
  labs(x = 'Faixas de remuneração inicial (em R$)', y = 'Amplitude salarial') +
  scale_y_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1), labels = scales::comma_format(accuracy = 0.01)) +
  theme_bw()

ggsave(filename = 'Outputs/indicador_PEP_6.png', plot = last_plot(), device = 'png',
       width = 20, height = 13, units = 'cm', bg = 'white')

dev.off()

rm(indicador)
gc()

# Desvalorização do salário maximo de cargos de direção e assessoramento em comparação com carreiras selecionadas da administração pública federal entre 1998 e 2024 ----

# Tabela construída manualmente com base na tabela remuneratória de 1998
indicador <- 'Outputs/indicador_PEP_7.xlsx' %>% 
  read_xlsx() %>% 
  drop_na()

# Exportando gráfico
indicador %>% 
  mutate(carreiras = str_wrap(carreiras, width = 20)) %>% 
  ggplot(mapping = aes(x = fct_reorder(carreiras, var_sf, .desc = TRUE), y = var_sf, label = scales::percent(var_sf))) +
  geom_bar(stat = 'identity', fill = MetBrewer::met.brewer(name = 'VanGogh3', n = 5, type = 'discrete')[3]) +
  geom_text(mapping = aes(vjust = if_else(var_sf > 0, -0.5, 1.5))) +
  labs(x = 'Cargos', y = 'Variação real do salário máximo (em %)\nentre 1998 e 2023') +
  scale_y_continuous(breaks = seq(-0.5, 1, 0.25), limits = c(-0.5, 1), labels = scales::percent_format(accuracy = 1)) +
  theme_bw()

ggsave(filename = 'Outputs/indicador_PEP_7.png', plot = last_plot(), device = 'png',
       width = 30, height = 15, units = 'cm', bg = 'white')

dev.off()

rm(indicador)
gc()

# Desigualdades de amplitude salarial entre cargos de alta direção e carreiras selecionadas da administração pública federal ----
indicador <- pep %>% 
  mutate(
    carreiras = case_when(
      nome_do_cargo == 'AUDITOR FISCAL FEDERAL AGROPECUARIO' ~ 'Auditor Fiscal Federal Agropecuário',
      nome_do_cargo == 'AUDITOR FISCAL DO TRABALHO' ~ 'Auditor Fiscal do Trabalho',
      nome_do_cargo == 'ADVOGADO DA UNIAO' ~ 'Advogado da União',
      nome_do_cargo == 'ESP POL PUBL GESTAO GOVERNAMENTAL' ~ 'EPPGG',
      nome_do_cargo == 'ANALISTA EM CIENCIA E TECNOLOGIA' ~ 'Analista em Ciência e Tecnologia',
      TRUE ~ NA_character_
    )
  ) %>% 
  mutate(
    salario_inicial = as.numeric(remuneracao_minimo_valor_inicial),
    salario_final = as.numeric(remuneracao_maximo_valor_final)
  ) %>%
  select(carreiras, salario_inicial, salario_final) %>% 
  drop_na() %>% 
  distinct() %>% 
  add_row(
    carreiras = c('CCE-17 (DAS-6)', 'CCE-15 até CCE-16 (DAS-5)', 'CCE-13 até CCE-14 (DAS-4)'),
    salario_inicial = c(18887.14, 14849.50, 11306.90),
    salario_final = c(18887.14, 17100.92, 12701.64),
  ) %>% 
  arrange(desc(salario_final)) %>% 
  mutate(amplitude_salarial = (salario_final - salario_inicial) / salario_final)

# Exportando tabela
write_xlsx(x = indicador, path = 'Outputs/indicador_PEP_8.xlsx')

# Exportando gráfico
indicador %>% 
  mutate(carreiras = str_wrap(carreiras, width = 20)) %>% 
  ggplot(mapping = aes(x = fct_reorder(carreiras, salario_final, .desc = TRUE))) +
  geom_linerange(mapping = aes(ymin = salario_inicial, ymax = salario_final), linewidth = 1) +
  geom_point(mapping = aes(y = salario_inicial), shape = 15, size = 3) +
  geom_point(mapping = aes(y = salario_final), shape = 15, size = 3) +
  geom_text(nudge_y = -1000, mapping = aes(y = salario_inicial, label = scales::dollar(salario_inicial, prefix = 'R$', big.mark = '.', decimal.mark = ','))) +
  geom_text(nudge_y = 1000, mapping = aes(y = salario_final, label = scales::dollar(salario_final, prefix = 'R$', big.mark = '.', decimal.mark = ','))) +
  labs(x = 'Cargos', y = 'Amplitude salarial') +
  scale_y_continuous(breaks = seq(0, 35000, 5000), limits = c(5000, 35000), labels = scales::dollar_format(prefix = 'R$', big.mark = '.', decimal.mark = ',', accuracy = 0.01)) +
  theme_bw()

ggsave(filename = 'Outputs/indicador_PEP_8.png', plot = last_plot(), device = 'png',
       width = 30, height = 15, units = 'cm', bg = 'white')

dev.off()

rm(indicador)
gc()
