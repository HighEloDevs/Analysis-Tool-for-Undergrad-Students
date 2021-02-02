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
from src.Model import Model
from src.PltWidget import Canvas, MyToolbar

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar

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
        
        # ComboBoxes for the tableData
        self.ComboBoxes = []
        
        # Argument to clear the image
        self.scatter = None
        
        # Params for the graph
        self.PontoCor = ""
        self.PontoSimbolo = ""
        self.PontoTamanho = 1
        
        self.Titulo = ""
        self.tEixox = ""
        self.tEixoy = ""
        
        self.Grade = False
        self.Residuos = False
        
        # Setting up UI
        self.initUI()
        
    def initUI(self):
        # Main Layout
        self.mainLayout = QHBoxLayout(self)
        
        # Setting up three main panels
        self.LeftPanel()
        self.MiddlePanel()
        self.RightPanel()
        
        # Creating Splitter and adding the panels
        Splitter = QSplitter(QtCore.Qt.Horizontal)
        Splitter.addWidget(self.Left)
        Splitter.addWidget(self.Middle)
        Splitter.addWidget(self.Right)
        
        # Setting Strech Factor
        Splitter.setStretchFactor(0, 1)
        Splitter.setStretchFactor(1, 2)
        Splitter.setStretchFactor(2, 3)
        
        # Some Splitter's properties
        Splitter.setHandleWidth(2)
        Splitter.setCollapsible(0, False)
        Splitter.setCollapsible(1, False)
        
        # Adding Splitter to the main layout
        self.mainLayout.addWidget(Splitter)
        
        # Setting mainLayout as main widget
        self.setLayout(self.mainLayout)
        
# =============================================================================
#         Left Panel
# =============================================================================
        
    def LeftPanel(self):
        # Creating left panel
        self.Left = QFrame(self)
        self.Left.setMinimumWidth(400)
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
        
        # Removing Headers
        self.tableData.horizontalHeader().hide()
        self.tableData.verticalHeader().hide()
        
        # Set row count
        self.tableData.setRowCount(1)
        
        # Set column count
        self.tableData.setColumnCount(4)
        
        # Creating the ComboBoxes
        for i in range(4):
            item = QComboBox()
            item.setEditable(True)
            item.lineEdit().setAlignment(QtCore.Qt.AlignHCenter)
            self.ComboBoxes.append(item)
        
        self.ComboBoxes[0].addItems(["x", "y", "sy", "sx"])
        self.ComboBoxes[1].addItems(["y", "sy", "sx", "x"])
        self.ComboBoxes[2].addItems(["sy", "sx", "x", "y"])
        self.ComboBoxes[3].addItems(["sx", "x", "y", "sy"])
        
        # Adding ComboBoxes to the table
        for i in range(4):
            self.tableData.setCellWidget(0, i, self.ComboBoxes[i])
        
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
        
# =============================================================================
#         MiddlePanel
# =============================================================================
        
    def MiddlePanel(self):
        self.Middle = QFrame(self)
        self.Middle.setMinimumWidth(400)
        self.Middle.setFrameShape(QFrame.StyledPanel)
        
        # Middle panel layout
        MiddleLayout = QVBoxLayout()
        
        # Initialize tab screen
        self.MiddleTabs = QTabWidget()
        
        tabFuncao = QWidget()
        tabPropriedades = QWidget()
        tabExemplos = QWidget()
        
        # Adding tabs
        self.MiddleTabs.addTab(tabFuncao,"Função de Ajuste")
        self.MiddleTabs.addTab(tabPropriedades,"Propriedades do Gráfico")
        self.MiddleTabs.addTab(tabExemplos,"Exemplos")
        
# =============================================================================
#         Tab "Função de Ajuste"
# =============================================================================
        
        self.FuncaoLineEdit = QLineEdit()
        
        tabFuncaoLayout = QFormLayout()
        tabFuncaoLayout.addRow(QLabel("Expressão | y(x) = "), self.FuncaoLineEdit)

        
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
        
        self.infos = QLabel("")
        self.infos.setTextInteractionFlags(Qt.TextSelectableByMouse)
        self.infos.setFont(QFont('Times font', 11))
        
        # Adding table to the middle panel
        tabFuncaoLayout.addRow(self.tableCoef)
        tabFuncaoLayout.addRow(self.infos)
        
        # Setting layout for the "Função de Ajuste" tab
        tabFuncao.setLayout(tabFuncaoLayout)
        
        
