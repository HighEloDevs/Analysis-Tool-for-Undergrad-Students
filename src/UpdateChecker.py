# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

UpdaterChecker class

"""

from matplotlib_backend_qtquick.backend_qtquick import NavigationToolbar2QtQuick
from matplotlib_backend_qtquick.qt_compat import QtCore
import requests

class UpdateChecker(QtCore.QObject):

    showUpdate = QtCore.Signal()

    def __init__(self) -> None:
        super().__init__()
        
        # Actual version
        self.__VERSION__  = '2.0.0a1'
        self.isUpdate = True
        
    @QtCore.Slot()
    def checkUpdate(self):
        # Check for Updates
        versionUrl = 'http://atusserver.s3-sa-east-1.amazonaws.com/version.txt'
        try:
            version = requests.get(versionUrl, allow_redirects=True, stream=True).content.decode()
            if(self.__VERSION__ == version):
                print('ATUS atualizado')
            else:
                self.isUpdate = False
                self.showUpdate.emit()
                print('ATUS desatualizado')
                print('Versão mais atual: ', version)
        except:
            print('Não foi possível checar por atualizações')
        print('Versão atual: ', self.__VERSION__)