# packages
library(tidyverse)
library(PNADcIBGE)
library(survey)
library(srvyr)
library(ggrepel)
library(scales)
library(MetBrewer)
library(writexl)

# vars importantes
# V2007 [sexo]
# V2010 [raça]
# VD4008 [var emprego]
# V4014 [esfera]
# VD4008 [funcao de lideranca]
# V403311 [faixa salarial]

# abertura e tratamento dos dados da PNAD Contínua ----
pnadc <- get_pnadc(year = 2025, quarter = 1)

pnadc_setor_publico <- as_survey(pnadc) |> 
  filter(VD4008 == 'Empregado no setor público (inclusive servidor estatutário e militar)') |> 
  mutate(
    cor = case_when(
      V2010 == 'Branca' ~ 'Branca',
      V2010 %in% c('Preta', 'Parda') ~ 'Negra',
      V2010 %in% c('Amarela', 'Indígena') ~ 'Outra',
      TRUE ~ NA
    ),
    faixa_rem = factor(
      x = V403311,
      levels = c(
        '1 a [0,5SM]', '[0,5SM]+1 a [1SM]', '[1SM]+1 a [2SM]', '[2SM]+1 a [3SM]',
        '[3SM]+1 a [5SM]', '[5SM]+1 a [10SM]', '[10SM]+1 a [20SM]', '[20SM]+1 ou mais'
      ),
      labels = c(
        'De 0 a 0,5 SM', 'De 0,5 SM a 1 SM', 'De 1 SM a 2 SM', 'De 2 SM a 3 SM',
        'De 4 SM a 5 SM', 'De 5 SM a 10 SM', 'De 10 SM a 20 SM', 'Superior a 20 SM'
      )
    )
  )

# 1. Quantidade e porcentagem de pessoas que trabalham no setor público por gênero ----
out_01 <- pnadc_setor_publico |> 
  group_by(sexo = V2007) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_01

ggplot(data = out_01, mapping = aes(x = '', y = prop, fill = sexo)) +
  geom_bar(stat = 'identity') +
  geom_label(
    mapping = aes(label = str_c(number(freq, accuracy = 0.1, scale = 1e-6, suffix = 'M'), '; ', percent(prop, accuracy = 0.1, decimal.mark = ','))),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_fill_manual(
    name = 'Porcentagem de pessoas\nno setor público por gênero:',
    values = met.brewer(name = 'VanGogh3', n = 2, type = 'discrete')
  ) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_01.png', plot = last_plot(), device = 'png',
  width = 15, height = 15, units = 'cm', bg = 'white'
)

dev.off()

# 2. Quantidade e porcentagem de pessoas que trabalham no setor público por gênero e por esfera ----
out_02 <- pnadc_setor_publico |> 
  group_by(esfera = V4014, sexo = V2007) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_02

ggplot(data = out_02, mapping = aes(x = '', y = prop, fill = sexo)) +
  geom_bar(stat = 'identity') +
  geom_label(
    mapping = aes(label = str_c(number(freq, accuracy = 0.1, scale = 1e-6, suffix = 'M'), '; ', percent(prop, accuracy = 0.1, decimal.mark = ','))),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  facet_wrap(facets = ~ esfera) +
  scale_fill_manual(
    name = 'Porcentagem de pessoas\nno setor público por gênero\ne por esfera:',
    values = met.brewer(name = 'VanGogh3', n = 2, type = 'discrete')
  ) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_02.png', plot = last_plot(), device = 'png',
  width = 30, height = 15, units = 'cm', bg = 'white'
)

dev.off()

# 3. Quantidade e porcentagem de pessoas que trabalham no setor público por raça ----
out_03 <- pnadc_setor_publico |> 
  drop_na(cor) |> 
  group_by(cor) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_03

ggplot(data = out_03, mapping = aes(x = '', y = prop, fill = cor)) +
  geom_bar(stat = 'identity') +
  geom_label(
    mapping = aes(label = str_c(number(freq, accuracy = 0.1, scale = 1e-6, suffix = 'M'), '; ', percent(prop, accuracy = 0.1, decimal.mark = ','))),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  scale_fill_manual(
    name = 'Porcentagem de pessoas\nno setor público por cor/raça:',
    values = met.brewer(name = 'VanGogh3', n = 3, type = 'discrete')
  ) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_03.png', plot = last_plot(), device = 'png',
  width = 15, height = 15, units = 'cm', bg = 'white'
)

dev.off()

