---
layout: page
title: "index"
permalink: /
---

## Analysis Tool for Undergrad Students

O **A**nalysis **T**ool for **U**ndergrad **S**tudents (ATUS) foi desenvolvido por estudantes do Instituto de Física da USP com o objetivo de ser uma ferramenta _offline_ e gratuita de análise dados para, principalmente, as disciplinas experimentais do IFUSP.

### Características

- Pode ser usado no Windows 10, Linux (testado no Ubuntu 18.04+), e Mac;
- Interface intuitiva;
- Alta velocidade de execução;
- Open source.

## Instalação

#### Windows

O executável do programa pode ser encontrado [aqui](https://drive.google.com/drive/folders/1MYXxqCy1s9AMsKC2fDVu1SK556CrAqCo?usp=sharing).

Após clicar no executável, esta tela pode surgir:

![image](https://user-images.githubusercontent.com/56280982/116792989-7b954e00-aa9a-11eb-8f22-6a04e0dae32e.png)

Basta clicar em "Mais informações":

![image](https://user-images.githubusercontent.com/56280982/116793031-b0a1a080-aa9a-11eb-93ce-44b679e6e8da.png)

Agora executar:

![image](https://user-images.githubusercontent.com/56280982/116793055-cfa03280-aa9a-11eb-9e79-c0256a9e0a4c.png)

Agora a instalação segue normalmente. Clique em "OK":

![image](https://user-images.githubusercontent.com/56280982/116793067-e3e42f80-aa9a-11eb-988e-d38d806edd9e.png)

Aceita o termo e clique em "Avançar":

![image](https://user-images.githubusercontent.com/56280982/116793075-f0688800-aa9a-11eb-94c1-d7af21a55307.png)

Selecione onde deseja instalar e clique em "Avançar":

![image](https://user-images.githubusercontent.com/56280982/116793088-01b19480-aa9b-11eb-9ec7-2bf1a05ef868.png)

Selecione a opção de criar um atalho na área de trabalho (caso desejar) e clique em "Avançar":

![image](https://user-images.githubusercontent.com/56280982/116793116-1e4dcc80-aa9b-11eb-9cfa-55b34f215c84.png)

Clique em "Instalar":

![image](https://user-images.githubusercontent.com/56280982/116793126-2a398e80-aa9b-11eb-97b0-ac1d7c9c5439.png)

Pronto! Basta concluir a instalação:

![image](https://user-images.githubusercontent.com/56280982/116793136-36255080-aa9b-11eb-9e07-7a2bd7db982c.png)

#### Linux

A instalação requer o uso do Python 3.7 - 3.9. Agora instale as dependências (bibliotecas do python) usando os seguintes comandos:

```
pip install --upgrade pip
pip install matplotlib scipy numpy pandas lmfit matplotlib_backend_qtquick pyqt5 requests
```

Instale o git:

```
sudo apt-get install git
```

Escolha uma pasta de sua preferência e clone o repositório:

```
git clone https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students.git
```

Em seguida entre na pasta e execute o "main.py" para começar a usar o ATUS:

```
cd Analysis-Tool-for-Undergrad-Students/
python main.py
```
#### Mac

A instalação requer o uso do Python 3.7 - 3.9. Agora instale as dependências (bibliotecas do python) usando os seguintes comandos:

```
pip install --upgrade pip
pip install matplotlib scipy numpy pandas lmfit matplotlib_backend_qtquick pyqt5 requests
```

Instale o git:

```
sudo dnf install git-all
```

Escolha uma pasta de sua preferência e clone o repositório:

```
git clone https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students.git
```

Em seguida entre na pasta e execute o "main.py" para começar a usar o ATUS:

```
cd Analysis-Tool-for-Undergrad-Students/
python main.py
```


Atenção: caso não seja reconhecido o comando "pip" ou "python", use "pip3" no lugar do "pip" e "python3" no lugar de "python".


### Contato

Qualquer dúvida, comentário ou sugestão mande um e-mail para: atusdevs@gmail.com
