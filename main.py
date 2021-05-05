# -*- coding: utf-8 -*-
"""
MIT License

Copyright (c) 2021 Leonardo Eiji Tamayose, Guilherme Ferrari Fortino

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
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