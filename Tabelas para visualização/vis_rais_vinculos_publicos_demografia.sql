SELECT ano,
sigla_uf,
    sexo,
    grau_instrucao,
    poderes,
    esfera,
    faixa_etaria,
    sum(quantidade_vinculos) as quantidade_vinculos
FROM `basedosdados-projetos.republica.vinculo_publico`
group by 

    ano,
    sigla_uf,
    sexo,
    grau_instrucao,
    poderes,
    esfera,
    faixa_etaria