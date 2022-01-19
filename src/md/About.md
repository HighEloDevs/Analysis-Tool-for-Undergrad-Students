# Informações Gerais

---
<br/>

### O que é o ATUS?

É um software de código aberto que auxilia alunos e professores, principalmente, nas disciplinas de física experimental do **Instituto de Física da USP**. O ATUS permite a criação de gráficos, histogramas, ajustes de funções lineares e não lineares nos parâmetros, determinar intervalos de confiança etc.

### Sistemas operacionais suportados

O ATUS pode ser utilizado no **Windows 10/11**, **Ubuntu** (testado a partir do 20.04), **Manjaro**, **Pop!_OS** e **Mac OS**.

### Como instalar o ATUS?

Os tutoriais de instalação estão disponíveis na nossa [documentação](http://localhost:8080/install/).

### É possível instalar o ATUS usando o pip?

**Sim**, basta ter o Python com versão >= 3.7 e executar no terminal:
```
pip install atus
```
Após a instalação executar no terminal:
```
atus
```
**Atenção:** é recomendável criar um ambiente virtual separado para a execução do ATUS, assim é possível evitar imcompatibilidade com outros pacotes de diferentes projetos que você tenha instalado.

### O ATUS pode danificar meu computador?

**Não**. No Windows, o arquivo **.exe** do ATUS é barrado em um primeiro momento pois não temos a licensa do Windows ao criar um instalador.

# Erros de Instalação

---
<br/>

### VCRUNTIME140dll

![image](https://user-images.githubusercontent.com/56280982/148629650-78e823fc-2812-467c-800a-de52cce913b4.png)

Basta instalar os Pacotes Redistribuíveis do Visual C++ para Visual Studio 2015 clicando [aqui](https://www.microsoft.com/pt-br/download/details.aspx?id=48145).

# Questões Gerais

---
<br/>

### Como reportar um bug?

Envie um email para atusdevs@gmail.com explicando detalhadamente o problema para que possamos reproduzi-lo. Coloque informações adicionais como: sistema operacional utilizado, arquivo que gerou o problema, versão do ATUS, etc.
Você também pode criar um [issue no GitHub](https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students/issues), colocando as informações necessárias.

### Como contribuir para o atus?

Você pode clonar nosso [respositório](https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students/tree/main) e usar das ferramentas do github para contribuir com o código (fazendo pull requests).
Caso queira sugerir algo uma nova funcionalidade ou melhoria, envie um email para atusdevs@gmail.com .

### Como entrar em contato com os desenvolvedores?

Você pode nos contatar pelo e-mail já citado acima. Se preferir, também temos um grupo no [Discord](https://discord.com/invite/yEHXeKqrtw), sinta-se à vontade para entrar e bater um papo conosco!
