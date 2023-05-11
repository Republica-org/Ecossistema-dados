SELECT
  ano,
  mes,
  COUNT(*) as quantidade_militar_ativo
FROM
  `basedosdados.br_cgu_servidores_executivo_federal.remuneracao_ativo`
WHERE 
  carreira = 'militar'
GROUP BY 
  1,2
ORDER BY
  1,2