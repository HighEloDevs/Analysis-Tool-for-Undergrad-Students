---
layout: post
title: "Como importar meus dados"
categories: misc
---

O primeiro passo na realização do ajuste de uma função é a importação dos dados. Existem **2 formas** de importar no ATUS:
 1. Por colagem, utilizando <kbd>CTRL</kbd>+<kbd>B</kbd> ou <kbd>CTRL</kbd>+<kbd>Espaço</kbd>, no Windows ou Linux, e <kbd>⌘</kbd>+<kbd>B</kbd> no MacOS;
 2. Através de arquivos de dados **.txt**, **.tsv** ou **.csv**.

---

### 1. Colagem de Dados

Após a realização de um experimento, é comum dispomos de tabelas de dados nos quais desejamos ajustar funções para que, a partir dos parâmetros otimizados, possamos realizar uma análise de tal forma a validar ou não um modelo físico.

Suponha que tenhamos um conjunto de dados armazenados no **Google Sheets** ou no **Microsoft Excel**. A primeira coisa a se fazer é organizar as colunas da maneira correta para a importação no ATUS, a ordem é: **X, Y, incerteza de Y, incerteza de X**. Em seguida, basta copiar a tabela com os dados. Para os casos em que não há incertezas associadas às medidas, basta adicionar uma coluna vazia à tabela, por exemplo:

***Lembrando que os títulos das colunas NÃO DEVEM ser incluidos, apenas os dados.***

<p align="center">
  <img width="400" height="350" src="https://user-images.githubusercontent.com/48266854/120232940-02208500-c22b-11eb-9ee8-b774768f5946.png">
</p>

![2021-05-31 15-52-11](https://user-images.githubusercontent.com/48266854/120231717-5d9d4380-c228-11eb-9cf9-263b82a7ca43.gif)

Com os dados copiados, basta ir ao ATUS e colá-los, utilizando <kbd>CTRL</kbd>+<kbd>B</kbd> ou <kbd>CTRL</kbd>+<kbd>Espaço</kbd>, no Windows ou Linux, e <kbd>⌘</kbd>+<kbd>B</kbd> no MacOS.

![Colar](https://user-images.githubusercontent.com/48266854/120234060-88d66180-c22d-11eb-8242-44853c0ea4d5.gif)

---

### 2. Importação por arquivos .txt, .tsv, .csv 

Para criar um **.txt** compatível com o ATUS, basta criar um novo bloco de notas e colar os dados copiados nele.

<p align="center">
  <img width="400" height="350" src="https://user-images.githubusercontent.com/56280982/120269598-7afcfc80-c27e-11eb-91e3-c03e41664f00.png">
</p>

Outra forma de importação de dados ocorre através de arquivos de texto. O **Google Sheets** permite a criação de arquivos **.csv** e **.tsv** a partir das tabelas. Lembrando que ao fazer o download do arquivo, os títulos das colunas serão inclusas, é extramente importante retirá-los.

<p align="center">
  <img width="400" height="350" src="https://user-images.githubusercontent.com/48266854/120241175-904f3800-c238-11eb-90af-69c7f12cc05a.png">
</p>

Com os arquivos de dados em mão, basta importá-los no ATUS utilizando o botão "ESCOLHER DADOS".
