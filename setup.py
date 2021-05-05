import sys 
import os
from cx_Freeze import setup, Executable

with open('./version.txt') as version:
    __VERSION__  = version.read()
    version.close()

# Files and folders to include
files = [
    'icon.ico',
    'images/',
    'qml/',
    'src/',
    'version.txt'
]

# Packages to include
includes = [
    'os',
    'platform',
    'sys',
    'copy',
    'requests',
    'json',
    'matplotlib_backend_qtquick',
    'numpy',
    'operator',
    'scipy',
    'pandas',
    'lmfit'
]

# TARGET
target = Executable(
    script="main.py",
    # base="Win32GUI",
    icon="icon.ico"
)

# Dependencies are automatically detected, but it might need fine tuning.
build_exe_options = {
    'packages': includes,
    'excludes': ["tkinter",
                'sympy',
                'asyncio',
                'atomicwrites'
                'botocore',
                'cryptography',
                'markupsafe',
                'sqlite3',
                'shiboken2',
                'test'
                ],
    'include_files': files
}

# SETUP CX FREEZE
setup(
    name = 'ATUS',
    version = __VERSION__,
    description = 'Ferramenta para análise de dados',
    author = 'Leonardo Eiji Tamayose & Guilherme Ferrari Fortino',
    options = {
        'build_exe': build_exe_options
    },
    executables = [target]
)