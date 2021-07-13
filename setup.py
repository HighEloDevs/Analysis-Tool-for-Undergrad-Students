from cx_Freeze import setup, Executable

with open('./version.txt') as version:
    __VERSION__  = version.read()

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
    'lmfit',
]

# TARGET
target = Executable(
    script="main.py",
    base="Win32GUI",
    icon="icon.ico"
)

# Dependencies are automatically detected, but it might need fine tuning.
# Options for building a .exe
build_exe_options = {
    'packages': includes,
    'excludes': ["tkinter",
                'sympy',
                ],
    'include_files': files
}

# Options for building a .msi installer
bdist_msi_options = {
    "data": {
        "ProgId": [
            ("Prog.Id", None, None, "Ferramenta para análise de dados", "IconId", None),
        ],
        "Icon": [
            ("IconId", "icon.ico"),
        ],
    },
}

# Setting up CxFreeze
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