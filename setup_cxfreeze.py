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
    'requests',
    'matplotlib_backend_qtquick',
    'numpy',
    'operator',
    'pandas',
    'lmfit',
    'scipy.odr',
    'scipy.spatial.transform._rotation_groups',
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
    'excludes': [
                    "tkinter",
                    "sympy",
                    "sqlite3", 
                    "scipy.lib.lapack.flapack",
                    "numpy.core._dotblas", 
                ],
    'zip_include_packages': ['PyQt5.QtCore', 'PyQt5.QtGui', 'PyQt5.QtQml'],
    'includes': includes,
    'include_files': files,
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