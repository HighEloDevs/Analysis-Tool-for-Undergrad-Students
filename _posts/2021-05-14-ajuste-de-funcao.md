---
layout: post
title: "Como ajustar funções"
categories: misc
---

***Neste exemplo, não iremos nos preocupar com unidades e todos os dados serão fictícios***

Vamos supor que um modelo no qual desejamos analisar seja representado pela função

<p align="center">
  <img src="https://user-images.githubusercontent.com/48266854/120723541-53897800-c4a8-11eb-8f0f-8478dc8ade20.png">,
</p>

também temos em mãos um conjunto de dados retirados de um experimento, esses dados podem conter ou não incertezas associadas aos seus valores.

Como de rotina em física experimental, desejamos ajustar nossa função aos dados, de forma a obter os parâmetros *a* e *b* otimizados para que a distância média dos pontos à curva seja a menor possível. Para isso, utilizaremos o ATUS, basta seguir os simples passos:

  1. Importar os dados -> [Como importar meus dados?](https://highelodevs.github.io/Analysis-Tool-for-Undergrad-Students/misc/2021/05/14/importacao-de-dados.html)
  2. Escrever a função de ajuste
  3. Customizar o gráfico ao seu gosto -> [Como customizar meus gráficos?](https://highelodevs.github.io/Analysis-Tool-for-Undergrad-Students/misc/2021/05/14/customizacao.html)
  4. Plotar

A interface do ATUS foi desenvolvida por ex-alunos de física experimental, ou seja, foi feita por quem já passou por esse processo, então é fácil se acostumar a utilizá-lo. Na imagem abaixo, é possível ver as principais regiões da nossa interface de ajuste.

![ATUS - Função de ajuste](https://user-images.githubusercontent.com/48266854/120725714-f5ab5f00-c4ac-11eb-958c-00c30b21bad4.png)

| Index         | Descrição     | Index | Descrição |
|:-------------:|:-------------:|:-----:|:---------:|
|      1        |Recomeça um projeto / Limpa a página|   9   |Parâmetros iniciais para auxiliar no ajuste da função|
|      2        |Abre um projeto salvo|  10   |Valor mínimo de X a ser considerado para o ajuste|
|      3        |Salva o atual projeto no arquivo já aberto|  11   |Valor máximo de X a ser considerado para o ajuste|
|      4        |Salva o atual projeto em um arquivo novo|  12   |Considerar ou não incertezas em X|
|      5        |Identificação para o projeto|  13   |Considerar ou não incertezas em Y|
|      6        |Carrega o arquivo com a tabela de dados|  14   |Tabela onde serão mostrados os parâmetros ajustados, seus valores e incertezas|
|      7        |Tabela de dados onde é possível alterar e exluir valores|  15   |Área em que serão mostrados os valores do χ², NGL etc |
|      8        |Função a ser ajustada|  16   |Ajusta a função e plota o gráfico|
  
Depois de conhecer a interface e carregar os dados do experimento, precisamos escrever a nossa função a ser ajustada. No caso desse exemplo, desejamos ajustar uma reta, ou seja, na região *"Expressão | y(x) = "* devemos escrever

```
a*x + b
```
onde *a* e *b* são nossos parâmetros e o *x* **necessariamente** deve ser a variável independente. Repare que o operador * representa a multiplicação e é uma palavra/caracter **reservada** no ATUS, ou seja, é proibido utiliza-lo para a declaração de parâmetros. Outras palavras reservadas incluem:

| Palavra reservada         | Representação     | Palavra reservada | Representação |
|:-------------:|:-------------:|:-----:|:---------:|
|      abs        |Valor absoluto / Módulo do número|   floor   |Arrendondamento 'para baixo' do valor (ex.: floor(3.999) = 3)|
|      acos        |Arco cosseno|  log   |Logarítmo **neperiano**|
|      acosh        |Arco cosseno hiperbólico|  log10   |Logarítmo na base 10|
|      asin        |Arco seno|  max   |Compara dois valores e escolhe o maior (ex.: max(3,1) = 3)|
|      asinh        |Arco seno hiperbólico|  min   |Compara dois valores e escolhe o menor (ex.: min(3,1) = 1)|
|      atan        |Arco tangente|  pi   |Valor de Pi|
|      atan2        |Arco tangente no segundo quadrante|  pow   |Eleva um número ao outro (ex.: pow(2,3) = 2³)|
|      atanh        |Arco tangente hiperbólico|  radians   |Converte o valor em radianos|
|      cos        |Cosseno|  sin   |Seno|
|      cosh        |Cosseno hiperbólico|  sinh   |Seno hiperbólico|
|      degrees        |Converte o valor em graus (ex.: degrees(3.14))|  sqrt   |Raiz quadrada|
|      exp / e        |Exponencial (ex.: exp(3) = e**3)|  tan   |Tangente|
|      factorial        |Fatorial (ex.: factorial(3) = 6|  tanh   |Tangente hiperbólica|
|      +        |Soma|  -   |Subtração|
|      *        |Multiplicação|  /   |Divisão|
|      ** / ^        |Potenciação (ex.: 3**3 = 3^3)|  ---   |---|

Alguns exemplos de funções para que você se acostume com a notação:

- Função linear: `a*x + b`, `v0 * x + k`, `neymar1 * x + neymar2`
- Função quadrática: `a*x**2 + b*x + c`, `a*x^2 + b*x + c`, `teste1 * x^2 + teste2 * x + teste3`
- Função exponencial: `a*exp(b*x)`, `a*e**(b*x)`
- Função senoidal: `a*sin(x+b)`, `amplitude*sin(b + fase)`

***x SEMPRE deverá ser a variável independente***

Com a nossa função corretamente escrita, basta clicar em *"PLOTAR / ATUALIZAR"* e o ATUS fará o resto do trabalho pra você.

![image](https://user-images.githubusercontent.com/48266854/120730670-6441ea00-c4b8-11eb-8dac-ef44438dec17.png)


