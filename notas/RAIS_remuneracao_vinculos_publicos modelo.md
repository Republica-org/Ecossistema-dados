
<br> 
A RAIS consultada aqui é a não identificada tratada originalmente pela Base dos Dados e disponibilizada em seu datalake.

<br>


<details>
  <summary><b> 1º passo:</b> Consulta ao GBQ da Base dos Dados: </summary>


<br>

``` sql
-- Estou unindo alguns agrupamentos para fazer a média da remuneração. 

SELECT 
  ano,
  "poderes" as variavel,

  CASE 

    WHEN natureza_juridica IN ('1015','1023', '1031') THEN 'Executivo'
    WHEN natureza_juridica IN ('1040','1058', '1066') THEN 'Legislativo'
    WHEN natureza_juridica IN ('1074','1082') THEN 'Judiciário'
    ELSE 'Outros' 

  END AS categoria,


  AVG(valor_remuneracao_media) AS media_remuneracao

FROM `basedosdados.br_me_rais.microdados_vinculos`
WHERE (natureza_juridica LIKE "1%" 
OR natureza_juridica IN ('2011', '2038'))
AND natureza_juridica != '1228'
AND cbo_2002 NOT LIKE "0%" 
AND vinculo_ativo_3112 = 1

GROUP BY 

  ano,
  variavel,
  categoria

  union all

  SELECT 
  ano,
  "genero" as variavel,

   CASE 
    WHEN sexo = '1' THEN 'Masculino'
    WHEN sexo = '2' THEN 'Feminino'
    ELSE 'Não identificado'

  END AS categoria,


  AVG(valor_remuneracao_media) AS media_remuneracao

FROM `basedosdados.br_me_rais.microdados_vinculos`
WHERE (natureza_juridica LIKE "1%" 
OR natureza_juridica IN ('2011', '2038'))
AND natureza_juridica != '1228'
AND cbo_2002 NOT LIKE "0%" 
AND vinculo_ativo_3112 = 1

GROUP BY 

  ano,
  variavel,
  categoria

  union all

  
  SELECT 
  ano,
  "grau_instrucao" as variavel,


    CASE 
    WHEN ano >= 2006 THEN (CASE 
      WHEN grau_instrucao_apos_2005 in ('1','2','3','4','5','6') THEN 'Até Fundamental'
      WHEN grau_instrucao_apos_2005 in ('7','8') THEN  'Até Ensino Médio'
      WHEN grau_instrucao_apos_2005 = '9' THEN  'Até Ensino Superior Completo'
      WHEN grau_instrucao_apos_2005 = '10' THEN  'Até Mestrado'
      WHEN grau_instrucao_apos_2005 = '11' THEN  'Até Doutorado'
      ELSE 'Ignorado'
    END )

    WHEN ano < 2006 THEN ( CASE 
    WHEN grau_instrucao_1985_2005 in ('1','2','3','4','5','6') THEN 'Analfabeto'
    WHEN grau_instrucao_1985_2005 in ('7','8') THEN  'Até Ensino Médio'
    WHEN grau_instrucao_1985_2005 = '9' THEN  'Até Ensino Superior Completo'
    WHEN grau_instrucao_1985_2005 = '10' THEN  'Até Mestrado'
    WHEN grau_instrucao_1985_2005 = '11' THEN  'Até Doutorado'
    ELSE 'Ignorado'
  END)
  END AS categoria,

  AVG(valor_remuneracao_media) AS media_remuneracao

FROM `basedosdados.br_me_rais.microdados_vinculos`
WHERE (natureza_juridica LIKE "1%" 
OR natureza_juridica IN ('2011', '2038'))
AND natureza_juridica != '1228'
AND cbo_2002 NOT LIKE "0%" 
AND vinculo_ativo_3112 = 1

GROUP BY 

  ano,
  variavel,
  categoria

  union all

  
  SELECT 
  ano,
  "nivel_governo" as variavel,

  CASE 
    WHEN natureza_juridica IN ('1015','1040', '1074', '1104','1139', '1163', '1252', '1287', '1317', '1341') THEN 'Federal'
    WHEN natureza_juridica IN ('1023','1058', '1082', '1112', '1147', '1171', '1236','1260',  '1295', '1325') THEN 'Estadual'
    WHEN natureza_juridica IN ('1031','1066', '1120', '1155', '1180', '1244', '1279', '1309', '1333') THEN 'Municipal'
    ELSE 'Outros' 
  END AS categoria,


  AVG(valor_remuneracao_media) AS media_remuneracao

FROM `basedosdados.br_me_rais.microdados_vinculos`
WHERE (natureza_juridica LIKE "1%" 
OR natureza_juridica IN ('2011', '2038'))
AND natureza_juridica != '1228'
AND cbo_2002 NOT LIKE "0%" 
AND vinculo_ativo_3112 = 1

GROUP BY 

  ano,
  variavel,
  categoria

  union all

  
  SELECT 
  ano,
  "tipo_vinculo" as variavel,

  CASE 
    WHEN tipo_vinculo = '10' THEN 'CLT'
    WHEN tipo_vinculo = '15' THEN 'CLT'
    WHEN tipo_vinculo = '20' THEN 'CLT/Rural'
    WHEN tipo_vinculo = '25' THEN 'CLT/Rural'
    WHEN tipo_vinculo = '30' THEN 'Estatutário'
    WHEN tipo_vinculo = '31' THEN 'Estatutário'
    WHEN tipo_vinculo = '35' THEN 'Estatutário não efetivo'
    WHEN tipo_vinculo = '40' THEN 'Avulso'
    WHEN tipo_vinculo = '50' THEN 'Temporário'
    WHEN tipo_vinculo = '55' THEN 'Aprendiz contratado'
    WHEN tipo_vinculo = '60' THEN 'CLT'
    WHEN tipo_vinculo = '65' THEN 'CLT'
    WHEN tipo_vinculo = '70' THEN 'CLT'
    WHEN tipo_vinculo = '75' THEN 'CLT'
    WHEN tipo_vinculo = '80' THEN 'Diretor'
    WHEN tipo_vinculo = '90' THEN 'Contratado/prazo determinado'
    WHEN tipo_vinculo = '95' THEN 'Contratado/tempo determinado'
    WHEN tipo_vinculo = '96' THEN 'Contratado/tempo determinado'
    WHEN tipo_vinculo = '97' THEN 'Contratado/tempo determinado'
    ELSE 'Ignorado' 
  END AS categoria,



  AVG(valor_remuneracao_media) AS media_remuneracao

FROM `basedosdados.br_me_rais.microdados_vinculos`
WHERE (natureza_juridica LIKE "1%" 
OR natureza_juridica IN ('2011', '2038'))
AND natureza_juridica != '1228'
AND cbo_2002 NOT LIKE "0%" 
AND vinculo_ativo_3112 = 1

GROUP BY 

  ano,
  variavel,
  categoria

```
</details>

