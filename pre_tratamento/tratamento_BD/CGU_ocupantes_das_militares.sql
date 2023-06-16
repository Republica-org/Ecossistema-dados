SELECT
  *,
  ocupante_das_nivel_1_3/(ocupante_das_nivel_1_3+ocupante_das_nivel_4+ocupante_das_nivel_5+ocupante_das_nivel_6)*100 AS per_nivel_1_3,
  ocupante_das_nivel_4/(ocupante_das_nivel_1_3+ocupante_das_nivel_4+ocupante_das_nivel_5+ocupante_das_nivel_6)*100 AS per_nivel_4,
  ocupante_das_nivel_5/(ocupante_das_nivel_1_3+ocupante_das_nivel_4+ocupante_das_nivel_5+ocupante_das_nivel_6)*100 AS per_nivel_5,
  ocupante_das_nivel_6/(ocupante_das_nivel_1_3+ocupante_das_nivel_4+ocupante_das_nivel_5+ocupante_das_nivel_6)*100 AS per_nivel_6
FROM
  `basedosdados-dev.br_me_siape.ocupantes_das_militares`