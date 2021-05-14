---
layout: page
title: Linux
permalink: /linux/
---

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

Atenção: caso não seja reconhecido o comando "pip" ou "python", use "pip3" no lugar do "pip" e "python3" no lugar de "python".