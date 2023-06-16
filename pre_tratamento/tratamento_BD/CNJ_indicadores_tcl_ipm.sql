WITH
  sigla AS(
  SELECT
    a.*,
    b.sigla_uf
  FROM
  `basedosdados-dev.br_cnj_estatisticas_poder_judiciario.indicadores_tcl_ipm` AS a
  INNER JOIN `basedosdados-dev.br_cnj_estatisticas_poder_judiciario.recursos_financeiros` AS b
  ON a.ano = b.ano and a.id_tribunal = b.id_tribunal and a.ramo_justica = b.ramo_justica
    
    )
SELECT
  ano,
  sigla_uf,
  ramo_justica,
  id_tribunal,
  sigla_tribunal,
  taxa_congestionamento_liquida,
  indice_produtividade_magistrado
FROM
  sigla