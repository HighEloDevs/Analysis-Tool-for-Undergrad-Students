import sys 
import os
from cx_Freeze import setup, Executable

# ADD FILES
files = ['ATUS Icon 3.svg','ATUS Icon 3.png', 'icon.ico', 'ATUS Logo Preto.svg', 'images/', 'qml/', 'src/']

# TARGET
target = Executable(
    script="main.py",
    base="Win32GUI",
    icon="icon.ico"
)

includes = ['matplotlib',
            'pandas',
            'lmfit',
            'scipy.spatial.transform._rotation_groups',
            'numpy',
            'matplotlib_backend_qtquick',
            'pandas._libs.tslibs.base',
            'scipy'
            ]

# SETUP CX FREEZE
setup(
    name = "ATUS",
    version = "2.0.0",
    description = "Ferramenta para análise de dados",
    author = "Leonardo Eiji Tamayose & Guilherme Ferrari Fortino",
    options = {'build_exe' : {'include_files' : files, 'includes' : includes}},
    executables = [target]
)