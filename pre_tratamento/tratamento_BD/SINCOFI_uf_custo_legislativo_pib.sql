SELECT 
  a.ano,
  b.sigla_uf,
  valor,
  pib,  
  valor/pib  as custo_legislativo_pib
FROM
  `basedosdados-dev.br_me_siconfi.uf_despesas_funcao` AS a
  INNER JOIN `basedosdados-dev.br_ibge_pib.uf` as b
  ON a.sigla_uf = b.sigla_uf and a.ano = b.ano
WHERE 
  conta = 'Legislativa' and estagio = 'Despesas Pagas'
ORDER BY ano