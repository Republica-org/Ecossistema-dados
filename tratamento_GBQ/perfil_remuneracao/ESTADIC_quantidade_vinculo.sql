SELECT
  ano,
  tipo_vinculo,
  sigla_uf,
  sum(quantidade_vinculo) as quantidade_vinculos
FROM
  `basedosdados.br_ibge_estadic.indicadores_quantidade_vinculo`
group by
  1,
  2,
  3