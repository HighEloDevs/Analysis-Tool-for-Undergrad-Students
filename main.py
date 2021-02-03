# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 11:59:27 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 
"""

import sys
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

# GUI FILER
from source.MainWindow2 import *

# IMPORT FUNCTIONS
from source.ui_functions import *
from source.mplwidget import Canvas, MyToolbar

class MainWindow(QtWidgets.QWidget):
    def __init__(self):
        QMainWindow.__init__(self)

        # Setting up window UI
        self.ui = Ui_Window()
        self.ui.setupUi(self)

        # Toggle Button
        self.ui.BTN_toggle.clicked.connect(lambda: UIFunctions.toggleMenu(self, 150, True))

        # Setting Pages
        # PAGE 1
        self.ui.BTN_Side1.clicked.connect(lambda: self.ui.stackedWidget.setCurrentWidget(self.ui.Page1))
        # PAGE 2
        self.ui.BTN_Side2.clicked.connect(lambda: self.ui.stackedWidget.setCurrentWidget(self.ui.Page2))
        # PAGE 3
        self.ui.BTN_Side3.clicked.connect(lambda: self.ui.stackedWidget.setCurrentWidget(self.ui.Page3))
        # PAGE 4
        self.ui.BTN_Side4.clicked.connect(lambda: self.ui.stackedWidget.setCurrentWidget(self.ui.Page4))

        # Creating canvas
        self.canvas_SemResiduos = Canvas(mode=0, width=7, height=7, dpi=200)
        self.canvas_ComResiduos = Canvas(mode=1, width=7, height=7, dpi=200)
        self.canvas_SemAjuste = Canvas(mode=0, width=7, height=7, dpi=200)

        toolbar1 = MyToolbar(self.canvas_SemResiduos)
        toolbar2 = MyToolbar(self.canvas_ComResiduos)
        toolbar3 = MyToolbar(self.canvas_SemAjuste)

        # Adding canvas and toolbar to the tab
        self.ui.tab_SemResiduos_toolbar.addWidget(toolbar1)
        self.ui.tab_SemResiduos_canvas.addWidget(self.canvas_SemResiduos)

        self.ui.tab_ComResiduos_toolbar.addWidget(toolbar2)
        self.ui.tab_ComResiduos_canvas.addWidget(self.canvas_ComResiduos)

        self.ui.tab_SemAjuste_toolbar.addWidget(toolbar3)
        self.ui.tab_SemAjuste_canvas.addWidget(self.canvas_SemAjuste)

        # Show main window
        self.show()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec_())