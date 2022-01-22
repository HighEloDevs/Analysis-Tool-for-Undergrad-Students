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

import os
import sys
import matplotlib.pyplot as plt
from src.Model import Model
from src.Plot import SinglePlot 
from src.MultiPlot import Multiplot
from src.MatPlotLib import Canvas
from src.UpdateChecker import UpdateChecker
from src.MessageHandler import MessageHandler
from src.GoogleDriveAPI import GDrive
from src.Histogram import Histogram
from src.GlobalManager import GlobalManager
from PyQt5.QtCore import QCoreApplication, QUrl, QObject, Qt
from PyQt5.QtQml import qmlRegisterType, QQmlApplicationEngine
from PyQt5.QtGui import QIcon, QGuiApplication
from matplotlib_backend_qtquick.backend_qtquickagg import FigureCanvasQtQuickAgg

plt.rcParams["ytick.minor.visible"]   = False
plt.rcParams["xtick.minor.visible"]   = False
plt.rcParams["figure.subplot.left"]   = 0.1
plt.rcParams["figure.subplot.right"]  = 0.95
plt.rcParams["figure.subplot.bottom"] = 0.12
plt.rcParams["figure.subplot.top"]    = 0.92
plt.rcParams["figure.subplot.hspace"] = 0.

def main():
    # Matplotlib stuff
    qmlRegisterType(FigureCanvasQtQuickAgg, "Canvas", 1, 0, "FigureCanvas")
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    # Setting up app
    app = QGuiApplication(sys.argv)
    app.setOrganizationName("High Elo Devs")
    app.setOrganizationDomain("https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS")
    app.setApplicationName("Analysis Tool for Undergrad Students")
    app.setWindowIcon(QIcon(os.path.join(os.path.dirname(__file__), "images/main_icon/ATUS_icon.png")))
    engine = QQmlApplicationEngine()

    messageHandler  = MessageHandler()
    canvas          = Canvas(messageHandler)
    model           = Model(messageHandler) 
    singlePlot      = SinglePlot(canvas, model, messageHandler)
    multiPlot       = Multiplot(canvas, messageHandler)
    updater         = UpdateChecker()
    histogram       = Histogram(canvas, messageHandler)
    gdrive          = GDrive(messageHandler)
    globalManager   = GlobalManager()

    # Creating 'link' between front-end and back-end
    context = engine.rootContext()
    context.setContextProperty("singlePlot", singlePlot)
    context.setContextProperty("multiPlot", multiPlot)
    context.setContextProperty("canvas", canvas)
    context.setContextProperty("model", model)
    context.setContextProperty("updater", updater)
    context.setContextProperty("messageHandler", messageHandler)
    context.setContextProperty("hist", histogram)
    context.setContextProperty("gdrive", gdrive)
    context.setContextProperty("globalManager", globalManager)

    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(__file__), "qml/main_windows.qml")))
        
    # Updating canvasPlot with the plot
    win = engine.rootObjects()[0]
    canvas.update_with_canvas(win.findChild(QObject, "canvasPlot"))

    # Stopping program if PyQt fails loading the file
    if not engine.rootObjects():
        sys.exit(-1)    

    # Starting program
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()