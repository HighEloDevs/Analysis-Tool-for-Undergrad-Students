# O que é o ATUS?

O ATUS é um software de código aberto que auxilia alunos e professores, principalmente, nas disciplinas de Física Experimental do Instituto de Física da USP. É possível criar gráficos, histogramas, ajustar funções lineares e não lineares nos parâmetros, determinar intervalos de confiança etc.

# O.S. suportados

O ATUS pode ser utilizado no Windows 10/11, Ubuntu (testado a partir do 20.04), Manjaro (?) e MacOS.

# Como instalar o ATUS?

Para instalar o ATUS basta clicar [aqui](link) e ir até o sistema operacional que você utiliza para seguir o passo a passo de instalação.

# É possível instalar o ATUS usando o pip?

Sim, basta ter o Python com versão >= 3.7 e executar no terminal:
```
pip install atus
```
Após a instalação executar no terminal:
```
atus
```
Atenção: é recomendável criar um ambiente virtual separado para a execução do ATUS, assim é possível evitar imcompatibilidade com outros pacotes de diferentes projetos que você tenha instalado.

# O ATUS pode danificar meu computador?

Não. No Windows o arquivo .exe do ATUS é barrado em um primeiro momento pois não temos a licensa do Windows ao criar um instalador. O ATUS é apenas um grande código em Python e QML.

# Erros de instalação

## VCRUNTIME140dll

[imagem]

Basta instalar os Pacotes Redistribuíveis do Visual C++ para Visual Studio 2015 clicando [aqui](https://www.microsoft.com/pt-br/download/details.aspx?id=48145).


# Questões gerais

## Como reportar um bug?

Envie um email para: atusdevs@gmail.com explicando detalhadamente o problema para que possamos reproduzi-lo. Coloque informações adicionais como: sistema operacional utilizado, arquivo que gerou o problema, versão do ATUS, etc.
Você também pode criar um [issue no GitHub](https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students/issues), colocando as informações necessárias.

## Como contribuir para o atus?

Você pode clonar nosso [respositório](https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students/tree/main) e usar das ferramentas do github para contribuir com o código (fazendo pull requests).
Caso queira sugerir algo para o ATUS, envie um email para: atusdevs@gmail.com.

## Como entrar em contato com os desenvolvedores?

Entre em contato pelo email: atusdevs@gmail.com; ou pelo Discord: https://discord.com/invite/yEHXeKqrtw.