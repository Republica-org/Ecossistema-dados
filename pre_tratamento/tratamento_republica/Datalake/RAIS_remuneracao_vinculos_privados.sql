-- CTE para selecionar e filtrar os dados base uma única vez
WITH base_vinculos_filtrados AS (
  SELECT
    ano,
    natureza_juridica,
    sexo,
    grau_instrucao_apos_2005,
    grau_instrucao_1985_2005,
    tipo_vinculo,
    valor_remuneracao_media
  FROM
    `basedosdados.br_me_rais.microdados_vinculos`
  WHERE
    -- Este filtro seleciona majoritariamente vínculos do setor PRIVADO
    -- Atenção para o ano de 2023
    ano = 2023
    AND ((natureza_juridica NOT LIKE '1%' OR natureza_juridica = '1228')
    AND natureza_juridica NOT IN ('2011', '2038'))
    AND vinculo_ativo_3112 = '1'
)

-- Agrupamento por Poderes
SELECT
  ano,
  "privado" AS flag_publico_privado,
  "poderes" AS variavel,
  CASE
    WHEN natureza_juridica IN ('1015', '1023', '1031') THEN 'Executivo'
    WHEN natureza_juridica IN ('1040', '1058', '1066') THEN 'Legislativo'
    WHEN natureza_juridica IN ('1074', '1082') THEN 'Judiciário'
    ELSE 'Outros'
  END AS categoria,
  AVG(valor_remuneracao_media) AS media_remuneracao
FROM
  base_vinculos_filtrados
GROUP BY
  ano,
  variavel,
  categoria

UNION ALL

-- Agrupamento por Gênero
SELECT
  ano,
  "privado" AS flag_publico_privado,
  "genero" AS variavel,
  CASE
    WHEN sexo = '1' THEN 'Masculino'
    WHEN sexo = '2' THEN 'Feminino'
    ELSE 'Não identificado'
  END AS categoria,
  AVG(valor_remuneracao_media) AS media_remuneracao
FROM
  base_vinculos_filtrados
GROUP BY
  ano,
  variavel,
  categoria

UNION ALL

-- Agrupamento por Grau de Instrução
SELECT
  ano,
  "privado" AS flag_publico_privado,
  "grau_instrucao" AS variavel,
  CASE
    WHEN ano >= 2006 THEN (
      CASE
        WHEN grau_instrucao_apos_2005 IN ('1', '2', '3', '4', '5', '6') THEN 'Até Fundamental'
        WHEN grau_instrucao_apos_2005 IN ('7', '8') THEN 'Até Ensino Médio'
        WHEN grau_instrucao_apos_2005 = '9' THEN 'Até Ensino Superior Completo'
        WHEN grau_instrucao_apos_2005 = '10' THEN 'Até Mestrado'
        WHEN grau_instrucao_apos_2005 = '11' THEN 'Até Doutorado'
        ELSE 'Ignorado'
      END
    )
    WHEN ano < 2006 THEN (
      CASE
        WHEN grau_instrucao_1985_2005 IN ('1', '2', '3', '4', '5', '6') THEN 'Analfabeto'
        WHEN grau_instrucao_1985_2005 IN ('7', '8') THEN 'Até Ensino Médio'
        WHEN grau_instrucao_1985_2005 = '9' THEN 'Até Ensino Superior Completo'
        WHEN grau_instrucao_1985_2005 = '10' THEN 'Até Mestrado'
        WHEN grau_instrucao_1985_2005 = '11' THEN 'Até Doutorado'
        ELSE 'Ignorado'
      END
    )
  END AS categoria,
  AVG(valor_remuneracao_media) AS media_remuneracao
FROM
  base_vinculos_filtrados
GROUP BY
  ano,
  variavel,
  categoria

UNION ALL

-- Agrupamento por Nível de Governo
SELECT
  ano,
  "privado" AS flag_publico_privado,
  "nivel_governo" AS variavel,
  CASE
    WHEN natureza_juridica IN ('1015', '1040', '1074', '1104', '1139', '1163', '1252', '1287', '1317', '1341') THEN 'Federal'
    WHEN natureza_juridica IN ('1023', '1058', '1082', '1112', '1147', '1171', '1236', '1260', '1295', '1325') THEN 'Estadual'
    WHEN natureza_juridica IN ('1031', '1066', '1120', '1155', '1180', '1244', '1279', '1309', '1333') THEN 'Municipal'
    ELSE 'Outros'
  END AS categoria,
  AVG(valor_remuneracao_media) AS media_remuneracao
FROM
  base_vinculos_filtrados
GROUP BY
  ano,
  variavel,
  categoria

UNION ALL

-- Agrupamento por Tipo de Vínculo
SELECT
  ano,
  "privado" AS flag_publico_privado,
  "tipo_vinculo" AS variavel,
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
  END AS categoria,
  AVG(valor_remuneracao_media) AS media_remuneracao
FROM
  base_vinculos_filtrados
GROUP BY
  ano,
  variavel,
  categoria;