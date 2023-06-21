-- Criando tabela de docentes a partir de correção do script anterios presente em: https://github.com/Republica-org/Ecossistema-dados/blob/main/Pr%C3%A9-tratamento/Tratamento%20de%20tabelas%20BD/INEP_total_professores_contratacao.sql


SELECT
  ano,
  sigla_uf,
  id_municipio,
  id_docente,
  id_escola,
  count (id_docente) AS quantidade_vinculo_id_docente,
  CASE 
    WHEN tipo_contratacao = '1' THEN 'Concursado/efetivo/estável'
    WHEN tipo_contratacao = '2' THEN 'Contrato temporário'
    WHEN tipo_contratacao = '3' THEN 'Contrato terceirizado'
    WHEN tipo_contratacao = '4' THEN 'Contrato CLT'        
    ELSE 'Não identificado'
  END AS tipo_contratacao,
  CASE 
    WHEN sexo = '1' THEN 'Masculino'
    WHEN sexo = '2' THEN 'Feminino'
    ELSE 'Não identificado'
  END AS sexo,
  CASE 
    WHEN raca_cor = '0' THEN 'Não declarado'
    WHEN raca_cor = '1' THEN 'Branca'
    WHEN raca_cor = '2' THEN 'Preta'
    WHEN raca_cor = '3' THEN 'Parda'
    WHEN raca_cor = '4' THEN 'Amarela'
    WHEN raca_cor = '5' THEN 'Indígena' 
  END AS raca_cor,
  CASE 
    WHEN ano <= 2010 THEN (
      CASE
        WHEN escolaridade = '1' THEN 'Fundamental Incompleto'
        WHEN escolaridade = '2' THEN 'Fundamental Completo'
        WHEN escolaridade = '3' THEN 'Ensino Médio - Normal/Magistério'
        WHEN escolaridade = '4' THEN 'Ensino Médio - Normal/Magistério Específico Indígena'
        WHEN escolaridade = '5' THEN 'Ensino Médio' 
        WHEN escolaridade = '6' THEN  
                                  CASE 
                                    WHEN pos_nenhum = 1 then 'Ensino Superior Completo'
                                    WHEN pos_nenhum = 0 then
                                          case
                                            when mestrado = 1 then 'Pós-Graduação - Mestrado'
                                            when doutorado = 1 then 'Pós-Graduação - Doutorado'
                                            when especializacao = 1 then 'Pós-Graduação - Especialização'
                                            else "Ensino Superior Completo"
                                          end
                                    ELSE "Ensino Superior Completo"
                                  END 
      END)
    WHEN ano > 2010 and ano <= 2014 THEN (
      CASE
        WHEN escolaridade = '1' THEN 'Fundamental Incompleto'
        WHEN escolaridade = '2' THEN 'Fundamental Completo'
        WHEN escolaridade = '3' THEN 'Ensino Médio - Normal/Magistério'
        WHEN escolaridade = '4' THEN 'Ensino Médio - Normal/Magistério Específico Indígena'
        WHEN escolaridade = '5' THEN 'Ensino Médio' 
        WHEN escolaridade = '6' THEN  
                                  CASE 
                                    WHEN pos_nenhum = 1 then 'Ensino Superior (Concluído ou em Andamento)'
                                    WHEN pos_nenhum = 0 then
                                          case
                                            when mestrado = 1 then 'Pós-Graduação - Mestrado'
                                            when doutorado = 1 then 'Pós-Graduação - Doutorado'
                                            when especializacao = 1 then 'Pós-Graduação - Especialização'
                                            else "Ensino Superior (Concluído ou em Andamento)"
                                          end
                                    ELSE "Ensino Superior (Concluído ou em Andamento)"
                                  END 
      END)
    WHEN ano >= 2015 THEN(
      CASE
        WHEN escolaridade = '1' THEN 'Fundamental Incompleto'
        WHEN escolaridade = '2' THEN 'Fundamental Completo'
        WHEN escolaridade = '3' THEN 'Ensino Médio Completo'
        WHEN escolaridade = '4' THEN  
                                  CASE 
                                    WHEN pos_nenhum = 1 then 'Ensino Superior Completo'
                                    WHEN pos_nenhum = 0 then
                                          case
                                            when mestrado = 1 then 'Pós-Graduação - Mestrado'
                                            when doutorado = 1 then 'Pós-Graduação - Doutorado'
                                            when especializacao = 1 then 'Pós-Graduação - Especialização'
                                            else "Ensino Superior Completo"
                                          end
                                    ELSE 'Ensino Superior Completo'
                                  END 
      END)
  END AS escolaridade,
  idade,
  CASE
    WHEN idade <= 14 and idade >= 10 THEN '10 a 14 anos'
    WHEN idade <= 17 and idade >= 15 THEN '15 a 17 anos'
    WHEN idade <= 24 and idade >= 18 THEN '18 a 24 anos'
    WHEN idade <= 29 and idade >= 25 THEN '25 a 29 anos'
    WHEN idade <= 39 and idade >= 30 THEN '30 a 39 anos'
    WHEN idade <= 49 and idade >= 40 THEN '40 a 49 anos'
    WHEN idade <= 64 and idade >= 50 THEN '50 a 64 anos'
    WHEN idade >= 65  THEN '65 anos ou mais'
  END AS faixa_etaria,
  CASE 
    WHEN (necessidade_especial = 1 or
          surdez =1 or 
          deficiencia_fisica = 1 )
      THEN 'Sim'
    WHEN (necessidade_especial is null and
          surdez is null and 
          deficiencia_fisica is null )
      THEN 'Não identificado'
    ELSE 'Não'
  END AS portador_deficiencia,
  CASE 
    WHEN rede IN ('federal', 'municipal', 'estadual') THEN 'Público'
    ELSE 'Privado'
  END AS publico_privado,
  rede
FROM
  `basedosdados.br_inep_censo_escolar.docente`

WHERE tipo_docente = 1
GROUP BY 
  1,2,3,4,5,7,8,9,10,11,12,13,14,15
ORDER BY
  1
