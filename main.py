# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

Main File

"""
import sys
import os

from PySide2 import QtGui, QtQml, QtCore
from PySide2.QtCore import Qt, Slot, Signal

from matplotlib_backend_qtquick.backend_qtquickagg import FigureCanvasQtQuickAgg
from src.MatPlotLib import DisplayBridge
from src.Model import Model
from src.Calculators import CalculatorCanvas

# Instantiating the display bridge || Global variable, fuck the world
displayBridge = DisplayBridge()
calculatorCanvas = CalculatorCanvas()

class Bridge(QtCore.QObject):
    # Instantiating the fit class
    model = Model() 

    # Signal fillDataTable
    fillDataTable = Signal(str, str, str, str, str, arguments=['x', 'y', 'sy', 'sx', 'filename'])

    # Signal fillParamsTable
    fillParamsTable = Signal(str, str, str, arguments=['param', 'value', 'uncertainty'])

    # Signal to Properties page
    signalPropPage = Signal()

    # Signal to write infos
    writeInfos = Signal(str, arguments='expr')

    @Slot(str)
    def loadData(self, file_path):
        """Gets the path to data's file and fills the data's table"""
        self.model.load_data(QtCore.QUrl(file_path).toLocalFile())
        x, y, sy, sx = self.model.get_data()        

        # Getting file's name
        fileName = QtCore.QUrl(file_path).toLocalFile().split('/')[-1]
        if self.model.has_sx and self.model.has_sy:
            for i in range(len(x)):
                self.fillDataTable.emit("{:.2g}".format(x[i]), "{:.2g}".format(y[i]), "{:.2g}".format(sy[i]), "{:.2g}".format(sx[i]), fileName)
        elif self.model.has_sx:
            for i in range(len(x)):
                self.fillDataTable.emit("{:.2g}".format(x[i]), "{:.2g}".format(y[i]), "", "{:.2g}".format(sx[i]), fileName)
        elif self.model.has_sy:
            for i in range(len(x)):
                self.fillDataTable.emit("{:.2g}".format(x[i]), "{:.2g}".format(y[i]), "{:.2g}".format(sy[i]), "", fileName)
        else:
            for i in range(len(x)):
                self.fillDataTable.emit("{:.2g}".format(x[i]), "{:.2g}".format(y[i]), "", "", fileName)

    @Slot(str, str, str, int, int, int, int, str, int, str, str, int, str)
    def loadOptions(self, title, xaxis, yaxis, residuals, grid, log_x, log_y, symbol_color, symbol_size, symbol, curve_color, curve_thickness, curve_style):
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
            'Produto':'x'
            }

        # Setting style of the plot
        self.model.set_title(title)
        self.model.set_x_axis(xaxis)
        self.model.set_y_axis(yaxis)
        displayBridge.setStyle(log_x, log_y, symbol_color, symbol_size, symbols[symbol], curve_color, curve_thickness, curveStyles[curve_style])

        # Making plot
        displayBridge.Plot(self.model, residuals, grid)

        # Filling paramsTable
        params = self.model.get_params()
        keys = list(params.keys())
            
        for i in range(len(keys)):
            self.fillParamsTable.emit(keys[i], "{:.8g}".format(params[keys[i]][0]), "{:.8g}".format(params[keys[i]][1]))

        # Writing infos
        self.writeInfos.emit(self.model.report_fit)
    
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
            self.model.set_p0(p0_tmp)

        # Anti-dummies system 2
        expression = expression.replace('^', '**')
        expression = expression.replace('arctan', 'atan')
        expression = expression.replace('arcsin', 'asin')
        expression = expression.replace('arccos', 'acos')
        expression = expression.replace('sen', 'sin')
        
        # Setting expression
        self.model.set_expression(expression)

        # Emitting signal to load the options
        self.signalPropPage.emit()

    @Slot(str)
    def savePlot(self, save_path):
        """Gets the path from input and save the actual plot"""
        displayBridge.figure.savefig(QtCore.QUrl(save_path).toLocalFile(), dpi = 400)

if __name__ == "__main__":
    # Matplotlib stuff
    QtQml.qmlRegisterType(FigureCanvasQtQuickAgg, "Canvas", 1, 0, "FigureCanvas")
    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)

    # Setting up app
    app = QtGui.QGuiApplication(sys.argv)
    app.setOrganizationName("High Elo Devs")
    app.setOrganizationDomain("https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS")
    app.setApplicationName("Analysis Tool for Undergrad Students")
    app.setWindowIcon(QtGui.QIcon(os.path.join(os.path.dirname(__file__), "images/main_icon/Análise.png")))
    engine = QtQml.QQmlApplicationEngine()

    # Creating bridge
    bridge = Bridge()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty("displayBridge", displayBridge)

    # Creating 'link' between front-end and back-end
    context.setContextProperty("backend", bridge)
    
    # Loading QML files
    engine.load(QtCore.QUrl.fromLocalFile(os.path.join(os.path.dirname(__file__), "qml/main.qml")))

    # Updating canvasPlot with the plot
    win = engine.rootObjects()[0]
    displayBridge.updateWithCanvas(win.findChild(QtCore.QObject, "canvasPlot"))
    calculatorCanvas.updateWithCanvas(win.findChild(QtCore.QObject, "canvasCalculadora"))
    
    # Stopping program if PySide fails loading the file
    if not engine.rootObjects():
        sys.exit(-1)    

    # Starting program
    sys.exit(app.exec_())