
 SELECT 

  ano, 
  sigla_uf,

  CASE 
    WHEN natureza_juridica IN ('1015','1023', '1031') THEN 'Executivo'
    WHEN natureza_juridica IN ('1040','1058', '1066') THEN 'Legislativo'
    WHEN natureza_juridica IN ('1074','1082') THEN 'Judiciário'
    ELSE 'Outros' 
  END AS poderes,

  
  CASE 
    WHEN natureza_juridica IN ('1015','1040', '1074', '1104','1139', '1163', '1252', '1287', '1317', '1341') THEN 'Federal'
    WHEN natureza_juridica IN ('1023','1058', '1082', '1112', '1147', '1171', '1236','1260',  '1295', '1325') THEN 'Estadual'
    WHEN natureza_juridica IN ('1031','1066', '1120', '1155', '1180', '1244', '1279', '1309', '1333') THEN 'Municipal'
    ELSE 'Outros' 
  END AS esfera,

  CASE 
    WHEN natureza_juridica IN ( '1015','1040','1074','1023','1058','1082','1031','1066','1317','1325','1333') THEN 'Adm Direta'
    WHEN natureza_juridica IN ('1104','1139','1163','1252','1112','1147','1171','1236','1260','1120','1155','1180','1244','1279','1287','1295','1309') THEN 'Indireta'
    WHEN natureza_juridica IN ('2013', '2038') THEN 'Empresa Pública'
    ELSE 'Outros' 
  END AS tipologia,

  CASE 
    WHEN sexo = '1' THEN 'Masculino'
    WHEN sexo = '2' THEN 'Feminino'
    ELSE 'Não identificado'
  END AS sexo,

  CASE 
    WHEN raca_cor = '1' THEN 'Indígena'
    WHEN raca_cor = '2' THEN 'Branca'
    WHEN raca_cor = '4' THEN 'Preta'
    WHEN raca_cor = '6' THEN 'Amarela'
    WHEN raca_cor = '8' THEN 'Não Identificado'
    ELSE 'Ignorado' 
  END AS raca,

  CASE 

    WHEN ano >= 2006 THEN (CASE 

      WHEN grau_instrucao_apos_2005 = '1' THEN 'Analfabeto'
      WHEN grau_instrucao_apos_2005 = '2' THEN  'Até 5.a inc'
      WHEN grau_instrucao_apos_2005 = '3' THEN  '5.a completo '
      WHEN grau_instrucao_apos_2005 = '4' THEN  '6.a ao 9.a fund'
      WHEN grau_instrucao_apos_2005 = '5' THEN  'Fund completo'
      WHEN grau_instrucao_apos_2005 = '6' THEN  'Médio incompleto'
      WHEN grau_instrucao_apos_2005 = '7' THEN  'Médio completo'
      WHEN grau_instrucao_apos_2005 = '8' THEN  'Sup. incompleto'
      WHEN grau_instrucao_apos_2005 = '9' THEN  'Sup. completo'
      WHEN grau_instrucao_apos_2005 = '10' THEN  'Mestrado'
      WHEN grau_instrucao_apos_2005 = '11' THEN  'Doutorado'
      ELSE 'Ignorado'

    END )



    WHEN ano < 2006 THEN ( CASE 

    WHEN grau_instrucao_1985_2005 = '1' THEN 'Analfabeto'
    WHEN grau_instrucao_1985_2005 = '2' THEN  'Até 5.a inc'
    WHEN grau_instrucao_1985_2005 = '3' THEN  '5.a completo '
    WHEN grau_instrucao_1985_2005 = '4' THEN  '6.a ao 9.a fund'
    WHEN grau_instrucao_1985_2005 = '5' THEN  'Fund completo'
    WHEN grau_instrucao_1985_2005 = '6' THEN  'Médio incompleto'
    WHEN grau_instrucao_1985_2005 = '7' THEN  'Médio completo'
    WHEN grau_instrucao_1985_2005 = '8' THEN  'Sup. incompleto'
    WHEN grau_instrucao_1985_2005 = '9' THEN  'Sup. completo'
    WHEN grau_instrucao_1985_2005 = '10' THEN  'Mestrado'
    WHEN grau_instrucao_1985_2005 = '11' THEN  'Doutorado'
    ELSE 'Ignorado'

  END)

  END AS grau_instrucao,

  CASE
    WHEN faixa_etaria = '1'  THEN '10 a 14 anos'
    WHEN faixa_etaria = '2'  THEN '15 a 17 anos'
    WHEN faixa_etaria = '3'  THEN '18 a 24 anos'
    WHEN faixa_etaria = '4'  THEN '25 a 29 anos'
    WHEN faixa_etaria = '5'  THEN '30 a 39 anos'
    WHEN faixa_etaria = '6'  THEN '40 a 49 anos'
    WHEN faixa_etaria = '7'  THEN '50 a 64 anos'
    WHEN faixa_etaria = '8'  THEN '65 anos ou mais'
  END AS faixa_etaria,

  CASE
    WHEN indicador_portador_deficiencia = 0  THEN 'Não'
    WHEN indicador_portador_deficiencia = 1  THEN 'Sim'
    ELSE "Ignorado"
  END AS  indicador_portador_deficiencia,


  AVG(tempo_emprego) AS media_tempo_emprego,


  CASE
    WHEN quantidade_horas_contratadas >= 40   THEN '40 horas ou mais'
    WHEN quantidade_horas_contratadas = 30  THEN '30 horas'
    WHEN quantidade_horas_contratadas = 20 THEN '20 horas'
    ELSE "Ignorado"
  END AS  carga_horaria,


