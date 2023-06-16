SELECT
  a.ano,
  a.sigla_uf,
  a.id_municipio,
  sum(valor) as gasto_executivo,
  pib,
  sum(valor)/pib as custo_executivo_pib

FROM
  `basedosdados.br_me_siconfi.municipio_despesas_funcao` AS a
  INNER JOIN `basedosdados.br_ibge_pib.municipio` as b
  ON a.id_municipio = b.id_municipio and a.ano = b.ano
where 
   conta in (
  'Essencial à Justiça',
  'Administração',
  'Ciência e Tecnologia',
  'Transporte',
  'Urbanismo',
  'Cultura',
  'Comércio e Serviços',
  'Gestão Ambiental',
  'Indústria',
  'Habitação',
  'Organização Agrária',
  'Relações Exteriores',
  'Saúde',
  'Comunicações',
  'Agricultura',
  'Educação',
  'Encargos Especiais',
  'Segurança Pública',
  'Trabalho',
  'Desporto e Lazer',
  'Previdência Social',
  'Saneamento',
  'Assistência Social',
  'Direitos da Cidadania',
  'Energia') and
  estagio = 'Despesas Pagas'
GROUP BY ano,sigla_uf,id_municipio ,pib
ORDER BY ano