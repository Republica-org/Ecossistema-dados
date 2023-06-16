WITH ativo_inativo AS (
(SELECT
  *,
  'ativo' as classificacao
FROM
  `basedosdados.br_cgu_servidores_executivo_federal.remuneracao_ativo`)
UNION ALL
(SELECT 
  *,
  'inativo' as classificacao
FROM
 `basedosdados.br_cgu_servidores_executivo_federal.remuneracao_inativo` )
)
SELECT 
  *
FROM
  ativo_inativo
WHERE 
  carreira = 'militar'
ORDER BY
  ano, mes