# 4. Quantidade e porcentagem de pessoas que trabalham no setor público por raça e por esfera ----
out_04 <- pnadc_setor_publico |> 
  drop_na(cor) |> 
  group_by(esfera = V4014, cor) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_04

ggplot(data = out_04, mapping = aes(x = '', y = prop, fill = cor)) +
  geom_bar(stat = 'identity') +
  geom_label(
    mapping = aes(label = str_c(number(freq, accuracy = 0.1, scale = 1e-6, suffix = 'M'), '; ', percent(prop, accuracy = 0.1, decimal.mark = ','))),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE
  ) +
  facet_wrap(facets = ~ esfera) +
  scale_fill_manual(
    name = 'Porcentagem de pessoas\nno setor público por raça\ne por esfera:',
    values = met.brewer(name = 'VanGogh3', n = 3, type = 'discrete')
  ) +
  coord_polar(theta = 'y') +
  theme_void() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_04.png', plot = last_plot(), device = 'png',
  width = 30, height = 15, units = 'cm', bg = 'white'
)

dev.off()

# 5. Quantidade e porcentagem de pessoas que trabalham no setor público por raça e por gênero ----
out_05 <- pnadc_setor_publico |>
  drop_na(cor) |> 
  group_by(interact(sexo = V2007, cor)) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_05

ggplot(data = out_05, mapping = aes(x = fct_rev(cor), y = prop, fill = sexo, group = sexo)) +
  geom_bar(stat = 'identity') +
  geom_label_repel(
    mapping = aes(label = str_c(number(freq, accuracy = 1, big.mark = '\\.'), '\n(', percent(prop, accuracy = 0.1, decimal.mark = ','), ')')),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE, hjust = 0.8, vjust = 0.5, max.overlaps = 50
  ) +
  labs(x = '', fill = '', group = '', y = 'Proporção (%)', title = 'Porcentagem de pessoas no setor público por gênero e raça:') +
  scale_y_continuous(breaks = pretty_breaks(n = 5), labels = percent_format(accuracy = 1)) +
  scale_fill_manual(values = met.brewer(name = 'VanGogh3', n = 2, type = 'discrete')) +
  coord_flip() +
  theme_bw() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_05.png', plot = last_plot(), device = 'png',
  width = 25, height = 15, units = 'cm', bg = 'white'
)

dev.off()

# 6. Quantidade e porcentagem de pessoas que trabalham no setor público por raça, gênero e por esfera ----
out_06 <- pnadc_setor_publico |>
  drop_na(cor) |> 
  group_by(esfera = V4014, interact(cor, sexo = V2007)) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_06

ggplot(data = out_06, mapping = aes(x = fct_rev(cor), y = prop, fill = sexo, group = sexo)) +
  geom_bar(stat = 'identity') +
  geom_label_repel(
    mapping = aes(label = str_c(number(freq, accuracy = 1, big.mark = '\\.'), '\n(', percent(prop, accuracy = 0.1, decimal.mark = ','), ')')),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE, hjust = 0.8, vjust = 0.5, max.overlaps = 50
  ) +
  facet_wrap(facets = ~ esfera) +
  labs(x = '', fill = '', group = '', y = 'Proporção (%)', title = 'Porcentagem de pessoas no setor público por gênero, raça e esfera:') +
  scale_y_continuous(breaks = pretty_breaks(n = 5), labels = percent_format(accuracy = 1)) +
  scale_fill_manual(values = met.brewer(name = 'VanGogh3', n = 2, type = 'discrete')) +
  coord_flip() +
  theme_bw() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_06.png', plot = last_plot(), device = 'png',
  width = 30, height = 15, units = 'cm', bg = 'white'
)

dev.off()

# 7. Quantidade e porcentagem de pessoas que trabalham no setor público por raça e gênero em posição de liderança ----
out_07 <- pnadc_setor_publico |>
  drop_na(cor) |> 
  filter(VD4011 == 'Diretores e gerentes') |> 
  group_by(interact(sexo = V2007, cor)) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_07

ggplot(data = out_07, mapping = aes(x = fct_rev(cor), y = prop, fill = sexo, group = sexo)) +
  geom_bar(stat = 'identity') +
  geom_label_repel(
    mapping = aes(label = str_c(number(freq, accuracy = 1, big.mark = '\\.'), '\n(', percent(prop, accuracy = 0.1, decimal.mark = ','), ')')),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE, hjust = 0.8, vjust = 0.5, max.overlaps = 50
  ) +
  labs(x = '', fill = '', group = '', y = 'Proporção (%)', title = 'Porcentagem de pessoas no setor público por gênero e raça em posições de liderança:') +
  scale_y_continuous(breaks = pretty_breaks(n = 5), labels = percent_format(accuracy = 1)) +
  scale_fill_manual(values = met.brewer(name = 'VanGogh3', n = 2, type = 'discrete')) +
  coord_flip() +
  theme_bw() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_07.png', plot = last_plot(), device = 'png',
  width = 25, height = 15, units = 'cm', bg = 'white'
)

