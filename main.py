# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

Main File

"""

import sys
import os
import platform
from matplotlib_backend_qtquick.qt_compat import QtGui, QtQml, QtCore
from matplotlib_backend_qtquick.backend_qtquickagg import FigureCanvasQtQuickAgg
from numpy.core.records import array
from operator import mod
from src.Plot import Bridge 
from src.MatPlotLib import DisplayBridge
from src.Model import Model
from src.Calculators import CalculatorCanvas, interpreter_calculator, Plot
from src.ProjectManager import ProjectManager
from src.MultiPlot import Multiplot
from src.UpdateChecker import UpdateChecker

displayBridge = DisplayBridge()
model = Model() 

if __name__ == "__main__":
    # Matplotlib stuff
    QtQml.qmlRegisterType(FigureCanvasQtQuickAgg, "Canvas", 1, 0, "FigureCanvas")
    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)

    # Setting up app
    app = QtGui.QGuiApplication(sys.argv)
    app.setOrganizationName("High Elo Devs")
    app.setOrganizationDomain("https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS")
    app.setApplicationName("Analysis Tool for Undergrad Students")
    app.setWindowIcon(QtGui.QIcon(os.path.join(os.path.dirname(__file__), "images/main_icon/ATUS_icon.png")))
    engine = QtQml.QQmlApplicationEngine()

    # Creating singlePlot
    singlePlot    = Bridge(displayBridge, model)
    multiplot = Multiplot(displayBridge)
    updater = UpdateChecker()

    # Project Manager
    projectMngr = ProjectManager(displayBridge, model)

    # Creating 'link' between front-end and back-end
    context = engine.rootContext()
    context.setContextProperty("displayBridge", displayBridge)
    context.setContextProperty("plot", singlePlot)
    context.setContextProperty("model", model)
    context.setContextProperty("projectMngr", projectMngr)
    context.setContextProperty("multiplot", multiplot)
    context.setContextProperty("updater", updater)
    
    # Loading QML files
    plat = platform.system()

    if(plat == 'Darwin'):
        engine.load(QtCore.QUrl.fromLocalFile(os.path.join(os.path.dirname(__file__), "qml/main_mac.qml")))
    else:
        engine.load(QtCore.QUrl.fromLocalFile(os.path.join(os.path.dirname(__file__), "qml/main_windows.qml")))
        
    # Updating canvasPlot with the plot
    win = engine.rootObjects()[0]
    displayBridge.updateWithCanvas(win.findChild(QtCore.QObject, "canvasPlot"))
    
    # Stopping program if PySide fails loading the file
    if not engine.rootObjects():
        sys.exit(-1)    

    # Starting program
    sys.exit(app.exec_())