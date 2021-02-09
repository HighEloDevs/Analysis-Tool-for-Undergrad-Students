# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

MatPlotLib Class

"""

from matplotlib_backend_qtquick.backend_qtquick import NavigationToolbar2QtQuick
from matplotlib_backend_qtquick.qt_compat import QtGui, QtQml, QtCore
import numpy as np

class DisplayBridge(QtCore.QObject):
    """ A bridge class to interact with the plot in python
    """
    coordinatesChanged = QtCore.Signal(str)

    def __init__(self, parent=None):
        super().__init__(parent)

        # The figure, canvas, toolbar and axes
        self.figure = None
        self.canvas = None
        self.toolbar = None
        self.axes = None
        self.ax1 = None
        self.ax2 = None

        # This is used to display the coordinates of the mouse in the window
        self._coordinates = ""

    def updateWithCanvas(self, canvas):
        """ initialize with the canvas for the figure
        """
        self.figure = canvas.figure
        self.toolbar = NavigationToolbar2QtQuick(canvas=canvas)
        self.axes = self.figure.add_subplot(111)
        self.canvas = canvas
        self.axes.grid(False)

        canvas.draw_idle()

        # Connect for displaying the coordinates
        self.figure.canvas.mpl_connect('motion_notify_event', self.on_motion)

    def Plot(self, model, residuals, grid):
        # Clearing the current plot
        try:
            self.axes.remove()
        except:
            pass
        try:
            self.ax1.remove()
            self.ax2.remove()
        except:
            pass

        if model.has_data:
            if model.isvalid:

                # Getting data
                x, y, sy, sx = model.get_data()

                # Fitting expression to data
                model.fit()

                # Getting fitted data
                px, py = model.get_predict()
                y_r = model.get_residuals()


                # Plotting
                if residuals:
                    self.ax1, self.ax2 = self.figure.subplots(2, 1, sharex=True, gridspec_kw={'height_ratios': [3, 1.0]})
                    self.figure.subplots_adjust(left = None, bottom = None, right = None, top = None, wspace = None, hspace = 0) 

                    if grid:
                        self.ax1.grid(True)
                        self.ax2.grid(True)

                    # Making Plots
                    self.ax1.plot(px, py, lw = 1, c = 'red')
                    self.ax2.errorbar(x, y_r, yerr=sy, xerr = sx, fmt = 'b.', ecolor = 'black', capsize = 0, ms = 3, elinewidth = 0.5)
                    self.ax1.errorbar(x, y, yerr=sy, xerr=sx, fmt = 'bo', ecolor = 'black', capsize = 0, ms = 3, elinewidth = 0.5)

                    # Setting titles
                    self.ax1.set_title(str(model.eixos[2][0]))
                    self.ax1.set(ylabel = str(model.eixos[1][0]))
                    self.ax2.set(xlabel = str(model.eixos[0][0]))

                else:
                    self.axes = self.figure.add_subplot(111)

                    if grid:
                        self.axes.grid(True)
                    
                    x, y, sy, sx = model.get_data()
                    
                    # Making Plots
                    #self.axes.plot(px, py, lw = 1, c = 'red')
                    self.axes.errorbar(x, y, yerr=sy, xerr=sx, fmt = 'bo', ecolor = 'black', capsize = 0, ms = 3, elinewidth = 0.5)

                    # Setting titles
                    self.axes.set_title(str(model.eixos[2][0]))
                    self.axes.set(ylabel = str(model.eixos[1][0]))
                    self.axes.set(xlabel = str(model.eixos[0][0]))
            else:
                self.axes = self.figure.add_subplot(111)

                if grid:
                    self.axes.grid(True)

                # Making Plots
                self.axes.plot(px, py, lw = 1, c = 'red')
                self.axes.errorbar(x, y, yerr=sy, xerr=sx, fmt = 'bo', ecolor = 'black', capsize = 0, ms = 3, elinewidth = 0.5)

                # Setting titles
                self.axes.set_title(str(model.eixos[2][0]))
                self.axes.set(ylabel = str(model.eixos[1][0]))
                self.axes.set(xlabel = str(model.eixos[0][0]))

        self.canvas.draw_idle()
 
    def PlotScatter(self, model, residuals, grid):
        pass


    # define the coordinates property
    # (I have had problems using the @QtCore.Property directy in the past)
    def getCoordinates(self):
        return self._coordinates
    
    def setCoordinates(self, coordinates):
        self._coordinates = coordinates
        self.coordinatesChanged.emit(self._coordinates)
    
    coordinates = QtCore.Property(str, getCoordinates, setCoordinates,
                                  notify=coordinatesChanged)

    # The toolbar commands
    @QtCore.Slot()
    def pan(self, *args):
        """Activate the pan tool."""
        self.toolbar.pan(*args)

    @QtCore.Slot()
    def zoom(self, *args):
        """activate zoom tool."""
        self.toolbar.zoom(*args)

    @QtCore.Slot()
    def home(self, *args):
        self.toolbar.home(*args)

    @QtCore.Slot()
    def back(self, *args):
        self.toolbar.back(*args)

    @QtCore.Slot()
    def forward(self, *args):
        self.toolbar.forward(*args)

    def on_motion(self, event):
        """
        Update the coordinates on the display
        """
        if event.inaxes == self.axes:
            self.coordinates = f"({event.xdata:.2f}, {event.ydata:.2f})"
        