# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

Main File

"""

import sys
import os

from matplotlib_backend_qtquick.qt_compat import QtGui, QtQml, QtCore
from matplotlib_backend_qtquick.backend_qtquickagg import FigureCanvasQtQuickAgg
from src.MatPlotLib import DisplayBridge
from src.Model import Model

# Instantate the display bridge || Global variable, fuck the world
displayBridge = DisplayBridge()

class Bridge(QtCore.QObject):
    # Instatiating the fit class
    model = Model() 

    # Signal fillDataTable
    fillDataTable = QtCore.Signal(float, float, float, float, str)

    # Signal fillParamsTable
    fillParamsTable = QtCore.Signal(str, str, str)

    # Signal to Properties page
    signalPropPage = QtCore.Signal()

    # Signal to write infos
    writeInfos = QtCore.Signal(str)

    @QtCore.Slot(str)
    def loadData(self, file_path):
        """Gets the path to data's file and fills the data's table"""
        print(file_path)
        self.model.load_data(QtCore.QUrl(file_path).toLocalFile())
        x, y, sy, sx = self.model.get_data()        

        # Getting file's name
        fileName = QtCore.QUrl(file_path).toLocalFile().split('/')[-1]
        for i in range(len(x)):
            print(float(x[i]), y[i], sy[i], sx[i])
            self.fillDataTable.emit(float(x[i]), float(y[i]), float(sy[i]), float(sx[i]), fileName)
        print("Model: Data Loaded")

    @QtCore.Slot(str, str, str, int, int)
    def loadOptions(self, title, xaxis, yaxis, residuals, grid):
        """Gets the input options and set them to the model"""
        print("Título:", title)
        print('Eixo X:', xaxis)
        print('Eixo Y:', yaxis)
        print('Resíduos:', residuals)
        print('Grade:', grid)
        
        self.model.set_title(title)
        self.model.set_x_axis(xaxis)
        self.model.set_y_axis(yaxis)

        # Making plot
        displayBridge.Plot(self.model, residuals, grid)

        # Filling paramsTable
        params = self.model.get_params()
        keys = list(params.keys())
            
        for i in range(len(keys)):
            # self.fillParamsTable.emit(keys[i], params[keys[i]][0], params[keys[i]][1])
            self.fillParamsTable.emit(keys[i], "{:.8g}".format(params[keys[i]][0]), "{:.8g}".format(params[keys[i]][1]))

        # Writing infos
        self.writeInfos.emit(self.model.report_fit)
    
    @QtCore.Slot(str, str)
    def loadExpression(self, expression, p0):
        """Gets the expression and set it up"""
        print("Expressão:", expression)
        print("Parâmetros Iniciais:", p0)
        
        self.model.set_expression(expression)
        self.signalPropPage.emit()

    @QtCore.Slot(str)
    def savePlot(self, save_path):
        """Gets the path from input and save the actual plot"""
        displayBridge.figure.savefig(QtCore.QUrl(save_path).toLocalFile(), dpi = 400)

if __name__ == "__main__":
    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)

    app = QtGui.QGuiApplication(sys.argv)
    app.setOrganizationName("High Elo Jogos")
    app.setOrganizationDomain("https://www.instagram.com/guiiiferrari/")
    app.setApplicationName("Analysis Tool for Undergrad Students")
    engine = QtQml.QQmlApplicationEngine()

    # Creating bridge
    bridge = Bridge()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty("displayBridge", displayBridge)

    # Matplotlib stuff
    QtQml.qmlRegisterType(FigureCanvasQtQuickAgg, "Backend", 1, 0, "FigureCanvas")

    # Creating 'link' between front-end and back-end
    engine.rootContext().setContextProperty("funcs", bridge)
    
    # Loading QML files
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    # Updating canvasPlot with the plot
    win = engine.rootObjects()[0]
    displayBridge.updateWithCanvas(win.findChild(QtCore.QObject, "canvasPlot"))
    
    # Stopping program if PySide fails loading the file
    if not engine.rootObjects():
        sys.exit(-1)

    # Starting program
    sys.exit(app.exec_())