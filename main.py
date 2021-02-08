# This Python file uses the following encoding: utf-8
import sys
import os
from pathlib import Path
from matplotlib_backend_qtquick.qt_compat import QtGui, QtQml, QtCore
from matplotlib_backend_qtquick.backend_qtquickagg import FigureCanvasQtQuickAgg
from PySide2.QtCore import QObject, Slot, Signal
from src.MatPlotLib import DisplayBridge

class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

if __name__ == "__main__":
    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)
    # app = QGuiApplication(sys.argv)
    # engine = QQmlApplicationEngine()

    app = QtGui.QGuiApplication(sys.argv)
    engine = QtQml.QQmlApplicationEngine()

    # Creating MainWindow
    main = MainWindow()

    # Instantate the display bridge
    displayBridge = DisplayBridge()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty("displayBridge", displayBridge)

    # Matplotlib stuff
    QtQml.qmlRegisterType(FigureCanvasQtQuickAgg, "Backend", 1, 0, "FigureCanvas")

    # Creating 'link' between front-end and back-end
    engine.rootContext().setContextProperty("backend", main)

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