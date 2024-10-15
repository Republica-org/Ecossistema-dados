  
select 
EXTRACT(YEAR FROM datasiape),idade,ano_ing_spub,esc_cargo,escolaridade,sexo, cor_origem_etnica
FROM 
    `infraestrutura-enap.Ambiente_Pesquisa.Dados_Siape`
WHERE 
    mes in  ("200403","200903","201403","201903", "202403")
    AND grupo_situacao_vinculo = "ATIVO"
    AND situacao_vinculo = "ATIVO PERMANENTE"