# =============================================================================
#         Tab "Propriedades"
# =============================================================================
        
        # Combo Boxes
        self.qPontoCor = QComboBox()
        self.qPontoTamanho = QComboBox()
        self.qPontoSimbolo = QComboBox()
        
        # Check Marks
        self.qGrade = QCheckBox()
        self.qResiduos = QCheckBox()
        
        # Lines Edit
        self.qTitulo = QLineEdit()
        self.qtEixox = QLineEdit()
        self.qtEixoy = QLineEdit()

        tabPropriedadesLayout = QFormLayout()
        tabPropriedades.layout = tabPropriedadesLayout
        
        SymbolWidget = QWidget()
        SymbolWidgetLayout = QHBoxLayout()
        SymbolWidgetLayout.addWidget(QLabel("Símbolo"))
        SymbolWidgetLayout.addWidget(self.qPontoCor)
        SymbolWidgetLayout.addWidget(self.qPontoTamanho)
        SymbolWidgetLayout.addWidget(self.qPontoSimbolo)
        SymbolWidget.setLayout(SymbolWidgetLayout)
        tabPropriedadesLayout.addRow(SymbolWidget)
        
        TitulosWidget = QWidget()
        TitulosLayout = QFormLayout()
        TitulosLayout.addRow(QLabel("Título"), self.qTitulo)
        TitulosLayout.addRow(QLabel("Eixo X"), self.qtEixox)
        TitulosLayout.addRow(QLabel("Eixo Y"), self.qtEixoy)
        TitulosWidget.setLayout(TitulosLayout)
        tabPropriedadesLayout.addRow(TitulosWidget)
        
        ChecksWidget = QWidget()
        ChecksWidgetLayout = QHBoxLayout()
        ChecksWidgetLayout.addWidget(QLabel("Grade:"))
        ChecksWidgetLayout.addWidget(self.qGrade)
        ChecksWidgetLayout.addWidget(QLabel("Resíduos:"))
        ChecksWidgetLayout.addWidget(self.qResiduos)
        ChecksWidget.setLayout(ChecksWidgetLayout)
        tabPropriedadesLayout.addRow(ChecksWidget)
        
        tabPropriedades.setLayout(tabPropriedades.layout)
        
        
# =============================================================================
#         Tab "Exemplos"
# =============================================================================
        
        # Layout of the tab
        tabExemplosLayout = QVBoxLayout()
        
        textExemplos = QLabel("""
ETpofepofeope
dspfedgg
                              """)

        tabExemplosLayout.addWidget(textExemplos)

        tabExemplos.setLayout(tabExemplosLayout)
        
        # Plot button
        PlotButton = QPushButton("Plot")
        PlotButton.clicked.connect(self.Plot)

        # Adding Widgets
        MiddleLayout.addWidget(self.MiddleTabs)
        MiddleLayout.addWidget(PlotButton)
        
        # Fishing middle layout
        self.Middle.setLayout(MiddleLayout)
        
# =============================================================================
#         Right Panel
# =============================================================================
        
    def RightPanel(self):
        self.Right = QFrame(self)
        self.Right.resize(600, WINDOW_HEIGHT-20)
        self.Right.setFrameShape(QFrame.StyledPanel)
        self.Right.setMinimumWidth(800)
        
        # Right panel layout
        RightPanelLayout = QVBoxLayout()
        
        self.canvas = Canvas(self, width=7, height=7, dpi=200)
        #self.canvas.axes.scatter()
        
        # toolbar = NavigationToolbar(self.canvas, self)
        toolbar = MyToolbar(self.canvas, self)
        
        RightPanelLayout.addWidget(toolbar)
        RightPanelLayout.addWidget(self.canvas)
    
        self.Right.setLayout(RightPanelLayout)
        
