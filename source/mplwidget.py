# -*- coding: utf-8 -*-
"""
Created on Tue Feb  2 19:49:23 2021

@author: LeoEiji
"""

import os
from PyQt5.QtWidgets import QFileDialog
from PyQt5.QtWidgets import QApplication, QWidget

import matplotlib.pyplot as plt

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backend_tools import ToolBase
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar


class Canvas(FigureCanvas):
    def __init__(self, mode, width, height, dpi):
        self.fig, self.ax1, self.ax2 = None, None, None
        plt.grid(False)

        if mode==0:
            self.fig = plt.Figure( figsize = (width, height), dpi = dpi)
            self.ax1 = self.fig.add_subplot(111)
            super().__init__(self.fig)
        else:
            self.fig = plt.Figure(figsize=(width, height), dpi=dpi)
            self.ax1, self.ax2 = self.fig.subplots(2, 1, sharex=True, gridspec_kw={'height_ratios': [3, 1]})
            self.fig.subplots_adjust(left=None, bottom=None, right=None, top=None, wspace=None, hspace=0)
            super().__init__(self.fig)

class MyToolbar(NavigationToolbar):
  def __init__(self, figure_canvas):
    self.fig_canvas = figure_canvas
    self.toolitems = (
        ('Home', 'Reseta o zoom', 'home', 'home'),
        ('Back', 'Voltar uma ação', 'back', 'back'),
        ('Forward', 'Ir uma ação', 'forward', 'forward'),
        (None, None, None, None),
        ('Pan', 'Mover o gráfico', 'move', 'pan'),
        ('Zoom', 'Zoom', 'zoom_to_rect', 'zoom'),
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