# Nota técnica sobre os dados da CBO

Na fase de tratamento para o Google Big Query, foi feito uma junção com base na coluna 'codigo' entre os dados tratados pela Base dos Dados e os dados da CBO (que pode ser encontrado em: http://www.mtecbo.gov.br/cbosite/pages/downloads.jsf). 

Antes dessa junção, foi feito uma nova classificação nos grandes grupos com o intuito de realocar algumas profissões. 
A classificação oficial dos grandes grupos da CBO contém: 
 - Membros Das Forças Armadas, Policiais E Bombeiros Militares
 - Membros Superiores Do Poder Público, Dirigentes De Organizações De Interesse Público E De Empresas, Gerentes
 - Profissionais De Ciência e Das Artes
 - Técnicos De Nível Médio
 - Trabalhadores De Serviços Administrativos
 - Trabalhadores Dos Serviços, Vendedores Do Comércio Em Lojas E Mercados
 - Trabalhadores Agropecuários, Florestais E Da Pesca
 - Trabalhadores Da Produção De Bens E Serviços Industriais
 - Trabalhadores Da Produção De Bens E Serviços Industriais
 - Trabalhadores Em Serviços De Reparação E Manutenção

A reclassificação feita contém as seguintes categorias:
 - Membros Das Forças Armadas, Policiais E Bombeiros Militares
 - Membros Superiores Do Poder Público, Dirigentes De Organizações De Interesse Público E De Empresas, Gerentes
 - Profissionais De Medicina, Enfermagem E Serviços Da Saúde (Novo)
 - Profissionais De Ciência De Ensino Superior (Novo)
 - Profissionais De Ensino (Novo)
 - Profissionais De Artes De Ensino Superior (Novo)
 - Técnicos De Nível Médio
 - Trabalhadores De Serviços Administrativos
 - Trabalhadores Dos Serviços, Vendedores Do Comércio Em Lojas E Mercados
 - Trabalhadores Nos Serviços De Proteção E Segurança (Novo)
 - Trabalhadores Agropecuários, Florestais E Da Pesca
 - Trabalhadores Da Produção De Bens E Serviços Industriais
 - Trabalhadores Em Serviços De Reparação E Manutenção

Os grupos Profissionais De Medicina, Enfermagem E Serviços Da Saúde, Profissionais De Ciência De Ensino Superior, Profissionais De Ensino e Profissionais De Artes De Ensino Superior são derivados de Profissionais De Ciência e Das Artes visto que essa categoria oficial engloba  muitas carreiras distintas. Ainda em Profissionais De Medicina, Enfermagem E Serviços Da Saúde foram incluídas algumas profissões que constavam em Trabalhadores Dos Serviços, Vendedores Do Comércio Em Lojas E Mercados, como Cuidador de idosos e Agente comunitário de saúde, além de outras profissões que estavam em Técnicos de Nível Médio como Técnico de Enfermagem.

O grupo Trabalhadores Nos Serviços De Proteção E Segurança é derivado de Trabalhadores Dos Serviços, Vendedores Do Comércio Em Lojas E Mercados.
