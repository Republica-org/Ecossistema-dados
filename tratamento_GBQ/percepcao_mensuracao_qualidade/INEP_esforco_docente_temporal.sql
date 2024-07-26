SELECT ano,
    sigla_uf,
    docente_grupos,
    ano_escolar,
    dependencia_adm,
    per_valor as percent
FROM `repositoriodedadosgpsp.Datalake.INEP_esforco_docente`
where ano_escolar in (
        "Ensino Fundamental - Anos Finais",
        "Ensino Fundamental - Anos Iniciais",
        "Ensino Médio"
    )
group by ano,
    sigla_uf,
    ano_escolar,
    localizacao,
    dependencia_adm
order by ano