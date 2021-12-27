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
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, QJsonValue, QThread
import requests
import platform
import datetime
import os
import time

class UpdateChecker(QObject):
    showUpdate = pyqtSignal(QJsonValue, arguments='infos')
    updateProgress = pyqtSignal(float, arguments='infos')
    updateOnWindows = pyqtSignal()

    class Updater(QObject):
        updateProgress = pyqtSignal(float, arguments='infos')
        i = 0
        @pyqtSlot()
        def updateOnWindows(self):
            # Where to save the file
            savePath = os.path.join(os.environ["HOMEPATH"], 'Downloads')

            # Getting download URL
            response = requests.get(self.gitHubApiUrl)
            infos = response.json()
            exeUrl = infos['assets'][0]['browser_download_url']
            # print(self.thread().start())
            # for i in range(0, 101, 1):
            #     self.updateProgress.emit(i/100)
            #     # print(i/100)
            #     time.sleep(0.01)
            

            with open(os.path.join(savePath, 'atus.exe'), "wb") as f:
                dl = 0
                exe = requests.get(exeUrl, allow_redirects=True, stream=True)
                total_length = exe.headers.get('content-length')
                total_length = int(total_length)
                for i in exe.iter_content(chunk_size=4096):
                    dl += len(i)
                    f.write(i)
                    done = float(dl / total_length)
                    time.sleep(0.01)
                    self.updateProgress.emit(done)

            # Saving .exe to path
            os.system(f'cd {savePath}')

            # Running .exe
            # This runs in silent mode
            os.system('atus.exe /verysilent')
            os.chdir(savePath)
            # print(os.getcwd() + "\n")
            # os.system(r'.\atus.exe')
            # os.system(r'del /f atus.exe')

    def __init__(self) -> None:
        super().__init__()
        
        # URL to last release
        self.gitHubApiUrl = 'https://api.github.com/repos/HighEloDevs/Analysis-Tool-for-Undergrad-Students/releases/latest'

        # Actual version
        with open(os.path.join(os.path.dirname(__file__) + "/../version.txt")) as version:
            self.__VERSION__  = version.read()
            version.close()
        self.isUpdate = True
        # Updater must work in a different thread, so it can update de download progress bar
        self.updaterThread = QThread()
        self.updaterThread.start(5)
        self.updater = self.Updater()
        self.updater.moveToThread(self.updaterThread)
        self.updater.updateProgress.connect(self.updateProgress)
        self.updateOnWindows.connect(self.updater.updateOnWindows)
        print(self.thread())
        
    @pyqtSlot()
    def checkUpdate(self):        
        response = requests.get(self.gitHubApiUrl)

        if response.status_code == 200:
            infos = response.json()
            # Parsing publish date
            infos["published_at"] = datetime.datetime.strptime(infos["published_at"], '%Y-%m-%dT%XZ').strftime('%d/%m/%Y')
            
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
