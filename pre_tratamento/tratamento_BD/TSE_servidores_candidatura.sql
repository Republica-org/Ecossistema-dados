WITH
  servidor_civil_militar AS (
  SELECT
    ano,
    cargo,
    CASE
      WHEN ocupacao IN ('servidor publico civil aposentado', 'servidor da justica eleitoral', 'servidor publico estadual', 'servidor publico municipal', 'servidor publico federal', 'diplomata', 'magistrado', 'membro do ministerio publico', 'ministro do poder judiciario e magistrado', 'membro das forcas armadas', 'policial militar', 'bombeiro militar', 'policial civil', 'militar reformado', 'membros do poder judiciario: ministro de tribunal superior magistrado', 'oficiais das forcas armadas e forcas auxiliares','militar em geral'
      ) THEN 1
      ELSE 0
    END AS servidor,
    CASE
      WHEN ocupacao IN ('servidor publico civil aposentado','servidor da justica eleitoral', 'servidor publico estadual', 'servidor publico municipal', 'servidor publico federal', 'diplomata', 'magistrado', 'membro do ministerio publico', 'ministro do poder judiciario e magistrado', 'servidor da justica eleitoral', 'policial civil','membros do poder judiciario: ministro de tribunal superior magistrado') THEN 'Civil'
      WHEN ocupacao IN ('policial militar',
      'bombeiro militar',
      'militar reformado',
      'membro das forcas armadas',
      'militar em geral',
      'oficiais das forcas armadas e forcas auxiliares') THEN 'Militar'
    ELSE
    'Não é servidor'
  END
    AS tipo_servidor,
    COUNT(*) AS candidatos 

  FROM
    `basedosdados.br_tse_eleicoes.candidatos`
  WHERE
    ano >= 2002
  GROUP BY 
    1,2,3,4
  ORDER BY
    1 )
SELECT
  ano,
  cargo,
  tipo_servidor,
  candidatos
FROM
  servidor_civil_militar
WHERE 
  servidor = 1
ORDER BY 
  1