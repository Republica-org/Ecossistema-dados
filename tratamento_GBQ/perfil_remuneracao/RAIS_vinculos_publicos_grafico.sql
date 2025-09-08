-- Etapa 1: Usar uma CTE para classificar os dados primeiro
WITH dados_classificados AS (
  SELECT
    ano,
    sexo,
    poderes,
    tipologia,
    tipologia2,
    esfera,
    sigla_uf,
    quantidade_horas_contratadas,
    tipo_vinculo,
    quantidade_vinculos,

    -- Cria a nova coluna com o agrupamento de grau de instrução
    CASE
      WHEN grau_instrucao IN ('Analfabeto', 'Até 5.a inc', '5.a completo ', '6.a ao 9.a fund', 'Fund completo', 'Médio incompleto') THEN 'Até Fundamental'
      WHEN grau_instrucao IN ('Médio completo', 'Sup. incompleto') THEN 'Até Ensino Médio'
      WHEN grau_instrucao IN ('Sup. completo') THEN 'Até Ensino Superior Completo'
      WHEN grau_instrucao IN ('Mestrado', 'Doutorado') THEN 'Até Pós Graduação'
      ELSE 'Ignorado'
    END AS grupo_instrucao,

    -- Cria a nova coluna com o agrupamento de faixa etária
    CASE
      WHEN faixa_etaria IN ('18 a 24 anos', '25 a 29 anos') THEN 'Entre 18 e 29 anos'
      WHEN faixa_etaria IN ('30 a 39 anos', '40 a 49 anos') THEN 'Entre 30 e 49 anos'
      WHEN faixa_etaria IN ('50 a 64 anos') THEN 'Entre 50 e 64 anos'
      WHEN faixa_etaria IN ('65 anos ou mais') THEN 'Acima de 65 anos'
      ELSE 'Ignorado'
    END AS grupo_etario

  FROM
    `repositoriodedadosgpsp.Datalake.RAIS_vinculos_publicos_pre_tratamento`
)

-- Etapa 2: Fazer a agregação final usando os campos já classificados e com os nomes finais
SELECT
  ano,
  sexo,
  poderes,
  tipologia AS tipo_adm,
  tipologia2 AS tipo_adm_detalhado,
  grupo_instrucao AS grau_instrucao, -- Usa o grupo criado e renomeia para o nome final
  esfera,
  grupo_etario AS faixa_etaria, -- Usa o grupo criado e renomeia para o nome final
  sigla_uf,
  quantidade_horas_contratadas AS carga_horaria,
  tipo_vinculo,
  SUM(quantidade_vinculos) AS quantidade_vinculos
FROM
  dados_classificados
GROUP BY
  ano,
  sexo,
  poderes,
  tipo_adm,
  tipo_adm_detalhado,
  grau_instrucao,
  esfera,
  faixa_etaria,
  sigla_uf,
  carga_horaria,
  tipo_vinculo
ORDER BY
  ano,
  sigla_uf;