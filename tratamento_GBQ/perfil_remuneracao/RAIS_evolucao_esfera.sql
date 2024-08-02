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
    COUNT(*) AS quantidade_vinculos
  FROM `basedosdados.br_me_rais.microdados_vinculos`  
  GROUP BY ano, esfera
) subquery
WHERE esfera != 'Outros'
ORDER BY esfera, ano