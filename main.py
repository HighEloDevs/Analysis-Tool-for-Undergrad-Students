# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 11:59:27 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 
"""

import sys
from source.MainWindow import MainWindow
from PyQt5.QtWidgets import QApplication
from fbs_runtime.application_context.PyQt5 import ApplicationContext
import qdarkstyle



def main():
    # Initializing App
    app = QApplication(sys.argv)
    # appctxt = ApplicationContext()
    
    # Setting Style
    # appctxt.app.setStyle('Fusion')
    # appctxt.app.setStyleSheet(qdarkstyle.load_stylesheet())
    
    app.setStyle('Fusion')
    app.setStyleSheet(qdarkstyle.load_stylesheet())
    
    # Opening Main Window
    win = MainWindow()
    win.show()
    # sys.exit(appctxt.app.exec_())
    sys.exit(app.exec_())
    
if __name__ == "__main__":
    main()      