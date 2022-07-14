from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

with open("atus/version.txt") as version:
    __VERSION__ = version.read()

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
    python_requires=">=3.7, <=3.10",
    entry_points={
        "console_scripts": ["atus = atus:main.main"],
    },
    install_requires=[
        "setuptools>=42",
        "wheel",
        "matplotlib==3.5.2",
        "pandas",
        "numpy",
        "scipy",
        "lmfit",
        "pyqt5",
        "requests",
        "pytexit",
    ],
)
