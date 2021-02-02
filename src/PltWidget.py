# -*- coding: utf-8 -*-
"""
Created on Sun Jan 31 20:31:29 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 
"""

import os
from PyQt5.QtWidgets import QFileDialog
import matplotlib.pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from PyQt5.QtWidgets import QApplication, QWidget
from matplotlib.backend_tools import ToolBase
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar

class Canvas(FigureCanvas):
    def __init__(self, parent=None, width=7, height=7, dpi=600):
        self.fig  = plt.Figure(figsize=(width, height), dpi=dpi)
        plt.grid(False)
        self.axes = self.fig.add_subplot(111)                
        super().__init__(self.fig)
        
class Canvas2(FigureCanvas):
    def __init__(self, parent=None, width=7, height=7, dpi=600):
        self.fig = plt.Figure(figsize=(width, height), dpi=dpi)
        plt.grid(False)
        self.ax1, self.ax2 = self.fig.subplots(2, 1, sharex=True,
                                                      gridspec_kw={'height_ratios': [3, 1.0]})
        self.fig.subplots_adjust(left = None, bottom = None, right = None, top = None, wspace = None, hspace = 0)           
        super().__init__(self.fig)
        
class MyToolbar(NavigationToolbar):
  def __init__(self, figure_canvas, parent= None):
    self.fig_canvas = figure_canvas
    self.toolitems = (
        ('Home', 'O PINTO DO MURILLO TEM 50CM', 'home', 'home'),
        ('Back', 'consectetuer adipiscing elit', 'back', 'back'),
        ('Forward', 'sed diam nonummy nibh euismod', 'forward', 'forward'),
        (None, None, None, None),
        ('Pan', 'tincidunt ut laoreet', 'move', 'pan'),
        ('Zoom', 'dolore magna aliquam', 'zoom_to_rect', 'zoom'),
        (None, None, None, None),
        ('Subplots', 'putamus parum claram', 'subplots', 'configure_subplots'),
        ('Customize', 'Edit axis, curve and image parameters', 'qt4_editor_options', 'edit_parameters'),
        # ('Save', 'sollemnes in futurum', 'filesave', 'save_figure'),
        ('Port', 'Select', "filesave", 'select_tool'),
        )

    NavigationToolbar.__init__(self, figure_canvas, parent= None)

  def select_tool(self):
    filename = QFileDialog.getSaveFileName(self, 'Save File', os.getcwd(), "*.png")[0]
    self.fig_canvas.fig.savefig(filename, dpi = 600)
        
            
                