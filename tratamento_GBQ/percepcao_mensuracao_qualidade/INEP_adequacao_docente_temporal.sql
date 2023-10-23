SELECT sigla_uf,
    id_municipio,
    nome_municipio,
    ano_escolar,
    dependencia_adm,
    per_valor
FROM `repositoriodedadosgpsp.Datalake.INEP_adequacao_formacao_docente`
where docente_grupos = "Grupo 1"
    and ano_escolar in (
        "Ensino Fundamental - Anos Finais",
        "Ensino Fundamental - Anos Iniciais",
        "Ensino Médio"
    )
    and ano = 2022