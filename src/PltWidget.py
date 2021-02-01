# -*- coding: utf-8 -*-
"""
Created on Sun Jan 31 20:31:29 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 
"""

import matplotlib.pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from PyQt5.QtWidgets import QApplication, QWidget
from matplotlib.backend_tools import ToolBase
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar

class Canvas(FigureCanvas):
    def __init__(self, parent=None, width=7, height=7, dpi=1000):
        fig = plt.Figure(figsize=(width, height), dpi=dpi)
        self.axes = fig.add_subplot(111)                
        super().__init__(fig)
        
class MyToolbar(NavigationToolbar):
  def __init__(self, figure_canvas, parent= None):
      
    self.toolitems = (
        ('Home', 'O PINTO DO MURILLO TEM 50CM', 'home', 'home'),
        ('Back', 'consectetuer adipiscing elit', 'back', 'back'),
        ('Forward', 'sed diam nonummy nibh euismod', 'forward', 'forward'),
        (None, None, None, None),
        ('Pan', 'tincidunt ut laoreet', 'move', 'pan'),
        ('Zoom', 'dolore magna aliquam', 'zoom_to_rect', 'zoom'),
        (None, None, None, None),
        ('Subplots', 'putamus parum claram', 'subplots', 'configure_subplots'),
        # ('Save', 'sollemnes in futurum', 'filesave', 'save_figure'),
        ('Port', 'Select', "filesave", 'select_tool'),
        )

    NavigationToolbar.__init__(self, figure_canvas, parent= None)

  def select_tool(self):
    print("You clicked the selection tool")
        
            
                