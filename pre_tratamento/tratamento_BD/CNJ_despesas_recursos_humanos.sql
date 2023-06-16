SELECT 
  ano,
  sigla_uf,
  ramo_justica,
  id_tribunal,
  sigla_tribunal,
  despesa_pessoal_encargos AS pessoal_encargos,
  despesa_outras_idenizatorias_indiretas_rh  AS  outras,
  despesa_estagiarios AS estagiarios,
  despesa_terceirizados AS terceirizado,
  despesa_beneficios AS beneficios,
  despesa_rh AS despesa_total_rh,
  despesa_rh_servidores AS servidores,
  despesa_rh_magistrados AS magistrados,
  despesa_funcao_confianca AS funcao_confianca,
  despesa_cargos_comissao AS cargos_comissao
FROM `basedosdados.br_cnj_estatisticas_poder_judiciario.recursos_financeiros`