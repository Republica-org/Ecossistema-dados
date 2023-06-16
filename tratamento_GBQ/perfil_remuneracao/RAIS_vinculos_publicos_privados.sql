SELECT ano, sexo, poderes, 

 CASE 
    WHEN grau_instrucao in ('Analfabeto','Até 5.a inc', '5.a completo ','6.a ao 9.a fund','Fund completo','Médio incompleto') THEN 'Até Fundamental '
    WHEN grau_instrucao in ('Médio completo','Sup. incompleto') THEN 'Até Ensino Médio'
    WHEN grau_instrucao in ('Sup. completo') THEN 'Até Ensino Superior Completo'
    WHEN grau_instrucao in ('Mestrado') THEN 'Até Mestrado'
    WHEN grau_instrucao in ('Doutorado') THEN 'Até Doutorado'
    ELSE 'Ignorado' 

  END AS grau_instrucao,

esfera, 

sigla_uf,  "publico" as flag_publico_privado, sum(quantidade_vinculos) as quantidade_vinculos

FROM `repositoriodedadosgpsp.Datalake.Republica_vinculos_publicos` 

group by  ano, sexo,poderes, grau_instrucao,esfera,flag_publico_privado, sigla_uf


union all

SELECT ano, sexo, poderes, 

 CASE 
    WHEN grau_instrucao in ('Analfabeto','Até 5.a inc', '5.a completo ','6.a ao 9.a fund','Fund completo','Médio incompleto') THEN 'Até Fundamental '
    WHEN grau_instrucao in ('Médio completo','Sup. incompleto') THEN 'Até Ensino Médio'
    WHEN grau_instrucao in ('Sup. completo') THEN 'Até Ensino Superior Completo'
    WHEN grau_instrucao in ('Mestrado') THEN 'Até Mestrado'
    WHEN grau_instrucao in ('Doutorado') THEN 'Até Doutorado'
    ELSE 'Ignorado' 

  END AS grau_instrucao,

esfera, 

sigla_uf,"privado" as flag_publico_privado, sum(quantidade_vinculos) as quantidade_vinculos

FROM `repositoriodedadosgpsp.Datalake.RAIS_vinculos_privados` 

group by  ano, sexo,poderes, grau_instrucao,esfera,flag_publico_privado, sigla_uf





