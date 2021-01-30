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
        super().__init__()
        
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
        self.tableData.setEditTriggers(QAbstractItemView.NoEditTriggers)
        
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

        LeftLayout.addWidget(self.InputArea)
        LeftLayout.addWidget(self.tableData)

        # Creating left panel's layout
        self.Left.setLayout(LeftLayout)
        
    def MiddlePanel(self):
        self.Middle = QFrame(self)
        self.Middle.move(500, 0)
        self.Middle.resize(400, WINDOW_HEIGHT-20)
        self.Middle.setFrameShape(QFrame.StyledPanel)
        
        # Middle panel layout
        MiddleLayout = QVBoxLayout()
        
        # Initialize tab screen
        self.MiddleTabs = QTabWidget()
        self.MiddleTabs.resize(300,100)
        
        tabFuncao = QWidget()
        tabPropriedades = QWidget()
        tabX = QWidget()
        tabY = QWidget()
        
        # Adding tabs
        self.MiddleTabs.addTab(tabFuncao,"Função de Ajuste")
        self.MiddleTabs.addTab(tabX,"Eixo X")
        self.MiddleTabs.addTab(tabY,"Eixo Y")
        self.MiddleTabs.addTab(tabPropriedades,"Propriedades do Gráfico")
        
        ####################### Tab "Função de Ajuste" #######################
        
        self.FuncaoLineEdit = QLineEdit()
        self.buttonAplicarFuncao = QPushButton("Aplicar Função")
        self.buttonAplicarFuncao.clicked.connect(self.ApplyFunction)
        
        tabFuncaoLayout = QFormLayout()
        tabFuncaoLayout.addRow(QLabel("Expressão | y(x) = "), self.FuncaoLineEdit)
        tabFuncaoLayout.addRow(self.buttonAplicarFuncao)
        
        # Creating table for the coeficients
        self.tableCoef = QTableWidget()
        self.tableCoef.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.tableCoef.setFixedHeight(150)
        self.tableCoef.setRowCount(4)
        self.tableCoef.setColumnCount(3)
        self.tableCoef.setHorizontalHeaderLabels(['Parâmetros', 'Valores', 'Incertezas'])
        self.tableCoef.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
        self.tableCoef.horizontalHeader().setSectionResizeMode(0, QtWidgets.QHeaderView.Stretch)
        self.tableCoef.horizontalHeader().setSectionResizeMode(1, QtWidgets.QHeaderView.Stretch)
        self.tableCoef.horizontalHeader().setSectionResizeMode(2, QtWidgets.QHeaderView.Stretch)
        
        # Creting table for the fit's infos
        self.tableInfo = QTableWidget()
        self.tableInfo.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.tableInfo.setFixedHeight(300)
        self.tableInfo.setRowCount(8)
        self.tableInfo.setColumnCount(2)
        self.tableInfo.setHorizontalHeaderLabels(['Teste', 'Valores'])
        self.tableInfo.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
        self.tableInfo.horizontalHeader().setSectionResizeMode(0, QtWidgets.QHeaderView.Stretch)
        self.tableInfo.horizontalHeader().setSectionResizeMode(1, QtWidgets.QHeaderView.Stretch)
        
        # Adding table to the middle panel
        tabFuncaoLayout.addRow(self.tableCoef)
        tabFuncaoLayout.addRow(self.tableInfo)
        
        # Setting layout for the "Função de Ajuste" tab
        tabFuncao.setLayout(tabFuncaoLayout)
        
        ######################### Tab "Propriedades" #########################
        
        tabPropriedadesLayout = QFormLayout()
        tabPropriedades.layout = tabPropriedadesLayout
        
        SymbolWidget = QWidget()
        SymbolWidgetLayout = QHBoxLayout()
        SymbolWidgetLayout.addWidget(QLabel("Símbolo"))
        SymbolWidgetLayout.addWidget(QComboBox())
        SymbolWidgetLayout.addWidget(QComboBox())
        SymbolWidgetLayout.addWidget(QComboBox())
        SymbolWidget.setLayout(SymbolWidgetLayout)
        
        pushButton1 = QCheckBox()
        tabPropriedadesLayout.addRow(SymbolWidget)
        
        tabPropriedades.setLayout(tabPropriedades.layout)
        
        ######################################################################
        
        test = QWidget()
        testLayout = QFormLayout(test)
        
        PlotButton = QPushButton("Plot")
        
        testLayout.addRow(PlotButton)

        MiddleLayout.addWidget(self.MiddleTabs)
        MiddleLayout.addWidget(test)
        
        self.Middle.setLayout(MiddleLayout)
        
        
    def RightPanel(self):
        self.Right = QFrame(self)
        self.Right.move(900, 0)
        self.Right.resize(600, WINDOW_HEIGHT-20)
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
            
    def ApplyFunction(self):
        # Instance
        coefs = []
        
        # Getting Expression
        expr = self.FuncaoLineEdit.text()
        
        # Setting Model
        self.Model.set_expression(expr)
        
        # Getting Coeficients
        coefs = self.Model.get_coefficients()
        
        if len(coefs) >= 4:
            self.tableCoef.setRowCount(0)
        
            for i in range(0, len(coefs)):
                rowPosition = self.tableCoef.rowCount()     
                self.tableCoef.insertRow(rowPosition) #insert new row   
                self.tableCoef.setItem(i, 0, QTableWidgetItem(coefs[i]))
        else:
            for i in range(0, len(coefs)):
                self.tableCoef.setItem(i, 0, QTableWidgetItem(coefs[i]))
        
        
        
        
        
        
        
        
        
        
        
        
        