CASE 
    WHEN tipo_vinculo = '10' THEN 'CLT'
    WHEN tipo_vinculo = '15' THEN 'CLT'
    WHEN tipo_vinculo = '20' THEN 'CLT/Rural'
    WHEN tipo_vinculo = '25' THEN 'CLT/Rural'
    WHEN tipo_vinculo = '30' THEN 'Estatutário'
    WHEN tipo_vinculo = '31' THEN 'Estatutário'
    WHEN tipo_vinculo = '35' THEN 'Estatutário não efetivo'
    WHEN tipo_vinculo = '40' THEN 'Avulso'
    WHEN tipo_vinculo = '50' THEN 'Temporário'
    WHEN tipo_vinculo = '55' THEN 'Aprendiz contratado'
    WHEN tipo_vinculo = '60' THEN 'CLT'
    WHEN tipo_vinculo = '65' THEN 'CLT'
    WHEN tipo_vinculo = '70' THEN 'CLT'
    WHEN tipo_vinculo = '75' THEN 'CLT'
    WHEN tipo_vinculo = '80' THEN 'Diretor'
    WHEN tipo_vinculo = '90' THEN 'Contratado/prazo determinado'
    WHEN tipo_vinculo = '95' THEN 'Contratado/tempo determinado'
    WHEN tipo_vinculo = '96' THEN 'Contratado/tempo determinado'
    WHEN tipo_vinculo = '97' THEN 'Contratado/tempo determinado'
    ELSE 'Ignorado' 
  END AS tipo_vinculo,

  COUNT(*) AS quantidade_vinculos

FROM `basedosdados.br_me_rais.microdados_vinculos`
WHERE (natureza_juridica LIKE "1%" 
OR natureza_juridica IN ('2011', '2038'))
AND natureza_juridica != '1228'
AND cbo_2002 NOT LIKE "0%" 
AND vinculo_ativo_3112 = 1

GROUP BY 

  ano, 
  sigla_uf,
  poderes,
  esfera,
  tipologia, 
  sexo, 
  raca, 
  indicador_portador_deficiencia,
  faixa_etaria,
  grau_instrucao_apos_2005,
  grau_instrucao_1985_2005,
  grau_instrucao,
  tempo_emprego, 
  carga_horaria,
  tipo_vinculo