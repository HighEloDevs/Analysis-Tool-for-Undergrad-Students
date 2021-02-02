# -*- coding: utf-8 -*-
"""
Created on Tue Feb  2 10:53:30 2021

@author: LeoEiji
"""

from PyQt5 import QtWidgets, QtCore, QtGui
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

class SideMenu(QWidget):
    def __init__(self):
        super().__init__()
        
        self.InitUI()
        
        
    def InitUI(self):
        # Side menu main frame    
        self.mainFrameLayout = QVBoxLayout()
        
        self.mainFrame = QFrame()
        self.mainFrameLayout.addWidget(self.mainFrame)
        self.mainFrame.setFrameShadow(QFrame.Raised)
       
        # Setting side menu's minimum width 
        self.mainFrame.setMinimumWidth(10)
        
        self.setLayout(self.mainFrameLayout)
        
    def doAnim(self):
        # Creating animation
        self.anim = QPropertyAnimation(self.mainFrame, b"minimumWidth")
        self.anim.setDuration(100)
        self.anim.setStartValue(10)
        self.anim.setEndValue(200)
        self.anim.start()
        
        
            