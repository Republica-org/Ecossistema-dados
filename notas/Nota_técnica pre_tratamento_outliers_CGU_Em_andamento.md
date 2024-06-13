## Nota técnica sobre tratamento dos dados da CGU

Estamos explorando quais bases de dados tem duplicatas e o porquê. 
Começamos explorando a base de dados de novembro de 2023: ```2023_nov_siape_servidores_cadastro.csv```
Fizemos uma pivot table com a coluna ```TIPO_VINCULO``` e id do servidor para saber, por ID, quantos tipos de vínculos cada servidor possuía. 
A maior parte dos servidores duplicados possuem cargo (98366 de 98400)


- O que é exercício provisório. 

Quanto aos dados de cadastro dos servidores ativos do SIAPE, toda a série história de 2013 até 2023 possuia dados sigilosos. Um exemplo disso é que ao analisar a base ```2013_jan_siape_servidores_cadastro```, vimos um total de 28412 informações sigilosas de um total de 721565 servidores. Desta forma, esses dados sigilosos foram dropados.

### Divergência dos tipos de dados

Ao longo do processo de transferencia dos dados para o Google BigQuery, foram encontradas algumas divergencias quanto ao tipo dos dados. 
Nos dados de cadastro dos servidores ativos do SIAPE, até julho de 2015, os dados das colunas xx estavam como xx, respectivamente. Entre julho de 2015 até junho de 2020, os dados das colunas xx, xx e xx estavam como xx, xx,xx respectivamente.
Entre junho de 2020 e abril de 2023, a coluna 'REFERENCIA_CARGO' não estava sendo aceita pelo Big Query como integer, portanto, os valores foram transformados para String.
A partir de maio de 2023, os dados da mesma coluna foram aceitos no Google BigQuery como Float.
 
TO DO: ANALISAR COLUNAS E DTYPES ABAIXO PRA PREENCHER A INFORMAÇÃO ACIMA


A partir de agosto de 2015, nos conjuntos de dados de cadastro dos servidores do SIAPE apareceu a mensagem de erro: 'could not convert to string'. Portanto, foi usado a opção abaixo no Schema para subir para o Google Big Query:

