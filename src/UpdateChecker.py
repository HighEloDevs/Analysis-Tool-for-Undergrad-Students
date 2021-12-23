# -*- coding: utf-8 -*-
"""
MIT License

Copyright (c) 2021 Leonardo Eiji Tamayose, Guilherme Ferrari Fortino

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

# from matplotlib_backend_qtquick.qt_compat import QtCore
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, QJsonValue
import requests
import platform
import os

class UpdateChecker(QObject):
    showUpdate = pyqtSignal(QJsonValue, arguments='infos')

    def __init__(self) -> None:
        super().__init__()
        
        # Actual version
        with open(os.path.join(os.path.dirname(__file__) + "/../version.txt")) as version:
            self.__VERSION__  = version.read()
            version.close()
        self.isUpdate = True
        
    @pyqtSlot()
    def checkUpdate(self):
        # GitHub API url
        gitHubApiUrl = 'https://api.github.com/repos/HighEloDevs/Analysis-Tool-for-Undergrad-Students/releases/latest'
        response = requests.get(gitHubApiUrl)

        if response.status_code == 200:
            infos = response.json()
            version = infos['tag_name']
            if version != self.__VERSION__:
                self.showUpdate.emit(QJsonValue.fromVariant(infos))

    @pyqtSlot(result=str)
    def getVersion(self):
        return 'v' + self.__VERSION__

    @pyqtSlot(result=str)
    def getOS(self):
        return platform.system()
        # return 'Darwin'
