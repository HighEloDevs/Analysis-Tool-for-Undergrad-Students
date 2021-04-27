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
    'src/'
]

# Packages to include
packages = [
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
    base="Win32GUI",
    icon="icon.ico"
)

# Dependencies are automatically detected, but it might need fine tuning.
build_exe_options = {
    'packages': packages,
    'excludes': ["tkinter"],
    'include_files': files
}

bdist_msi_options = {
    'add_to_path': False,
    'initial_target_dir': r'[ProgramFilesFolder]\%s' % ('High Elo Devs'),
}

# SETUP CX FREEZE
setup(
    name = 'ATUS',
    version = __VERSION__,
    description = 'Ferramenta para análise de dados',
    author = 'Leonardo Eiji Tamayose & Guilherme Ferrari Fortino',
    options = {
        'build_exe': build_exe_options,
        'bdist_msi': bdist_msi_options,
    },
    executables = [target]
)