WITH profissionais AS (
  SELECT 
    ano, 
    mes, 
    id_estabelecimento_cnes,
    descricao_familia as tipo_ocupacao,
    COUNT(*) as n_profissionais
  FROM `basedosdados-dev.br_ms_cnes.profissional` as prof
  INNER JOIN `basedosdados-dev.br_bd_diretorios_brasil.cbo_2002` as cbo
  ON prof.cbo_2002 = cbo.cbo_2002
  WHERE mes = 1
  GROUP BY 1,2,3,4),

estabelecimentos AS(
  SELECT 
    ano, 
    mes, 
    id_estabelecimento_cnes,
    id_municipio, 
    sigla_uf,

    CASE 
      WHEN ano < 2013 AND esfera_administrativa = '1' THEN 'Federal'
      WHEN ano < 2013 AND esfera_administrativa = '2' THEN 'Estadual'
      WHEN ano < 2013 AND esfera_administrativa = '3' THEN 'Municipal'
      WHEN ano < 2013 AND esfera_administrativa = '4' THEN 'Privado'
      WHEN natureza_juridica IN ('1015','1040', '1074', '1104','1139', '1163', '1252', '1287', '1317', '1341') THEN 'Federal'
      WHEN natureza_juridica IN ('1023','1058', '1082', '1112', '1147', '1171', '1236','1260',  '1295', '1325') THEN 'Estadual'
      WHEN natureza_juridica IN ('1031','1066', '1120', '1155', '1180', '1244', '1279', '1309', '1333') THEN 'Municipal'
      WHEN natureza_juridica IN ('2011', '2038') THEN 'Empresa Pública'
      WHEN natureza_juridica NOT LIKE  "1%" AND natureza_juridica NOT IN ('2011', '2038') THEN 'Privado'
    END as esfera_administrativa,
  FROM `basedosdados-dev.br_ms_cnes.estabelecimento`
  WHERE mes = 1
)

SELECT 
  estabelecimentos.ano,
  estabelecimentos.id_municipio,
  estabelecimentos.sigla_uf,
  uf.regiao,
  estabelecimentos.esfera_administrativa,
  CASE 
    WHEN esfera_administrativa = 'Privado' THEN 'Privado'
    WHEN esfera_administrativa IS NOT NULL THEN 'Público'
  END AS publico_privado,
  profissionais.tipo_ocupacao,
  SUM(profissionais.n_profissionais) as n_profissionais
FROM estabelecimentos 
INNER JOIN profissionais 
ON estabelecimentos.ano = profissionais.ano AND estabelecimentos.id_estabelecimento_cnes = profissionais.id_estabelecimento_cnes
INNER JOIN `basedosdados-dev.br_bd_diretorios_brasil.uf` as uf
ON estabelecimentos.sigla_uf = uf.sigla
GROUP BY 1,2,3,4,5,6,7