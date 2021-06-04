---
layout: post
title: "Múltiplos ajustes"
categories: misc
---

Digamos que você tenha vários gráficos (projetos de ajustes simples) e deseja verificar visualmente como eles se comportam em um mesmo gráfico, para isso existe a opção de múltiplos ajustes do ATUS.
Estamos supondo que a este ponto você sabe salvar projetos na aba de ajustes simples. Caso não saiba, você pode aprender neste [link](https://highelodevs.github.io/Analysis-Tool-for-Undergrad-Students/misc/2021/05/14/ajuste-de-funcao.html).

Primeiramente, vamos nos familiarizar com cada botão e região da interface dos múltiplos ajustes.

![ATUS - Multiplot](https://user-images.githubusercontent.com/48266854/120737063-c7854980-c4c3-11eb-9ced-f90593dc1867.png)

|Index|Descrição|Index|Descrição|
|:---:|:-------:|:---:|:-------:|
|1|Título do gráfico|11|Escala log no eixo x|
|2|Título para o eixo x|12|Escala log no eixo y|
|3|Valor mínimo para o eixo x|13|Adiciona um projeto de ajuste simples|
|4|Valor máximo para o eixo x|14|Tabela onde aparecerão os projetos já adicionados|
|5|Número de intervalos no eixo x|15|Identificação para o projeto|
|6|Título para o eixo y|16|Recomeça um projeto / Limpa a página|
|7|Valor mínimo para o eixo y|17|Abre um projeto (de multiplot) salvo|
|8|Valor máximo para o eixo y|18|Salva o atual projeto no arquivo já aberto|
|9|Número de intervalos no eixo y|19|Salva o atual projeto em um arquivo novo|
|10|Mostrar ou não a grade no gráfico|20|Plota o gráfico|

Para fazer os múltiplos ajustes, precisamos ter em mãos os projetos que desejamos plotar, ou seja, precisamos dos vários arquivos **.json** obtidos na página de ajuste simples ao salvar. Para carregar um gráfico de ajuste simples, basta clicar no botão 13 da imagem acima.

Em seguida, você deverá selecionar o arquivo e abri-lo. Você pode abrir quantos quiser e possui à disponibilidade algumas opções de costumização.

![ATUS - tabela](https://user-images.githubusercontent.com/48266854/120738503-55623400-c4c6-11eb-9c31-1bf5e5f72606.png)

|Index|Descrição|Index|Descrição|
|:---:|:-------:|:---:|:-------:|
|1|Nome do projeto carregado|5|Cor do pontos e da curva|
|2|Mostrar ou não os pontos do gráfico|6|Tipo da curva|
|3|Mostrar ou não a curva ajustada|7|Excluir a linha|
|4|A legenda a ser mostrada no gráfico|---|---|

Com os projetos carregado e o gráfico customizado ao seu gosto, basta clicar em **PLOT / ATUALIZAR** para ver seu maravilhoso gráfico!

![image](https://user-images.githubusercontent.com/48266854/120739035-3e701180-c4c7-11eb-8099-0be59187eda4.png)