<details>
  <summary><b> 2º passo:</b> Tratamento e subir no GBQ da República.org:</summary>


``` python
#!/usr/bin/env python
# coding: utf-8

# In[1]:


import openpyxl
import pandas as pd
import time
import os
import pandas_gbq
from google.cloud import bigquery
import glob
import basedosdados as bd
import numpy as np


# In[2]:


## Acessando pelo pacote da BD

df=bd.read_sql("SELECT * FROM `repositoriodedadosgpsp.Datalake.RAIS_remuneracao_vinculos_publicos`", billing_project_id="repositoriodedadosgpsp", from_file=False, reauth=False, use_bqstorage_api=False)


# In[3]:


df['ano'].unique()

## tenho de 2004 a 2021:


# In[4]:


### Criando função para deflacionar a variável de remuneração
### Vou me basear no IPCA acumulado de dezembro de 2022 para realização do cálculo

## adicionar coluna de fator de correção pra cada ano
## depois faz a conta

os.chdir("G:\\Drives compartilhados\\República.org\\4. Equipes\\Dados e Comunicação\DADOS\\415 - Repositório de Dados\\Documentos auxiliares")


# In[5]:


ipca = pd.read_csv("ipca.csv",sep=";",decimal=",")


# In[21]:


ipca.info()


# In[22]:


df1= df.merge(ipca[['Ano','Fator de correcao']], right_on='Ano',left_on='ano')

# In[23]:


df1['media_remuneracao_ajustada']= df1['media_remuneracao']* df1['Fator de correcao']


# In[24]:


## Subindo para datalake
client = bigquery.Client()
dataset_ref = client.dataset('perfil_remuneracao')


# In[25]:


df1 = df1[['ano', 'variavel', 'categoria', 'media_remuneracao',
       'Fator de correcao', 'media_remuneracao_ajustada']]


# In[26]:


df1=df1.rename(columns={'Fator de correcao':'fator_correcao'})


# In[27]:


schema=[bigquery.SchemaField('ano','INTEGER',description='Ano de referência'),
 bigquery.SchemaField('variavel','STRING',description='De qual variável aquela remuneração se refere'),
 bigquery.SchemaField('categoria','STRING',description='Categoria dentro daquela variável'),
 bigquery.SchemaField('media_remuneracao','FLOAT',description='Valor nominal da média de remuneração daquele ano'),
bigquery.SchemaField('fator_correcao','FLOAT',description='índice para correção monetária baseando-se no IPCA para dezembro de 2022'),
bigquery.SchemaField('media_remuneracao_ajustada','FLOAT',description='Valor nominal da média de remuneração daquele ano ajustado para dezembro de 2022')
 ]


# In[28]:


client.delete_table('perfil_remuneracao.RAIS_remuneracao_vinculos_publicos', not_found_ok=True)


# In[29]:


table_ref = dataset_ref.table('RAIS_remuneracao_vinculos_publicos')
job_config = bigquery.LoadJobConfig(schema=schema)
job = client.load_table_from_dataframe(df1, table_ref, job_config=job_config)
job.result() 




```


