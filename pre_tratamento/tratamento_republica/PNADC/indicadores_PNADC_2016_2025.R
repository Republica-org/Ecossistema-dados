# packages
library(tidyverse)
library(PNADcIBGE)
library(survey)
library(srvyr)
library(ggrepel)
library(scales)
library(MetBrewer)
library(writexl)
setwd("")

anos <- 2016:2025

out_01_all <- list()
out_02_all <- list()
out_03_all <- list()
out_05_all <- list()
out_06_all <- list()
out_07_v2_all <- list()
out_08_all <- list()

for (ano in anos) {
  message("Processando ano ", ano)

  pnadc <- get_pnadc(year = ano, quarter = 1)
    pnadc_setor_publico <- as_survey(pnadc) |> 
      filter(VD4008 == 'Empregado no setor público (inclusive servidor estatutário e militar)') |> 
      mutate(
        ano = ano,
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
             '[3SM]+1 a [4SM]', '[4SM]+1 a [5SM]', '[5SM]+1 a [10SM]', '[10SM]+1 a [20SM]', '[20SM]+1 ou mais'
          ),
          labels = c(
           'De 0 a 0,5 SM', 'De 0,5 SM a 1 SM','De 1 SM a 2 SM', 'De 2 SM a 3 SM', 'De 3 SM a 4 SM', 
           'De 4 SM a 5 SM', 'De 5 SM a 10 SM','De 10 SM a 20 SM', 'Superior a 20 SM')
        )
      )

    # 1. Quantidade e porcentagem de pessoas que trabalham no setor público por gênero ----
    out_01_all[[ano]] <- pnadc_setor_publico |> 
      group_by(ano, sexo = V2007) |> 
      summarise(
        freq = survey_total(vartype = c('se', 'cv')),
        prop = survey_mean(vartype = c('se', 'cv')),
        .groups = 'drop'
      )

    # 2. Quantidade e porcentagem de pessoas que trabalham no setor público por gênero e por esfera ----
    out_02_all[[ano]] <- pnadc_setor_publico |> 
      group_by(ano, esfera = V4014, sexo = V2007) |> 
      summarise(
        freq = survey_total(vartype = c('se', 'cv')),
        prop = survey_mean(vartype = c('se', 'cv')),
        .groups = 'drop'
      )

    # 3. Quantidade e porcentagem de pessoas que trabalham no setor público por raça ----
    out_03_all[[ano]] <- pnadc_setor_publico |> 
      drop_na(cor) |> 
      group_by(ano, cor) |> 
      summarise(
        freq = survey_total(vartype = c('se', 'cv')),
        prop = survey_mean(vartype = c('se', 'cv')),
        .groups = 'drop'
      )

    # 5. Quantidade e porcentagem de pessoas que trabalham no setor público por raça e por gênero ----
    out_05_all[[ano]] <- pnadc_setor_publico |>
      drop_na(cor) |> 
      group_by(ano, sexo = V2007, cor) |> 
      summarise(
        freq = survey_total(vartype = c('se', 'cv')),
        prop = survey_mean(vartype = c('se', 'cv')),
        .groups = 'drop'
      )


    # 6. Quantidade e porcentagem de pessoas que trabalham no setor público por raça, gênero e por esfera ----
    out_06_all[[ano]] <- pnadc_setor_publico |>
      drop_na(cor) |> 
      group_by(ano, esfera = V4014, cor, sexo = V2007) |> 
      summarise(
        freq = survey_total(vartype = c('se', 'cv')),
        prop = survey_mean(vartype = c('se', 'cv')),
        .groups = 'drop'
      )

    # 7. Quantidade e porcentagem de pessoas que trabalham no setor público por raça e gênero em posição de liderança ----
    out_07_v2_all[[ano]] <- pnadc_setor_publico |>
      drop_na(cor) |> 
      # filter(VD4011 == 'Diretores e gerentes') |> 
      filter(V4010 != '1345') |> 
      filter(V4010 >= '1111' & V4010 <= '1439') |> 
      group_by(ano, sexo = V2007, cor) |> 
      summarise(
        freq = survey_total(vartype = c('se', 'cv')),
        prop = survey_mean(vartype = c('se', 'cv')),
        .groups = 'drop'
      )


    # 8. Quantidade e porcentagem de pessoas que trabalham no setor público por raça, gênero e por faixa de remuneração ----
    out_08_all[[ano]] <- pnadc_setor_publico |>
      drop_na(cor) |> 
      drop_na(faixa_rem) |> 
      group_by(ano, faixa_rem, sexo = V2007, cor) |> 
      summarise(
        freq = survey_total(vartype = c('se', 'cv')),
        prop = survey_mean(vartype = c('se', 'cv')),
        .groups = 'drop'
      )

    # salvamento das tabelas com resultados ----
    rm(pnadc, pnadc_setor_publico)
  gc()
}

write_xlsx(
  list(
    indicador_01 = bind_rows(out_01_all),
    indicador_02 = bind_rows(out_02_all),
    indicador_03 = bind_rows(out_03_all),
    indicador_05 = bind_rows(out_05_all),
    indicador_06 = bind_rows(out_06_all),
    indicador_07_v2 = bind_rows(out_07_v2_all),
    indicador_08 = bind_rows(out_08_all)
  ),
  "outputs/pnad_indicadores_serie_2016_2025_T1_v2.xlsx"
)
