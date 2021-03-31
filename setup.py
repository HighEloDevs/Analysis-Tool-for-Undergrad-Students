import sys 
import os
from cx_Freeze import setup, Executable

# ADD FILES
files = ['icon.ico','images/', 'qml/', 'src/']

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
            'matplotlib_backend_qtquick']

# SETUP CX FREEZE
setup(
    name = "Analysis Tool for Undergrad Students",
    version = "2.0.0a.1",
    description = "Ferramenta para análise de dados",
    author = "Leonardo Eiji Tamayose & Guilherme Ferrari Fortino",
    options = {'build_exe' : {'include_files' : files, 'includes' : includes}},
    executables = [target]
)