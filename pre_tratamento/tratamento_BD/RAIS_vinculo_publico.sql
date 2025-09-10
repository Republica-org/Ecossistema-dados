-- Definição da CTE (Common Table Expression) selecionando explicitamente as colunas necessárias.
-- Isso melhora a clareza e a performance.
WITH tabela_1 AS (
  SELECT
    a.nome AS nome_municipio,
    a.nome_regiao,
    b.ano,
    b.sigla_uf,
    b.id_municipio,
    b.natureza_juridica,
    b.sexo,
    b.raca_cor,
    b.grau_instrucao_apos_2005,
    b.grau_instrucao_1985_2005,
    b.faixa_etaria,
    b.tipo_vinculo,
    b.quantidade_horas_contratadas,
    b.cbo_2002,
    b.vinculo_ativo_3112
  FROM
    `basedosdados.br_bd_diretorios_brasil.municipio` AS a
  RIGHT JOIN
    `basedosdados.br_me_rais.microdados_vinculos` AS b ON a.id_municipio = b.id_municipio
)

-- Consulta final com as agregações e classificações
SELECT
  ano,
  sigla_uf,
  nome_municipio,
  id_municipio,
  nome_regiao,

  -- Classificação por Poder
  CASE
    WHEN natureza_juridica IN ('1015','1023','1031','1104','1139','1112','1147','1236','1120','1155','1180','1341') THEN 'Executivo' --certo
    WHEN natureza_juridica IN ('1040','1058','1066') THEN 'Legislativo' --certo
    WHEN natureza_juridica IN ('1074','1082') THEN 'Judiciário' --certo
    ELSE 'Outros'
  END AS poderes,

  -- Classificação por Esfera
  CASE
    WHEN natureza_juridica IN ('1015','1040','1074','1104','1139','1163','1252','1287','1317','1341') THEN 'Federal' --certo
    WHEN natureza_juridica IN ('1023','1058','1082','1112','1147','1171','1236','1260','1295','1325') THEN 'Estadual' --certo
    WHEN natureza_juridica IN ('1031','1066','1120','1155','1180','1244','1279','1309','1333') THEN 'Municipal' --certo 
    ELSE 'Outros'
  END AS esfera,

  -- Classificação por Tipologia da Administração
  CASE
    WHEN natureza_juridica IN ('1015','1040','1074','1023','1058','1082','1031','1066','1317','1325','1333') THEN 'Adm Direta'
    WHEN natureza_juridica IN ('1104','1139','1163','1252','1112','1147','1171','1236','1260','1120','1155','1180','1244','1279','1287','1295','1309') THEN 'Indireta'
    WHEN natureza_juridica IN ('2013','2038') THEN 'Empresa Pública'
    ELSE 'Outros'
  END AS tipologia,

  -- Classificação mais detalhada da Tipologia
  CASE
    WHEN natureza_juridica IN ('1015','1040','1074','1023','1058','1082','1031','1066') THEN 'Adm Direta'
    WHEN natureza_juridica IN ('1104','1112','1120','1139','1147','1155') THEN 'Fundação pública de direito público ou autarquia'
    WHEN natureza_juridica IN ('1163','1171','1180') THEN 'Órgão público autônomo'
    WHEN natureza_juridica IN ('1252','1260','1279') THEN 'Fundação pública de direito privado'
    WHEN natureza_juridica IN ('2013','2038') THEN 'Empresa Pública'
    ELSE 'Outros'
  END AS tipologia2,

  -- Decodificação do Sexo
  CASE
    WHEN sexo = '1' THEN 'Masculino'
    WHEN sexo = '2' THEN 'Feminino'
    ELSE 'Não identificado'
  END AS sexo,

  -- Decodificação da Raça/Cor
  CASE
    WHEN raca_cor = '1' THEN 'Indígena'
    WHEN raca_cor = '2' THEN 'Branca'
    WHEN raca_cor = '4' THEN 'Preta'
    WHEN raca_cor = '6' THEN 'Amarela'
    WHEN raca_cor = '8' THEN 'Não Identificado'
    ELSE 'Ignorado'
  END AS raca,

  -- Decodificação do Grau de Instrução (considerando a mudança de variável em 2006)
  CASE
    WHEN ano >= 2006 THEN
      CASE
        WHEN grau_instrucao_apos_2005 = '1' THEN 'Analfabeto'
        WHEN grau_instrucao_apos_2005 = '2' THEN 'Até 5.a inc'
        WHEN grau_instrucao_apos_2005 = '3' THEN '5.a completo'
        WHEN grau_instrucao_apos_2005 = '4' THEN '6.a ao 9.a fund'
        WHEN grau_instrucao_apos_2005 = '5' THEN 'Fund completo'
        WHEN grau_instrucao_apos_2005 = '6' THEN 'Médio incompleto'
        WHEN grau_instrucao_apos_2005 = '7' THEN 'Médio completo'
        WHEN grau_instrucao_apos_2005 = '8' THEN 'Sup. incompleto'
        WHEN grau_instrucao_apos_2005 = '9' THEN 'Sup. completo'
        WHEN grau_instrucao_apos_2005 = '10' THEN 'Mestrado'
        WHEN grau_instrucao_apos_2005 = '11' THEN 'Doutorado'
        ELSE 'Ignorado'
      END
    WHEN ano < 2006 THEN
      CASE
        WHEN grau_instrucao_1985_2005 = '1' THEN 'Analfabeto'
        WHEN grau_instrucao_1985_2005 = '2' THEN 'Até 5.a inc'
        WHEN grau_instrucao_1985_2005 = '3' THEN '5.a completo'
        WHEN grau_instrucao_1985_2005 = '4' THEN '6.a ao 9.a fund'
        WHEN grau_instrucao_1985_2005 = '5' THEN 'Fund completo'
        WHEN grau_instrucao_1985_2005 = '6' THEN 'Médio incompleto'
        WHEN grau_instrucao_1985_2005 = '7' THEN 'Médio completo'
        WHEN grau_instrucao_1985_2005 = '8' THEN 'Sup. incompleto'
        WHEN grau_instrucao_1985_2005 = '9' THEN 'Sup. completo'
        WHEN grau_instrucao_1985_2005 = '10' THEN 'Mestrado'
        WHEN grau_instrucao_1985_2005 = '11' THEN 'Doutorado'
        ELSE 'Ignorado'
      END
  END AS grau_instrucao,

  -- Decodificação da Faixa Etária
  CASE
    WHEN faixa_etaria = '1' THEN '10 a 14 anos'
    WHEN faixa_etaria = '2' THEN '15 a 17 anos'
    WHEN faixa_etaria = '3' THEN '18 a 24 anos'
    WHEN faixa_etaria = '4' THEN '25 a 29 anos'
    WHEN faixa_etaria = '5' THEN '30 a 39 anos'
    WHEN faixa_etaria = '6' THEN '40 a 49 anos'
    WHEN faixa_etaria = '7' THEN '50 a 64 anos'
    WHEN faixa_etaria = '8' THEN '65 anos ou mais'
  END AS faixa_etaria,

  -- Decodificação do Tipo de Vínculo
  CASE
    WHEN tipo_vinculo IN ('10', '15', '60', '65', '70', '75') THEN 'CLT'
    WHEN tipo_vinculo IN ('20', '25') THEN 'CLT/Rural'
    WHEN tipo_vinculo IN ('30', '31') THEN 'Estatutário'
    WHEN tipo_vinculo = '35' THEN 'Estatutário não efetivo'
    WHEN tipo_vinculo = '40' THEN 'Avulso'
    WHEN tipo_vinculo = '50' THEN 'Temporário'
    WHEN tipo_vinculo = '55' THEN 'Aprendiz contratado'
    WHEN tipo_vinculo = '80' THEN 'Diretor'
    WHEN tipo_vinculo IN ('90', '95', '96', '97') THEN 'Contratado/prazo determinado'
    ELSE 'Ignorado'
  END AS tipo_vinculo,

  quantidade_horas_contratadas,
  COUNT(*) AS quantidade_vinculos

FROM
  tabela_1
WHERE
  (natureza_juridica LIKE '1%' OR natureza_juridica IN ('2011', '2038'))
  AND natureza_juridica != '1228'
  AND cbo_2002 NOT LIKE '0%'
  AND vinculo_ativo_3112 = '1'
-- A cláusula GROUP BY agora contém TODAS as colunas não agregadas do SELECT.
GROUP BY
  ano,
  sigla_uf,
  nome_municipio,
  id_municipio,
  nome_regiao,
  poderes,
  esfera,
  tipologia,
  tipologia2,
  sexo,
  raca,
  grau_instrucao,
  faixa_etaria,
  tipo_vinculo,
  quantidade_horas_contratadas;