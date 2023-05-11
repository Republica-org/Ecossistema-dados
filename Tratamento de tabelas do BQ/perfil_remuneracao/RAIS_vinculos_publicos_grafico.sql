SELECT ano, sexo, poderes, 

 CASE 
    WHEN grau_instrucao in ('Analfabeto','Até 5.a inc', '5.a completo ','6.a ao 9.a fund','Fund completo','Médio incompleto') THEN 'Até Fundamental '
    WHEN grau_instrucao in ('Médio completo','Sup. incompleto') THEN 'Até Ensino Médio'
    WHEN grau_instrucao in ('Sup. completo') THEN 'Até Ensino Superior Completo'
    WHEN grau_instrucao in ('Mestrado','Doutorado') THEN 'Até Pós Graduação'
    ELSE 'Ignorado' 

  END AS grau_instrucao,

esfera, 

Case 
  WHEN faixa_etaria in ('18 a 24 anos','25 a 29 anos') then 'Entre 18 e 29 anos'
  WHEN faixa_etaria in ('30 a 39 anos','40 a 49 anos') then 'Entre 30 e 49 anos'
  WHEN faixa_etaria in ('50 a 64 anos') then 'Entre 50 e 65 anos'
  WHEN faixa_etaria in ('65 anos ou mais') then 'Acima de 65 anos'
  ELSE 'Ignorado' end as faixa_etaria, sigla_uf,carga_horaria,tipo_vinculo, sum(quantidade_vinculos) as quantidade_vinculos

FROM `repositoriodedadosgpsp.Datalake.Republica_vinculos_publicos` 

group by  ano, sexo,poderes, grau_instrucao,esfera,faixa_etaria, sigla_uf,carga_horaria,tipo_vinculo




