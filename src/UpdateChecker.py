# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

UpdaterChecker class

"""

from os import error
from matplotlib_backend_qtquick.backend_qtquick import NavigationToolbar2QtQuick
from matplotlib_backend_qtquick.qt_compat import QtCore
import requests

class UpdateChecker(QtCore.QObject):

    showUpdate = QtCore.Signal(str, str, str, str, arguments=['updateLog', 'version', 'downloadUrl'])

    def __init__(self) -> None:
        super().__init__()
        
        # Actual version
        with open('./version.txt') as version:
            self.__VERSION__  = version.read()
            version.close()
        self.isUpdate = True
        
    @QtCore.Slot()
    def checkUpdate(self):
        # Check for Updates
        serverUrl = 'http://atusserver.s3-sa-east-1.amazonaws.com/'
        versionUrl = serverUrl + 'version.txt'
        
        try:
            # Parsing .txt file
            versionTxt = requests.get(versionUrl, allow_redirects=True, stream=True).content.decode().split(':')
            version = versionTxt[1].split('\r\n')[0].strip()
            downloadUrl = "https://drive.google.com/drive/folders/1MYXxqCy1s9AMsKC2fDVu1SK556CrAqCo?usp=sharing"
            updateLog = versionTxt[2]
            try:
                version = version.strip()
            except:
                pass
            try:
                updateLog = updateLog.strip()
            except:
                pass

            if(self.__VERSION__ == version):
                pass
            else:
                self.isUpdate = False
                self.showUpdate.emit(updateLog, version, downloadUrl)

        except error:
            print(error)
    
    @QtCore.Slot(result=str)
    def getVersion(self):
        return self.__VERSION__