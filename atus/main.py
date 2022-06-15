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
from matplotlib_backend_qtquick_2.backend_qtquickagg import (
    FigureCanvasQtQuickAgg,
)
from PyQt5.QtCore import QCoreApplication, QObject, Qt, QUrl, QThread
from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType
from PyQt5.QtWidgets import QApplication

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from src.GlobalManager import GlobalManager
from src.GoogleDriveAPI import GDrive
from src.Histogram import Histogram
from src.MatPlotLib import Canvas
from src.MessageHandler import MessageHandler
from src.Model import Model
from src.MultiPlot import Multiplot
from src.Plot import SinglePlot
from src.UpdateChecker import UpdateChecker
from src.PyLatex import PyLatex

plt.rcParams["ytick.minor.visible"] = False
plt.rcParams["xtick.minor.visible"] = False
plt.rcParams["figure.subplot.left"] = 0.1
plt.rcParams["figure.subplot.right"] = 0.95
plt.rcParams["figure.subplot.bottom"] = 0.12
plt.rcParams["figure.subplot.top"] = 0.92
plt.rcParams["figure.subplot.hspace"] = 0.0


def main(pip: bool = True):
    if pip:
        print("Initializing Analysis Tool for Undergrad Students...")

    # Matplotlib stuff
    qmlRegisterType(FigureCanvasQtQuickAgg, "Canvas", 1, 0, "FigureCanvas")
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    # Setting up app
    app = QApplication(sys.argv)
    app.setOrganizationName("High Elo Devs")
    app.setOrganizationDomain(
        "https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS"
    )
    app.setApplicationName("Analysis Tool for Undergrad Students")
    app.setWindowIcon(
        QIcon(
            os.path.join(
                os.path.dirname(__file__), "images/main_icon/ATUS_icon.png"
            )
        )
    )
    engine = QQmlApplicationEngine()

    messageHandler = MessageHandler()
    canvas = Canvas(messageHandler)
    model = Model(messageHandler)
    singlePlot = SinglePlot(canvas, model, messageHandler)
    multiPlot = Multiplot(canvas, messageHandler)
    updater = UpdateChecker(pip)
    histogram = Histogram(canvas, messageHandler)
    gdrive = GDrive(messageHandler)
    globalManager = GlobalManager()
    pylatex = PyLatex()

    thread = QThread()
    thread.start(5)
    pylatex.moveToThread(thread)

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
    context.setContextProperty("pylatex", pylatex)

    # Loading canvas window
    engine.load(
        QUrl.fromLocalFile(
            os.path.join(
                os.path.dirname(__file__), "qml/controls/CanvasWindow.qml"
            )
        )
    )
    context.setContextProperty("canvasWindow", engine.rootObjects()[0])

    # Loading main window
    engine.load(
        QUrl.fromLocalFile(
            os.path.join(os.path.dirname(__file__), "qml/main_window.qml")
        )
    )

    # Updating canvasPlot with the plot
    canvas.update_with_canvas(
        engine.rootObjects()[1].findChild(QObject, "canvasPlot")
    )

    # Stopping program if PyQt fails loading the file
    if not engine.rootObjects():
        sys.exit(-1)

    # Starting program
    sys.exit(app.exec_())  # app.exec PyQt6


if __name__ == "__main__":
    main(False)
