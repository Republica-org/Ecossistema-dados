WITH docente_turma AS (

  SELECT 
    id_docente, 
    sexo as sexo_docente, 
    idade as idade_docente, 
    raca_cor as raca_cor_docente,
    escolaridade as escolaridade_docente,
    pos_nenhum,
    mestrado,
    doutorado,
    especializacao, 
    b.* FROM
  `basedosdados.br_inep_censo_escolar.docente`  AS a
  INNER JOIN `basedosdados.br_inep_censo_escolar.turma` AS b 
  ON a.id_turma = b.id_turma and a.ano = b.ano where tipo_docente=1),

numero_prof AS (
  SELECT
    ano,
    sigla_uf,
    id_municipio,
    id_turma,
    CASE 
      WHEN etapa_ensino IN ('4','5','6','7','14','15','16','17','18') THEN '1º segmento EF'
      WHEN etapa_ensino IN ('8','9','10','11','19','20','21','41') THEN '2º segmento EF'
      WHEN etapa_ensino IN ('25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38') THEN 'Ensino Médio'
      ELSE 'Outra etapa'
    END AS etapa_ensino_nome,
    CASE 
      WHEN rede IN ('Federal', 'Municipal', 'Estadual') THEN 'Público'
      ELSE 'Privado'
    END AS publico_privado,    
    rede,
    quantidade_matriculas,
    count(id_docente) as professores,
    CASE 
      WHEN sexo_docente = '1' THEN 'Masculino'
      WHEN sexo_docente = '2' THEN 'Feminino'
      ELSE 'Não identificado'
    END AS sexo_docente,
    CASE 
      WHEN raca_cor_docente = '0' THEN 'Não declarado'
      WHEN raca_cor_docente = '1' THEN 'Branca'
      WHEN raca_cor_docente = '2' THEN 'Preta'
      WHEN raca_cor_docente = '3' THEN 'Parda'
      WHEN raca_cor_docente = '4' THEN 'Amarela'
      WHEN raca_cor_docente = '5' THEN 'Indígena' 
    END AS raca_cor_docente,
    CASE
      WHEN idade_docente <= 14 and idade_docente>= 10 THEN '10 a 14 anos'
      WHEN idade_docente <= 17 and idade_docente>= 15 THEN '15 a 17 anos'
      WHEN idade_docente<= 24 and idade_docente>= 18 THEN '18 a 24 anos'
      WHEN idade_docente<= 29 and idade_docente>= 25 THEN '25 a 29 anos'
      WHEN idade_docente<= 39 and idade_docente>= 30 THEN '30 a 39 anos'
      WHEN idade_docente<= 49 and idade_docente>= 40 THEN '40 a 49 anos'
      WHEN idade_docente<= 64 and idade_docente>= 50 THEN '50 a 64 anos'
      WHEN idade_docente>= 65  THEN '65 anos ou mais'
    END AS faixa_etaria_docente,
  
    
  FROM
    docente_turma
  group by
  1,2,3,4,5,6,7,8,10,11,12)
,total_professores  AS (
SELECT 
    ano,
    sigla_uf,
    id_municipio,
    rede,
    raca_cor_docente,
    faixa_etaria_docente,
    sexo_docente,
    etapa_ensino_nome,
  SUM(quantidade_matriculas) as alunos_soma,
  SUM(professores) as professores_soma

FROM numero_prof 
WHERE etapa_ensino_nome != 'Outra etapa' 
  group by
1,2,3,4,5,6,7,8)
SELECT
  *,
  alunos_soma/professores_soma as media_aluno
FROM total_professores