SELECT 
  ano,
  esfera,
  quantidade_vinculos
FROM (
  SELECT 
    ano,
    CASE 
      WHEN natureza_juridica IN ('1015','1040', '1074', '1104','1139', '1163', '1252', '1287', '1317', '1341') THEN 'Federal'
      WHEN natureza_juridica IN ('1023','1058', '1082', '1112', '1147', '1171', '1236','1260',  '1295', '1325') THEN 'Estadual'
      WHEN natureza_juridica IN ('1031','1066', '1120', '1155', '1180', '1244', '1279', '1309', '1333') THEN 'Municipal'
      ELSE 'Outros' 
    END AS esfera,
    CASE 
    WHEN natureza_juridica IN ('1015','1023', '1031','1104','1139','1112', '1147','1236','1120', '1155','1180','1341', '1163','1252','1260','1279','1287','1295','1309','1317','1325','1333','1171','1180', '1244', '1341') THEN 'Executivo'-- aqui será adicionada autarquias e fundações de direito público. 
    WHEN natureza_juridica IN ('1040','1058', '1066') THEN 'Legislativo'
    WHEN natureza_juridica IN ('1074','1082') THEN 'Judiciário'
    ELSE 'Outros' 
  END AS poderes,

    COUNT(*) AS quantidade_vinculos
  FROM `basedosdados.br_me_rais.microdados_vinculos`  
  GROUP BY ano, esfera
) subquery
WHERE esfera != 'Outros' and poderes!= 'Outros'
ORDER BY esfera, ano





---116-3 - Órgão Público Autônomo Federal - executivo
--125-2 - Fundação Pública de Direito Privado Federal
--126-0 - Fundação Pública de Direito Privado Estadual ou do Distrito Federal
--127-9 - Fundação Pública de Direito Privado Municipal
--128-7 - Fundo Público da Administração Indireta Federal
--129-5 - Fundo Público da Administração Indireta Estadual ou do Distrito Federal
--130-9 - Fundo Público da Administração Indireta Municipal
--131-7 - Fundo Público da Administração Direta Federal
--132-5 - Fundo Público da Administração Direta Estadual ou do Distrito Federal
--133-3 - Fundo Público da Administração Direta Municipal
--117-1 - Órgão Público Autônomo Estadual ou do Distrito Federal - executivo
--118-0 - Órgão Público Autônomo Municipal - executivo
--124-4 - Município
--134-1 - União 