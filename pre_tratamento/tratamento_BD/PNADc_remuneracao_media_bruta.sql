WITH
  trabalho AS (
 SELECT
    ano,
    trimestre,
    VD4016 as remuneracao_bruta,
    CASE
      WHEN V4010 >= '1111' AND V4010 <= '1439' THEN 'Diretores e gerentes'
      WHEN V4010 >= '2111' AND V4010 <= '2659' THEN 'Profissionais das ciências e intelectuais'
      WHEN V4010 >= '3111' AND V4010 <= '3522' THEN 'Técnicos e profissionais de nível médio'
      WHEN V4010 >= '4110' AND V4010 <= '4419' THEN 'Trabalhadores de apoio administrativo'
      WHEN V4010 >= '5111' AND V4010 <= '5419' THEN 'Trabalhadores dos serviços, vendedores dos comércios e mercados'
      WHEN V4010 >= '6111' AND V4010 <= '6225' THEN 'Trabalhadores qualificados da agropecuária,florestais, da caça e da pesca'
      WHEN V4010 >= '7111' AND V4010 <= '7549' THEN 'Trabalhadores qualificados, operários e artesões da construção, das artes mecânicas e outros ofícios'
      WHEN V4010 >= '8111' AND  V4010 <= '8350' THEN 'Operadores de instalações e máquinas e montadores'
      WHEN V4010 >= '9111' AND  V4010 <= '9629' THEN 'Ocupações elementares'
      WHEN V4010 >= '110' AND  V4010 <= '512' THEN 'Membros das forças armadas, policiais e bombeiros militares'
      WHEN V4010 < '1' THEN 'Ocupações maldefinidas'
      WHEN V4010 IS NULL THEN 'Não respondeu'
  END
    AS ocupacao,

    CASE
      WHEN V4012 = '1' THEN 'Trabalhador doméstico'
      WHEN V4012 = '2' THEN 'Militar'
      WHEN V4012 = '3' THEN 'Empregado do setor privado'
      WHEN V4012 = '4' THEN 'Empregado do setor público'
      WHEN V4012 = '5' THEN 'Empregador'
      WHEN V4012 = '6' THEN 'Conta própria'
      WHEN V4012 = '7' THEN 'Trabalhador familiar não remunerado'
    ELSE
    'Não aplicável'
  END
    AS tipo_trabalho,
    CASE
      WHEN V4012 IN ('1', '3', '5', '6', '7') THEN "Privado"
      WHEN V4012 IN ('2', '4') THEN "Público"
  END
    AS setor,
  FROM
    `basedosdados.br_ibge_pnadc.microdados`
  where
    V4010 != 'Não aplicável' and trimestre = 4 
  ORDER BY
    1 )
SELECT
  ano,
  ocupacao,
  setor,
  AVG(remuneracao_bruta) as media_salario_bruto,
  COUNT(*) AS populacao
FROM
  trabalho
WHERE
  tipo_trabalho != 'Não aplicável' and trimestre = 4
GROUP BY 
  1,2,3
ORDER BY
  1