schema = ([
                    bigquery.SchemaField('Id_SERVIDOR_PORTAL', 'INTEGER', description=''),
                    bigquery.SchemaField('NOME', 'STRING', description=''),
                    bigquery.SchemaField('CPF', 'STRING', description=''),
                    bigquery.SchemaField('MATRICULA', 'STRING', description=''),
                    bigquery.SchemaField('DESCRICAO_CARGO', 'STRING', description=''),
                    bigquery.SchemaField('CLASSE_CARGO', 'STRING', description=''),
                    bigquery.SchemaField('REFERENCIA_CARGO', 'FLOAT', description=''),
                    bigquery.SchemaField('PADRAO_CARGO', 'STRING', description=''),
                    bigquery.SchemaField('NIVEL_CARGO', 'FLOAT', description=''),
                    bigquery.SchemaField('SIGLA_FUNCAO', 'STRING', description=''),
                    bigquery.SchemaField('NIVEL_FUNCAO', 'FLOAT', description=''),
                    bigquery.SchemaField('FUNCAO', 'STRING', description=''),
                    bigquery.SchemaField('CODIGO_ATIVIDADE', 'INTEGER', description=''),
                    bigquery.SchemaField('ATIVIDADE', 'STRING', description=''),
                    bigquery.SchemaField('OPCAO_PARCIAL', 'STRING', description=''),
                    bigquery.SchemaField('COD_UORG_LOTACAO', 'INTEGER', description=''),
                    bigquery.SchemaField('UORG_LOTACAO', 'STRING', description=''),
                    bigquery.SchemaField('COD_ORG_LOTACAO', 'INTEGER', description=''),
                    bigquery.SchemaField('ORG_LOTACAO', 'STRING', description=''),
                    bigquery.SchemaField('COD_ORGSUP_LOTACAO', 'INTEGER', description=''),
                    bigquery.SchemaField('ORGSUP_LOTACAO', 'STRING', description=''),
                    bigquery.SchemaField('COD_UORG_EXERCICIO', 'INTEGER', description=''),
                    bigquery.SchemaField('UORG_EXERCICIO', 'STRING', description=''),
                    bigquery.SchemaField('COD_ORG_EXERCICIO', 'INTEGER', description=''),
                    bigquery.SchemaField('ORG_EXERCICIO', 'STRING', description=''),
                    bigquery.SchemaField('COD_ORGSUP_EXERCICIO', 'INTEGER', description=''),
                    bigquery.SchemaField('ORGSUP_EXERCICIO', 'STRING', description=''),
                    bigquery.SchemaField('COD_TIPO_VINCULO', 'INTEGER', description=''),
                    bigquery.SchemaField('TIPO_VINCULO', 'STRING', description=''),
                    bigquery.SchemaField('SITUACAO_VINCULO', 'STRING', description=''),
                    bigquery.SchemaField('DATA_INICIO_AFASTAMENTO', 'FLOAT', description=''),
                    bigquery.SchemaField('DATA_TERMINO_AFASTAMENTO', 'FLOAT', description=''),
                    bigquery.SchemaField('REGIME_JURIDICO', 'STRING', description=''),
                    bigquery.SchemaField('JORNADA_DE_TRABALHO', 'STRING', description=''),
                    bigquery.SchemaField('DATA_INGRESSO_CARGOFUNCAO', 'STRING', description=''),
                    bigquery.SchemaField('DATA_NOMEACAO_CARGOFUNCAO', 'FLOAT', description=''),
                    bigquery.SchemaField('DATA_INGRESSO_ORGAO', 'STRING', description=''),
                    bigquery.SchemaField('DOCUMENTO_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                    bigquery.SchemaField('DATA_DIPLOMA_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                    bigquery.SchemaField('DIPLOMA_INGRESSO_CARGOFUNCAO', 'FLOAT', description=''),
                    bigquery.SchemaField('DIPLOMA_INGRESSO_ORGAO', 'STRING', description=''),
                    bigquery.SchemaField('DIPLOMA_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                    bigquery.SchemaField('UF_EXERCICIO', 'STRING', description='')
                    ])

A PARTIR DE JUL DE 2020
               acrescentei: df['REFERENCIA_CARGO'] = df['REFERENCIA_CARGO'].astype(str)
               usei o schema abaixo
               schema = [
                    bigquery.SchemaField('Id_SERVIDOR_PORTAL', 'INTEGER', description=''),
                        bigquery.SchemaField('NOME', 'STRING', description=''),
                        bigquery.SchemaField('CPF', 'STRING', description=''),
                        bigquery.SchemaField('MATRICULA', 'STRING', description=''),
                        bigquery.SchemaField('DESCRICAO_CARGO', 'STRING', description=''),
                        bigquery.SchemaField('CLASSE_CARGO', 'STRING', description=''),
                        bigquery.SchemaField('REFERENCIA_CARGO', 'STRING', description=''),
                        bigquery.SchemaField('PADRAO_CARGO', 'STRING', description=''),
                        bigquery.SchemaField('NIVEL_CARGO', 'FLOAT', description=''),
                        bigquery.SchemaField('SIGLA_FUNCAO', 'STRING', description=''),
                        bigquery.SchemaField('NIVEL_FUNCAO', 'INTEGER', description=''),
                        bigquery.SchemaField('FUNCAO', 'STRING', description=''),
                        bigquery.SchemaField('CODIGO_ATIVIDADE', 'INTEGER', description=''),
                        bigquery.SchemaField('ATIVIDADE', 'STRING', description=''),
                        bigquery.SchemaField('OPCAO_PARCIAL', 'STRING', description=''),
                        bigquery.SchemaField('COD_UORG_LOTACAO', 'INTEGER', description=''),
                        bigquery.SchemaField('UORG_LOTACAO', 'STRING', description=''),
                        bigquery.SchemaField('COD_ORG_LOTACAO', 'INTEGER', description=''),
                        bigquery.SchemaField('ORG_LOTACAO', 'STRING', description=''),
                        bigquery.SchemaField('COD_ORGSUP_LOTACAO', 'INTEGER', description=''),
                        bigquery.SchemaField('ORGSUP_LOTACAO', 'STRING', description=''),
                        bigquery.SchemaField('COD_UORG_EXERCICIO', 'INTEGER', description=''),
                        bigquery.SchemaField('UORG_EXERCICIO', 'STRING', description=''),
                        bigquery.SchemaField('COD_ORG_EXERCICIO', 'INTEGER', description=''),
                        bigquery.SchemaField('ORG_EXERCICIO', 'STRING', description=''),
                        bigquery.SchemaField('COD_ORGSUP_EXERCICIO', 'INTEGER', description=''),
                        bigquery.SchemaField('ORGSUP_EXERCICIO', 'STRING', description=''),
                        bigquery.SchemaField('COD_TIPO_VINCULO', 'INTEGER', description=''),
                        bigquery.SchemaField('TIPO_VINCULO', 'STRING', description=''),
                        bigquery.SchemaField('SITUACAO_VINCULO', 'STRING', description=''),
                        bigquery.SchemaField('DATA_INICIO_AFASTAMENTO', 'FLOAT', description=''),
                        bigquery.SchemaField('DATA_TERMINO_AFASTAMENTO', 'FLOAT', description=''),
                        bigquery.SchemaField('REGIME_JURIDICO', 'STRING', description=''),
                        bigquery.SchemaField('JORNADA_DE_TRABALHO', 'STRING', description=''),
                        bigquery.SchemaField('DATA_INGRESSO_CARGOFUNCAO', 'STRING', description=''),
                        bigquery.SchemaField('DATA_NOMEACAO_CARGOFUNCAO', 'FLOAT', description=''),
                        bigquery.SchemaField('DATA_INGRESSO_ORGAO', 'STRING', description=''),
                        bigquery.SchemaField('DOCUMENTO_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                        bigquery.SchemaField('DATA_DIPLOMA_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                        bigquery.SchemaField('DIPLOMA_INGRESSO_CARGOFUNCAO', 'FLOAT', description=''),
                        bigquery.SchemaField('DIPLOMA_INGRESSO_ORGAO', 'STRING', description=''),
                        bigquery.SchemaField('DIPLOMA_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                        bigquery.SchemaField('UF_EXERCICIO', 'STRING', description=''),
                        bigquery.SchemaField('ANO', 'INTEGER', description=''),
                        bigquery.SchemaField('MES', 'INTEGER', description='')

A PARTIR DE MAIO DE 2023 
schema = [
                    bigquery.SchemaField('Id_SERVIDOR_PORTAL', 'INTEGER', description=''),
                        bigquery.SchemaField('NOME', 'STRING', description=''),
                        bigquery.SchemaField('CPF', 'STRING', description=''),
                        bigquery.SchemaField('MATRICULA', 'STRING', description=''),
                        bigquery.SchemaField('DESCRICAO_CARGO', 'STRING', description=''),
                        bigquery.SchemaField('CLASSE_CARGO', 'STRING', description=''),
                        bigquery.SchemaField('REFERENCIA_CARGO', 'FLOAT', description=''),
                        bigquery.SchemaField('PADRAO_CARGO', 'STRING', description=''),
                        bigquery.SchemaField('NIVEL_CARGO', 'FLOAT', description=''),
                        bigquery.SchemaField('SIGLA_FUNCAO', 'STRING', description=''),
                        bigquery.SchemaField('NIVEL_FUNCAO', 'FLOAT', description=''),
                        bigquery.SchemaField('FUNCAO', 'STRING', description=''),
                        bigquery.SchemaField('CODIGO_ATIVIDADE', 'INTEGER', description=''),
                        bigquery.SchemaField('ATIVIDADE', 'STRING', description=''),
                        bigquery.SchemaField('OPCAO_PARCIAL', 'STRING', description=''),
                        bigquery.SchemaField('COD_UORG_LOTACAO', 'INTEGER', description=''),
                        bigquery.SchemaField('UORG_LOTACAO', 'STRING', description=''),
                        bigquery.SchemaField('COD_ORG_LOTACAO', 'INTEGER', description=''),
                        bigquery.SchemaField('ORG_LOTACAO', 'STRING', description=''),
                        bigquery.SchemaField('COD_ORGSUP_LOTACAO', 'INTEGER', description=''),
                        bigquery.SchemaField('ORGSUP_LOTACAO', 'STRING', description=''),
                        bigquery.SchemaField('COD_UORG_EXERCICIO', 'INTEGER', description=''),
                        bigquery.SchemaField('UORG_EXERCICIO', 'STRING', description=''),
                        bigquery.SchemaField('COD_ORG_EXERCICIO', 'INTEGER', description=''),
                        bigquery.SchemaField('ORG_EXERCICIO', 'STRING', description=''),
                        bigquery.SchemaField('COD_ORGSUP_EXERCICIO', 'INTEGER', description=''),
                        bigquery.SchemaField('ORGSUP_EXERCICIO', 'STRING', description=''),
                        bigquery.SchemaField('COD_TIPO_VINCULO', 'INTEGER', description=''),
                        bigquery.SchemaField('TIPO_VINCULO', 'STRING', description=''),
                        bigquery.SchemaField('SITUACAO_VINCULO', 'STRING', description=''),
                        bigquery.SchemaField('DATA_INICIO_AFASTAMENTO', 'FLOAT', description=''),
                        bigquery.SchemaField('DATA_TERMINO_AFASTAMENTO', 'FLOAT', description=''),
                        bigquery.SchemaField('REGIME_JURIDICO', 'STRING', description=''),
                        bigquery.SchemaField('JORNADA_DE_TRABALHO', 'STRING', description=''),
                        bigquery.SchemaField('DATA_INGRESSO_CARGOFUNCAO', 'STRING', description=''),
                        bigquery.SchemaField('DATA_NOMEACAO_CARGOFUNCAO', 'FLOAT', description=''),
                        bigquery.SchemaField('DATA_INGRESSO_ORGAO', 'STRING', description=''),
                        bigquery.SchemaField('DOCUMENTO_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                        bigquery.SchemaField('DATA_DIPLOMA_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                        bigquery.SchemaField('DIPLOMA_INGRESSO_CARGOFUNCAO', 'FLOAT', description=''),
                        bigquery.SchemaField('DIPLOMA_INGRESSO_ORGAO', 'STRING', description=''),
                        bigquery.SchemaField('DIPLOMA_INGRESSO_SERVICOPUBLICO', 'STRING', description=''),
                        bigquery.SchemaField('UF_EXERCICIO', 'INTEGER', description=''),
                        bigquery.SchemaField('ANO', 'INTEGER', description=''),
                        bigquery.SchemaField('MES', 'INTEGER', description='')
                ]

SOBRE BACEN ATIVOS CADASTRO:
A partir de maio de 2022, houveram divergencias quanto ao tipo de de dados. até maio, o schema usado foi:

*inserir schema*
após essa data, foi usado o schema:
*inserir schema*

O erro 'ArrowInvalid: Could not convert '000000000' with type str: tried to convert to int64' aparece partir de maio de 2022 e foi identificado que coluna 'DOCUMENTO_INGRESSO_SERVICOPUBLICO', que estava como INTEGER possui 2 valores como '00DECRETO', que foram mudados para '000000000' e converti toda a coluna para integer.

Outro erro é em agosto de 2023: 'ArrowTypeError: Expected a string or bytes dtype, got int64.'

UF_EXERCICIO está como integer a partir de agosto de 2023

Até o dia 06/05/2024, os dados de 2024 contém: 
- janeiro: aposentados (bacen, siape, militares reserva-reforma), pensionistas (bacen, siape, militares), ativos (bacen, siape, militares)
- fevereiro: aposentados (bacen, siape, militares reserva-reforma), pensionistas (bacen, siape, militares), ativos (bacen, siape, militares)
- março: aposentados (siape), pensionistas (siape), ativos (siape)