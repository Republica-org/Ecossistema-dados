SELECT
  ano,
  tipo_vinculo,
  sigla_uf,
  id_municipio,
  sum(quantidade_vinculo) as quantidade_vinculos
FROM
  `basedosdados.br_ibge_munic.indicadores_quantidade_vinculo`

where ano !=2018

group by
  1,
  2,
  3,
  4