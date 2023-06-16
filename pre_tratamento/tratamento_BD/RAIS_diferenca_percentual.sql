WITH tabela_publico AS (


SELECT 
  ano, 
  nome_regiao,
  sigla_uf,
  poderes,
  esfera,
  sexo,
  raca,
  grau_instrucao,
  SUM(remuneracao_media_sm*quantidade_vinculos)/ SUM(quantidade_vinculos) AS remuneracao_media_publica,
  SUM(quantidade_vinculos) AS vinculo_publico


FROM basedosdados-projetos.republica.remuneracao_vinculo_publico


GROUP BY 
  ano, 
  sigla_uf, 
  poderes,
  esfera, 
  sexo, 
  raca,
  grau_instrucao,
  nome_regiao
  ),



tabela_privado AS (


SELECT 
  ano, 
  sigla_uf,
  nome_regiao,
  poderes,
  esfera,
  sexo,
  raca,
  grau_instrucao,
  SUM(remuneracao_media_sm*quantidade_vinculos)/ SUM(quantidade_vinculos) AS remuneracao_media_privada,
  SUM(quantidade_vinculos) AS vinculo_privado


FROM basedosdados-projetos.republica.remuneracao_vinculo_privado


GROUP BY 
  ano, 
  nome_regiao,
  sigla_uf, 
  poderes,
  esfera, 
  sexo, 
  raca, 
  grau_instrucao
  )

SELECT a.*, 
  b.remuneracao_media_privada, 
  b.vinculo_privado,
  100*(a.remuneracao_media_publica-b.remuneracao_media_privada) / b.remuneracao_media_privada as diff_percentual
  FROM tabela_publico  AS a
      INNER JOIN tabela_privado AS b 
        ON a.ano = b.ano 
        AND a.sigla_uf = b.sigla_uf 
        AND a.raca = b.raca
        AND a.sexo = b.sexo
        AND a.grau_instrucao = b.grau_instrucao
        AND a.nome_regiao = b.nome_regiao
  
