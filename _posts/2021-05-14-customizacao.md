---
layout: post
title: "Customização dos gráficos"
categories: misc
---

O ATUS permite uma razoável gama de opções de customização do seu gráfico. É bem provável que nós, os desenvolvedores, continuemos adicionando mais opções para você adequar o seu gráfico ao seu gosto. Aqui vamos apresentar algumas funções que já estão implementadas.

![ATUS - Customização](https://user-images.githubusercontent.com/48266854/120732062-15e21a80-c4bb-11eb-9d5c-7c009f5b7853.png)

|Index|Descrição|Index|Descrição|
|:---:|:-------:|:---:|:-------:|
|1|Título para o gráfico|12|Mostrar ou não o gráfico de resíduos|
|2|Título para o eixo x|13|Mostrar ou não as grades no gráfico|
|3|Escala log no eixo x|14|Mostrar ou não a legenda contento a função de ajuste|
|4|Valor mínimo no eixo x|15|Valor mínimo no eixo y dos resíduos|
|5|Valor máximo no eixo x|16|Valor máximo no eixo y dos resíduos|
|6|Número de intervalos no eixo x|17|Cor dos pontos|
|7|Título do eixo y|18|Tamanho do pontos|
|8|Escala log no eixo y|19|Representação dos pontos (símbolo)|
|9|Valor mínimo no eixo y|20|Cor da curva / função ajustada|
|10|Valor máximo no eixo y|21|Espessura da curva|
|11|Número de intervalos no eixo y|22|Estilo da curva (ex.: tracejada, sólida etc)|

---
#### Compatibilidade com o LaTeX

Uma propriedade bastante legal / importante do ATUS, é a sua compatibilidade com símbolos e expressões do ***LaTeX***. Por exemplo, digamos que você tem um gráfico em que precisa nomear os eixos x e y com **∆t** e **∆S**, respectivamente. Para isso, precisamos, assim como no ***LaTeX***, inicializar um ambiente de equações utilizando o **$**, alguns exemplos abaixo:

 - $\delta$t = ∆t
 - $\delta$S = ∆S
 - $\psi ^ 3$ = ψ³

Neste [link](https://www.caam.rice.edu/~heinken/latex/symbols.pdf) você pode baixar um **.pdf** contendo todos os símbolos suportados pelo ***LaTeX***.

![image](https://user-images.githubusercontent.com/48266854/120734185-d87f8c00-c4be-11eb-98ec-dbfdcd7ed29f.png)