dev.off()

# 7v2. Quantidade e porcentagem de pessoas que trabalham no setor público por raça e gênero em posição de liderança ----
out_07_v2 <- pnadc_setor_publico |>
  drop_na(cor) |> 
  # filter(VD4011 == 'Diretores e gerentes') |> 
  filter(V4010 != '1345') |> 
  filter(V4010 >= '1111' & V4010 <= '1439') |> 
  group_by(interact(sexo = V2007, cor)) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_07_v2

ggplot(data = out_07_v2, mapping = aes(x = fct_rev(cor), y = prop, fill = sexo, group = sexo)) +
  geom_bar(stat = 'identity') +
  geom_label_repel(
    mapping = aes(label = str_c(number(freq, accuracy = 1, big.mark = '\\.'), '\n(', percent(prop, accuracy = 0.1, decimal.mark = ','), ')')),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE, hjust = 0.8, vjust = 0.5, max.overlaps = 50
  ) +
  labs(x = '', fill = '', group = '', y = 'Proporção (%)', title = 'Porcentagem de pessoas no setor público por gênero e raça em posições de liderança:') +
  scale_y_continuous(breaks = pretty_breaks(n = 5), labels = percent_format(accuracy = 1)) +
  scale_fill_manual(values = met.brewer(name = 'VanGogh3', n = 2, type = 'discrete')) +
  coord_flip() +
  theme_bw() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_07_v2.png', plot = last_plot(), device = 'png',
  width = 25, height = 15, units = 'cm', bg = 'white'
)

dev.off()

# 8. Quantidade e porcentagem de pessoas que trabalham no setor público por raça, gênero e por faixa de remuneração ----
out_08 <- pnadc_setor_publico |>
  drop_na(cor) |> 
  drop_na(faixa_rem) |> 
  group_by(faixa_rem, interact(cor, sexo = V2007)) |> 
  summarise(
    freq = survey_total(vartype = c('se', 'cv')),
    prop = survey_mean(vartype = c('se', 'cv')),
    .groups = 'drop'
  )

out_08

ggplot(data = out_08, mapping = aes(x = fct_rev(cor), y = prop, fill = sexo, group = sexo)) +
  geom_bar(stat = 'identity') +
  geom_label_repel(
    mapping = aes(label = str_c(number(freq, accuracy = 1, big.mark = '\\.'), '\n(', percent(prop, accuracy = 0.1, decimal.mark = ','), ')')),
    position = position_stack(vjust = 0.5),
    show.legend = FALSE, hjust = 0.8, vjust = 0.5, max.overlaps = 50
  ) +
  facet_wrap(facets = ~ faixa_rem) +
  labs(x = '', fill = '', group = '', y = 'Proporção (%)', title = 'Porcentagem de pessoas no setor público por gênero, raça e faixa de remuneração:') +
  scale_y_continuous(breaks = pretty_breaks(n = 5), labels = percent_format(accuracy = 1)) +
  scale_fill_manual(values = met.brewer(name = 'VanGogh3', n = 2, type = 'discrete')) +
  coord_flip() +
  theme_bw() +
  theme(legend.position = 'right')

ggsave(
  filename = 'outputs/indicador_pnad_08.png', plot = last_plot(), device = 'png',
  width = 30, height = 25, units = 'cm', bg = 'white'
)

dev.off()

# salvamento das tabelas com resultados ----
list(
  "indicador_pnad_01" = out_01,
  "indicador_pnad_02" = out_02,
  "indicador_pnad_03" = out_03,
  "indicador_pnad_04" = out_04,
  "indicador_pnad_05" = out_05,
  "indicador_pnad_06" = out_06,
  "indicador_pnad_07" = out_07,
  "indicador_pnad_07_v2" = out_07_v2, # Essa versão é a utilizada para o gráfico
  "indicador_pnad_08" = out_08
) |> 
  write_xlsx('outputs/_pnad_indicadores.xlsx')

rm(out_01, out_02, out_03, out_04, out_05, out_06, out_07, out_08)
rm(pnadc, pnadc_setor_publico)

gc()
