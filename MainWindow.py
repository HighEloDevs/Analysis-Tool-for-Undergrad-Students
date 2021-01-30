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
from teste_classe import Model

app = QApplication(sys.argv)

# Parameters
WindowWidth = 1500
WindowHeight = 600

class MainWindow(QMainWindow):
    
    def __init__(self):
        super(MainWindow, self).__init__()
        
        # Main window properties
        self.setWindowTitle("Analysis Tool for Undergrad Students | ATUS")
        self.setFixedSize(WindowWidth, WindowHeight)
        self.setAnimated(True)
        self.setTabShape(QtWidgets.QTabWidget.Rounded)
        self.setWindowIcon(QtGui.QIcon('KAIBARINDO.PNG')) 
        
        # Setting up central widget
        self.CentralWidget = Panels() 
        self.setCentralWidget(self.CentralWidget) 
        
        # Actual file name
        self.aFile = None
        
        # Accepting drops
        self.setAcceptDrops(True)
        
        # Initializing UI
        self.initUI()
        
    def initUI(self):
            
        self.createMenu()
        
        self.retranslateUi()
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
        self.aFileDisplay.setText(self.aFile)
        self.aFileDisplay.adjustSize()
        
        # Reading it
        with open(filename[0], 'r') as f:
            file_text = f.read()
            return file_text
        
    def saveFile(self):
        # If you didn't open any file, save as
        if self.aFile == None: 
            self.saveFileAs()
        # Else save in the opened file
        else:
            file = open(self.aFile,'w')
            text = "teste"
            file.write(text)
            file.close()
        
    def saveFileAs(self):    
        filename = QFileDialog.getSaveFileName(self, 'Save File', os.getenv('HOME'))
        file = open(filename[0],'w')
        text = "teste"
        file.write(text)
        file.close()

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
          self.aFileDisplay.setText(self.aFile)
          self.aFileDisplay.adjustSize()
        
class Panels(QWidget):

    def __init__(self):
        super(Panels, self).__init__()
        
        # Fit class
        self.Model = Model()
        
        # Some text
        self.textUpload = QLabel()
        self.dataFile = "Sem dados carregados"
        self.textUpload.setText(self.dataFile)
        
        # Setting UI
        self.initUI()
        
	
    def initUI(self):
        
        # Principal Layout
        hbox = QHBoxLayout(self)
        self.principalLayout = QHBoxLayout(self)
        
        # Setting up three main panels
        self.LeftPanel()
        self.MiddlePanel()
        self.RightPanel()
        
        # Adding panels to the principal layout
        self.principalLayout.addWidget(self.Left)
        self.principalLayout.addWidget(self.Middle)
        self.principalLayout.addWidget(self.Right)
        
        # Setting layout as main widget
        self.setLayout(self.principalLayout)
        
        # Style
        QApplication.setStyle(QStyleFactory.create('Fusion'))
        
    def LeftPanel(self):
        # Creating left panel
        self.Left = QFrame(self)
        self.Left.move(0, 0)
        self.Left.resize(int(WindowWidth / 3), WindowHeight-20)
        self.Left.setFrameShape(QFrame.StyledPanel)
        
        # Left panel layout
        LeftLayout = QVBoxLayout()
        
        # Creating inputs textboxes
        self.nomeArquivo = QLineEdit()
        
        self.InputArea = QWidget()
        InputAreaLayout = QFormLayout(self.InputArea)
        
        # Creating the "Atualizar" button
        UploadButton = QPushButton('Carregar dados')
        UploadButton.clicked.connect(self.Upload)
        
        # Creating table
        self.tableData = QTableWidget()
        
        # set row count
        self.tableData.setRowCount(0)
        
        # set column count
        self.tableData.setColumnCount(4)
        
        # Renaming columns
        columnLabels = ["x", "sx", "y", "sy"]
        self.tableData.setHorizontalHeaderLabels(columnLabels)
        
        # Adjusting rows and columns
        self.tableData.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
        
        header = self.tableData.horizontalHeader()       
        header.setSectionResizeMode(0, QtWidgets.QHeaderView.Stretch)
        header.setSectionResizeMode(1, QtWidgets.QHeaderView.Stretch)
        header.setSectionResizeMode(2, QtWidgets.QHeaderView.Stretch)
        header.setSectionResizeMode(3, QtWidgets.QHeaderView.Stretch)

        # Adding "Carregar dados" button
        InputAreaLayout.addRow(QLabel("Nome do Trabalho:"), self.nomeArquivo)
        InputAreaLayout.addRow(UploadButton, self.textUpload)
        
# =============================================================================
#         InputAreaLayout.addRow(QLabel("Título:"), self.titulo)
#         InputAreaLayout.addRow(QLabel("Eixo X:"), self.eixox)
#         InputAreaLayout.addRow(QLabel("Eixo Y:"), self.eixoy)
#         InputAreaLayout.addRow(QLabel("Expressão:"), self.expressao)
#         InputAreaLayout.addRow(UpdateButton)
#         InputAreaLayout.addRow(tableWidget)
# =============================================================================

        LeftLayout.addWidget(self.InputArea)
        LeftLayout.addWidget(self.tableData)

        # Creating left panel's layout
        self.Left.setLayout(LeftLayout)
        
    def MiddlePanel(self):
        self.Middle = QFrame(self)
        self.Middle.move(500, 0)
        self.Middle.resize(int(WindowWidth / 3), WindowHeight-20)
        self.Middle.setFrameShape(QFrame.StyledPanel)
        
    def RightPanel(self):
        self.Right = QFrame(self)
        self.Right.move(1000, 0)
        self.Right.resize(int(WindowWidth / 3), WindowHeight-20)
        self.Right.setFrameShape(QFrame.StyledPanel)

    def Upload(self):
        # Getting file name
        filename = QFileDialog.getOpenFileName(self, 'Open File', os.getenv('HOME'), filter="Text files (*.txt);;Excel files (*.csv)")
        
        if not filename[0] == "":
            # Saving the actual filename
            self.dataFile = filename[0]
            self.textUpload.setText(self.dataFile.split("/")[-1])
        else:
            return None
        
        self.Model.load_data(self.dataFile)
        
        self.tableData.setRowCount(0)
        
        for i in range(0, len(self.Model.data)):
            x = self.Model.data['x'][i]
            sx = self.Model.data['sx'][i]
            y = self.Model.data['y'][i]
            sy = self.Model.data['sy'][i]
            
            rowPosition = self.tableData.rowCount()
            
            self.tableData.insertRow(rowPosition) #insert new row
            
            self.tableData.setItem(i, 0, QTableWidgetItem(str(x)))
            self.tableData.setItem(i, 1, QTableWidgetItem(str(sx)))
            self.tableData.setItem(i, 2, QTableWidgetItem(str(y)))
            self.tableData.setItem(i, 3, QTableWidgetItem(str(sy)))
            
            self.tableData.resizeRowsToContents()

		        
def main():
    win = MainWindow()
    win.show()
    sys.exit(app.exec_())
    
if __name__ == "__main__":
    main()
