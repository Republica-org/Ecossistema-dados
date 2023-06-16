SELECT
  a.ano,
  a.sigla_uf,
  sum(valor) as gasto_executivo,
  pib,
  sum(valor)/pib as custo_executivo_pib

FROM
  `basedosdados-dev.br_me_siconfi.uf_despesas_funcao` AS a
  INNER JOIN `basedosdados-dev.br_ibge_pib.uf` as b
  ON a.sigla_uf = b.sigla_uf and a.ano = b.ano
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
GROUP BY ano,sigla_uf, pib
ORDER BY ano