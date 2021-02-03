# -*- coding: utf-8 -*-
"""
Created on Tue Feb  2 17:36:20 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 
"""

from main import *
from source.PltWidget import *
from source.Model import *

class UIFunctions(MainWindow):

    def toggleMenu(self, maxWidth, enable):
        if enable:
            # GET WIDTH
            width = self.ui.Frame_right.width()
            maxExtend = maxWidth
            standard = 60

            # SET MAX WIDTH
            if width == 60:
                widthExtended = maxExtend
            else:
                widthExtended = standard

            # ANIMATION
            self.animation = QPropertyAnimation(self.ui.Frame_right, b"minimumWidth")
            self.animation.setDuration(400)
            self.animation.setStartValue(width)
            self.animation.setEndValue(widthExtended)
            self.animation.setEasingCurve(QtCore.QEasingCurve.OutBounce)
            self.animation.start()
            
            
    