# =============================================================================
#         Some Functions
# =============================================================================
        
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
        
        self.tableData.setRowCount(len(self.Model.data['x']) + 1)
        
        for i in range(0, len(self.Model.data)):
            x = self.Model.data['x'][i]
            sx = self.Model.data['sx'][i]
            y = self.Model.data['y'][i]
            sy = self.Model.data['sy'][i]
            
            itemx = QTableWidgetItem(str(x))
            itemx.setTextAlignment(QtCore.Qt.AlignCenter)
            
            itemsx = QTableWidgetItem(str(sx))
            itemsx.setTextAlignment(QtCore.Qt.AlignCenter)
            
            itemy = QTableWidgetItem(str(y))
            itemy.setTextAlignment(QtCore.Qt.AlignCenter)
            
            itemsy = QTableWidgetItem(str(sy))
            itemsy.setTextAlignment(QtCore.Qt.AlignCenter)
            
            self.tableData.setItem(i + 1, 0, itemx)
            self.tableData.setItem(i + 1, 1, itemy)
            self.tableData.setItem(i + 1, 2, itemsy)
            self.tableData.setItem(i + 1, 3, itemsx)
            
            self.tableData.resizeRowsToContents()
        
    def Plot(self):
        # Instance
        coefs = []
        
        # Getting Expression
        expr = self.FuncaoLineEdit.text()
        
        # Setting Model
        self.Model.set_expression(expr)
        
        # Getting Coeficients
        coefs = self.Model.get_coefficients()
        
        flags = [0]*6
        flags[0] = self.ComboBoxes[0].currentText() == self.ComboBoxes[1].currentText()
        flags[1] = self.ComboBoxes[0].currentText() == self.ComboBoxes[2].currentText()
        flags[2] = self.ComboBoxes[0].currentText() == self.ComboBoxes[3].currentText()
        flags[3] = self.ComboBoxes[1].currentText() == self.ComboBoxes[2].currentText()
        flags[4] = self.ComboBoxes[1].currentText() == self.ComboBoxes[3].currentText()
        flags[5] = self.ComboBoxes[2].currentText() == self.ComboBoxes[3].currentText()
        
        if True in flags:
            msg = QMessageBox()
            msg.setIcon(QMessageBox.Critical)
            msg.setText("Colunas com nomes iguais! Verifique a tabela de dados.")
            msg.setWindowTitle("Error")
            msg.exec_()
        else:
            if len(coefs) >= 4:
                self.tableCoef.setRowCount(0)
            
                for i in range(0, len(coefs)):
                    rowPosition = self.tableCoef.rowCount()     
                    self.tableCoef.insertRow(rowPosition) 
                    item = QTableWidgetItem(coefs[i])
                    item.setTextAlignment(QtCore.Qt.AlignCenter)
                    self.tableCoef.setItem(i, 0, item)
            else:
                for i in range(0, len(coefs)):
                    item = QTableWidgetItem(coefs[i])
                    item.setTextAlignment(QtCore.Qt.AlignCenter)
                    self.tableCoef.setItem(i, 0, item)
                    
            # Getting data from "Propriedades do gráfico"
            self.Titulo = self.qTitulo.text()
            self.tEixox = self.qtEixox.text()
            self.tEixoy = self.qtEixoy.text()
            
            self.Grade = self.qGrade.isChecked()
            self.Residuos = self.qResiduos.isChecked()
            
            self.PontoCor = self.qPontoCor.currentText()
            self.PontoTamanho = self.qPontoTamanho.currentText()
            self.PontoSimbolo = self.qPontoSimbolo.currentText()
                    
            columns = [self.ComboBoxes[i].currentText() for i in range(4)]
            self.Model.data.columns = columns
            
            self.Model.fit()
            self.infos.setText(str(self.Model))
            if self.scatter is not None:
                self.scatter.remove()
                self.canvas.axes.cla()
            x, y, sy, sx = self.Model.get_data()
            #self.canvas.axes.scatter(x, y, s = 2, c = "blue", marker = '.',  linewidths = 1)
            self.scatter = self.canvas.axes.errorbar(x, y, yerr=sy, xerr=sx, fmt = 'bo',
                                      ecolor = 'black', capsize = 2, ms = 0, elinewidth = 0.5)
            px, py =self.Model.get_predict()
            self.canvas.axes.plot(px, py, lw = 1, c = 'red')
            self.canvas.fig.canvas.draw()
            self.canvas.fig.canvas.flush_events()
            
            coefs = self.Model.get_params()
            keys = list(coefs.keys())
            
            for i in range(len(keys)):
                item1 = QTableWidgetItem(f"{coefs[keys[i]][0]:.5E}")
                item1.setTextAlignment(QtCore.Qt.AlignCenter)
                self.tableCoef.setItem(i, 1, item1)
                
                item2 = QTableWidgetItem(f"{coefs[keys[i]][1]:.5E}")
                item2.setTextAlignment(QtCore.Qt.AlignCenter)
                self.tableCoef.setItem(i, 2, item2)
        
        
        
        
        
        
        
        
        
        