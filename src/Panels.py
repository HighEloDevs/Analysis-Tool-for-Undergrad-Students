# -*- coding: utf-8 -*-
"""
Created on Sat Jan 30 16:33:29 2021

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

# Parameters
WINDOW_WIDTH = 1500
WINDOW_HEIGHT = 600

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
        self.Left.resize(int(WINDOW_WIDTH / 3), WINDOW_HEIGHT-20)
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
        self.Middle.resize(int(WINDOW_WIDTH / 3), WINDOW_HEIGHT-20)
        self.Middle.setFrameShape(QFrame.StyledPanel)
        
        # Middle panel layout
        MiddleLayout = QVBoxLayout()
        
        # Initialize tab screen
        self.MiddleTabs = QTabWidget()
        self.MiddleTabs.resize(300,200)
        
        self.tabPropriedades = QWidget()
        self.tabX = QWidget()
        self.tabY = QWidget()
        
        # Adding tabs
        self.MiddleTabs.addTab(self.tabPropriedades,"Propriedades")
        self.MiddleTabs.addTab(self.tabX,"Eixo X")
        self.MiddleTabs.addTab(self.tabY,"Eixo Y")
        
        # Create first tab
        self.tabPropriedades.layout = QVBoxLayout(self)
        self.pushButton1 = QPushButton("PyQt5 button")
        self.tabPropriedades.layout.addWidget(self.pushButton1)
        self.tabPropriedades.setLayout(self.tabPropriedades.layout)
        
        test = QWidget()
        testLayout = QFormLayout(test)
        
        PlotButton = QPushButton("Plot")
        
        testLayout.addRow(PlotButton)

        
        MiddleLayout.addWidget(self.MiddleTabs)
        MiddleLayout.addWidget(test)
        
        self.Middle.setLayout(MiddleLayout)
        
        
    def RightPanel(self):
        self.Right = QFrame(self)
        self.Right.move(1000, 0)
        self.Right.resize(int(WINDOW_WIDTH / 3), WINDOW_HEIGHT-20)
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