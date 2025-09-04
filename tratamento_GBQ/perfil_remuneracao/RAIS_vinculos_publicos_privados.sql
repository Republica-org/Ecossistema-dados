-- Seleciona e agrupa os dados de vínculos públicos
SELECT
  ano,
  sexo,
  poderes,
  CASE
    WHEN grau_instrucao IN ('Analfabeto', 'Até 5.a inc', '5.a completo ', '6.a ao 9.a fund', 'Fund completo', 'Médio incompleto') THEN 'Até Fundamental'
    WHEN grau_instrucao IN ('Médio completo', 'Sup. incompleto') THEN 'Até Ensino Médio'
    WHEN grau_instrucao IN ('Sup. completo') THEN 'Até Ensino Superior Completo'
    WHEN grau_instrucao IN ('Mestrado') THEN 'Até Mestrado'
    WHEN grau_instrucao IN ('Doutorado') THEN 'Até Doutorado'
    ELSE 'Ignorado'
  END AS grau_instrucao,
  esfera,
  sigla_uf,
  "Público" AS flag_publico_privado,
  SUM(quantidade_vinculos) AS quantidade_vinculos
FROM
  `repositoriodedadosgpsp.Datalake.Republica_vinculos_publicos`
GROUP BY
  1, 2, 3, 4, 5, 6, 7  -- Agrupando pela posição das colunas

UNION ALL

-- Seleciona e agrupa os dados de vínculos privados
SELECT
  ano,
  sexo,
  poderes,
  CASE
    WHEN grau_instrucao IN ('Analfabeto', 'Até 5.a inc', '5.a completo ', '6.a ao 9.a fund', 'Fund completo', 'Médio incompleto') THEN 'Até Fundamental'
    WHEN grau_instrucao IN ('Médio completo', 'Sup. incompleto') THEN 'Até Ensino Médio'
    WHEN grau_instrucao IN ('Sup. completo') THEN 'Até Ensino Superior Completo'
    WHEN grau_instrucao IN ('Mestrado') THEN 'Até Mestrado'
    WHEN grau_instrucao IN ('Doutorado') THEN 'Até Doutorado'
    ELSE 'Ignorado'
  END AS grau_instrucao,
  esfera,
  sigla_uf,
  "Privado" AS flag_publico_privado,
  SUM(quantidade_vinculos) AS quantidade_vinculos
FROM
  `repositoriodedadosgpsp.Datalake.RAIS_vinculos_privados`
GROUP BY
  1, 2, 3, 4, 5, 6, 7; -- Agrupando pela posição das colunas