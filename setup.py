from setuptools import setup

# import os

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

with open("atus/version.txt") as version:
    __VERSION__ = version.read()

# PATH = os.path.dirname(os.path.abspath(__file__))
# PATH = os.path.join(PATH, "requirements.txt")
# with open("atus/requirements.txt", mode="r", encoding="utf-16") as f:
#     list_req = f.read().splitlines()

setup(
    name="atus",
    version=__VERSION__,
    author="High Elo Devs",
    author_email="atusdevs@gmail.com",
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
    package_data={
        "atus": ["version.txt", "icon.ico"],
    },
    package_dir={"src": "src"},
    packages=["atus", "atus/src"],
    include_package_data=True,
    python_requires=">3.8, <3.12",
    entry_points={
        "console_scripts": ["atus = atus:main.main"],
    },
    install_requires=[
        "setuptools>=42",
        "lmfit==1.1.0",
        "matplotlib==3.6.2",
        "IPython==8.10.0",
        "numpy==1.23.5",
        "pandas==1.5.2",
        "PyQt5==5.15.6",
        "requests==2.28.1",
        "scipy==1.9.3",
        "pytexit==0.4.0",
    ],
)
