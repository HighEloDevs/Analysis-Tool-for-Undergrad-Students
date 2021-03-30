# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

Main File

"""
from operator import mod
import sys
import os
from PySide2 import QtGui, QtQml, QtCore
from PySide2.QtCore import Qt, Slot, Signal
from matplotlib_backend_qtquick.backend_qtquickagg import FigureCanvasQtQuickAgg
from src.MatPlotLib import DisplayBridge
from src.Model import Model
from src.Calculators import CalculatorCanvas, interpreter_calculator, Plot
from src.ProjectManager import ProjectManager

# Instantiating the display bridge || Global variable, fuck the world
displayBridge = DisplayBridge()

# Instantiating the fit class
model = Model() 

class Bridge(QtCore.QObject):
    # Signal to Properties page
    signalPropPage = Signal()

    # Signal to write infos
    writeInfos = Signal(str, arguments='expr')
    writeCalculator = Signal(str, arguments='expr')

    @Slot(str)
    def loadData(self, file_path):
        """Gets the path to data's file and fills the data's table"""
        model.load_data(QtCore.QUrl(file_path).toLocalFile())

    @Slot(str, str, str, int, int, int, int, str, int, str, str, int, str, int)
    def loadOptions(self, title, xaxis, yaxis, residuals, grid, log_x, log_y, symbol_color, symbol_size, symbol, curve_color, curve_thickness, curve_style, legend):
        """Gets the input options and set them to the model"""
        curveStyles = {
            'Sólido':'-',
            'Tracejado':'--',
            'Ponto-Tracejado':'-.'
            }
        symbols = {
            'Círculo':'o',
            'Triângulo':'^',
            'Quadrado':'s',
            'Pentagono':'p',
            'Octagono':'8',
            'Cruz':'P',
            'Estrela':'*',
            'Diamante':'d',
            'Produto':'X'
            }

        # Setting style of the plot
        model.set_title(title)
        model.set_x_axis(xaxis)
        model.set_y_axis(yaxis)
        displayBridge.setStyle(log_x, log_y, symbol_color, symbol_size, symbols[symbol], curve_color, curve_thickness, curveStyles[curve_style], legend, model.exp_model.replace('**', '^'))

        # Making plot
        displayBridge.Plot(model, residuals, grid)
    
    @Slot(str, str, int, int)
    def loadExpression(self, expression, p0, wsx, wsy):
        """Gets the expression and set it up"""

        displayBridge.setSigma(wsx, wsy)

        # Setting up initial parameters
        p0_tmp = list()
        if p0 != '':
            # Anti-dummies system
            p0 = p0.replace(';', ',')
            p0 = p0.replace('/', ',')
            for i in p0.split(','):
                p0_tmp.append(float(i))
            model.set_p0(p0_tmp)
            print(p0_tmp)

        # Anti-dummies system 2
        expression = expression.replace('^', '**')
        expression = expression.replace('arctan', 'atan')
        expression = expression.replace('arcsin', 'asin')
        expression = expression.replace('arccos', 'acos')
        expression = expression.replace('sen', 'sin')
        
        # Setting expression
        model.set_expression(expression)

        # Emitting signal to load the options
        self.signalPropPage.emit()

    @Slot(str)
    def savePlot(self, save_path):
        """Gets the path from input and save the actual plot"""
        displayBridge.figure.savefig(QtCore.QUrl(save_path).toLocalFile(), dpi = 400)

    @Slot(str, str, str, str, str, str)
    def calculator(self, function, opt1, nc, ngl, mean, std):
        functionDict = {
            'Chi²':0,
            'Chi² Reduzido':1,
            'Gaussiana':2,
            'Student':3
        }
        methodDict = {
            'Simétrico de Dois Lados':0,
            'Apenas Limite Inferior':1,
            'Apenas Limite Superior':2
        }   
        try:
            nc = nc.replace(',', '.')
            nc = float(nc)
        except:
            pass
        try:
            ngl = ngl.replace(',', '.')
            ngl = float(ngl)
        except:
            pass
        try:
            mean = mean.replace(',', '.')
            mean = float(mean)
        except:
            pass
        try:
            std = std.replace(',', '.')
            std = float(std)
        except:
            pass

        s, x, y, x_area, y_area = interpreter_calculator(functionDict[function], methodDict[opt1], nc, ngl, mean, std)
        Plot(displayBridge, x, y, x_area, y_area)
        self.writeCalculator.emit(s)

if __name__ == "__main__":
    # Matplotlib stuff
    QtQml.qmlRegisterType(FigureCanvasQtQuickAgg, "Canvas", 1, 0, "FigureCanvas")
    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)

    # Setting up app
    app = QtGui.QGuiApplication(sys.argv)
    app.setOrganizationName("High Elo Devs")
    app.setOrganizationDomain("https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS")
    app.setApplicationName("Analysis Tool for Undergrad Students")
    app.setWindowIcon(QtGui.QIcon(os.path.join(os.path.dirname(__file__), "ATUS Icon 3.png")))
    engine = QtQml.QQmlApplicationEngine()

    # Creating bridge
    bridge = Bridge()

    # Project Manager
    projectMngr = ProjectManager(displayBridge, model)

    # Creating 'link' between front-end and back-end
    context = engine.rootContext()
    context.setContextProperty("displayBridge", displayBridge)
    context.setContextProperty("backend", bridge)
    context.setContextProperty("model", model)
    context.setContextProperty("projectMngr", projectMngr)
    
    # Loading QML files
    engine.load(QtCore.QUrl.fromLocalFile(os.path.join(os.path.dirname(__file__), "qml/main.qml")))

    # Updating canvasPlot with the plot
    win = engine.rootObjects()[0]
    displayBridge.updateWithCanvas(win.findChild(QtCore.QObject, "canvasPlot"))
    
    # Stopping program if PySide fails loading the file
    if not engine.rootObjects():
        sys.exit(-1)    

    # Starting program
    sys.exit(app.exec_())