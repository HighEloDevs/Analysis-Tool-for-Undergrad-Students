import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

with open('./version.txt') as version:
    __VERSION__  = version.read()
setuptools.setup(
    name="atus",
    version=__VERSION__,
    author="High Elo Devs",
    author_email="atusdevs@gmail.com",
    description="Tool for analysis",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students",
    project_urls={
        "Bug Tracker": "https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students/issues",
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    # src "vira" src. E.g. 'src.atus':'src' -> src.atus "vira" src
    packages_dir={'src':'src'}, 
    packages=["src", ""],
    include_package_data=True,
    python_requires=">=3.7",
    entry_points={
        'console_scripts': ['atus = main:main'],
        'gui_scripts': ['atus = main:main']
    },
    install_requires=[
        "setuptools>=42",
        "wheel",
        "matplotlib==3.4.2",
        "pandas",
        "numpy",
        "scipy",
        "lmfit",
        "matplotlib_backend_qtquick",
        "pyqt5",
        "requests",
    ]
)   