# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 11:59:27 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 
"""

import sys
import os
from PyQt5 import QtWidgets, QtCore, QtGui
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import pandas as pd
from src.Model import Model
from src.Panels import Panels

# Parameters
WINDOW_WIDTH = 1500
WINDOW_HEIGHT = 600

app = QApplication(sys.argv)

class MainWindow(QMainWindow):
    
    def __init__(self):
        super(MainWindow, self).__init__()
        
        # Actual file name
        self.aFile = None
        
        # Accepting drops
        self.setAcceptDrops(True)
        
        # Initializing UI
        self.initUI()
        
    def initUI(self):
        # Path
        scriptDir = os.path.dirname(os.path.realpath(__file__))
        
        # Main window properties
        self.setWindowTitle("Analysis Tool for Undergrad Students | ATUS")
        self.setGeometry(200, 200, WINDOW_WIDTH, WINDOW_HEIGHT)
        self.setAnimated(True)
        self.setTabShape(QtWidgets.QTabWidget.Rounded)
        self.setWindowIcon(QtGui.QIcon(scriptDir + os.path.sep + 'Análise.png')) 
        
        # Setting up central widget
        self.CentralWidget = Panels() 
        self.setCentralWidget(self.CentralWidget) 
        
        # Creating Menu    
        # self.createMenu()
        # self.retranslateUi()
        
        QtCore.QMetaObject.connectSlotsByName(self)
        
    def retranslateUi(self):
        _translate = QtCore.QCoreApplication.translate
        self.menuArquivo.setTitle(_translate("MainWindow", "Arquivo"))
    
    def createMenu(self):
        # Creating menu bar
        self.menubar = QtWidgets.QMenuBar(self)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 22))
        self.menubar.setObjectName("menubar")
        
        # Arquivo button
        self.menuArquivo = QtWidgets.QMenu(self.menubar)
        self.menuArquivo.setObjectName("menuArquivo")
        self.menubar.addAction(self.menuArquivo.menuAction())

        # Setting menu bar
        self.setMenuBar(self.menubar)
        
        # "Novo Arquivo"
        self.actionNovoArquivo = QtWidgets.QAction(self)
        self.actionNovoArquivo.setObjectName("NovoArquivo")
        self.menuArquivo.addAction(self.actionNovoArquivo)
        self.actionNovoArquivo.setText("Novo Arquivo")
        self.actionNovoArquivo.setShortcut("CTRL+N")
        self.actionNovoArquivo.triggered.connect(self.newFile)
        
        # "Abrir Arquivo"
        self.actionAbrirArquivo = QtWidgets.QAction(self)
        self.actionAbrirArquivo.setObjectName("AbrirArquivo")
        self.menuArquivo.addAction(self.actionAbrirArquivo)
        self.actionAbrirArquivo.setText("Abrir Arquivo")
        self.actionAbrirArquivo.setShortcut("CTRL+O")
        self.actionAbrirArquivo.triggered.connect(self.loadFile)
        
        # "Salvar Arquivo"
        self.actionSalvarArquivo = QtWidgets.QAction(self)
        self.actionSalvarArquivo.setObjectName("SalvarArquivo")
        self.menuArquivo.addAction(self.actionSalvarArquivo)
        self.actionSalvarArquivo.setText("Salvar")
        self.actionSalvarArquivo.setShortcut("CTRL+S")
        self.actionSalvarArquivo.triggered.connect(self.saveFile)
        
        # "Salvar Arquivo Como"
        self.actionSalvarArquivoComo = QtWidgets.QAction(self)
        self.actionSalvarArquivoComo.setObjectName("SalvarArquivoComo")
        self.menuArquivo.addAction(self.actionSalvarArquivoComo)
        self.actionSalvarArquivoComo.setText("Salvar como...")
        self.actionSalvarArquivoComo.setShortcut("CTRL+Shift+S")
        self.actionSalvarArquivoComo.triggered.connect(self.saveFileAs)
        
    def newFile(self):
        # Saving before closing the window
        self.saveFile()
        
        # Closing window and reopening
        app.closeAllWindows()
        self.win = MainWindow()
        self.win.show()
        
    def loadFile(self):
        # Getting file name
        filename = QFileDialog.getOpenFileName(self, 'Open File', os.getenv('HOME'))
        
        # Saving the actual filename
        self.aFile = filename[0]
        
        # Reading it
        try:
            with open(filename[0], 'r') as f:
                file_text = f.read()
                return file_text
        except:
            pass
        
    def saveFile(self):
        # If you didn't open any file, save as
        if self.aFile == None: 
            self.saveFileAs()
        # Else save in the opened file
        else:
            try:
                file = open(self.aFile,'w')
                text = "teste"
                file.write(text)
                file.close()
            except:
                pass
        
    def saveFileAs(self):    
        filename = QFileDialog.getSaveFileName(self, 'Save File', os.getenv('HOME'))
        try:
            file = open(filename[0],'w')
            text = "teste"
            file.write(text)
            file.close()
        except:
            pass

    def dragEnterEvent(self, event):
        if event.mimeData().hasUrls():
            event.accept()
        else:
            event.ignore()

    def dropEvent(self, event):
        files = [u.toLocalFile() for u in event.mimeData().urls()]
        for f in files:
          # Saving the actual filename
          self.aFile = f
        

