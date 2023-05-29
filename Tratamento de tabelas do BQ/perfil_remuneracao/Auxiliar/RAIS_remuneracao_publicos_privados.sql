SELECT ano, "publico" as flag_publico_privado,

variavel,
categoria, 
media_remuneracao


FROM `repositoriodedadosgpsp.Datalake.RAIS_remuneracao_vinculos_publicos` 




union all

SELECT ano, flag_publico_privado,variavel,
categoria,
media_remuneracao


FROM `repositoriodedadosgpsp.Datalake.RAIS_remuneracao_vinculos_privados` 



  



