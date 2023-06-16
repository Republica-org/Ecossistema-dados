SELECT 
  a.ano,
  a.sigla_uf,
  a.id_municipio,
  valor,
  pib,
  valor/pib  as custo_legislativo_pib
FROM
  `basedosdados.br_me_siconfi.municipio_despesas_funcao` AS a
  INNER JOIN `basedosdados.br_ibge_pib.municipio` as b
  ON a.id_municipio = b.id_municipio and a.ano = b.ano
WHERE conta = 'Legislativa' and estagio = "Despesas Pagas"
order by a.ano