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
from os import path
from matplotlib_backend_qtquick.backend_qtquick import NavigationToolbar2QtQuick
from matplotlib_backend_qtquick.qt_compat import QtCore, QtGui
import numpy as np
import os

class MPLCanvas(QtCore.QObject):
    """ A bridge class to interact with the plot in python
    """
    # Some signals for the frontend
    coordinatesChanged = QtCore.Signal(str)

    def __init__(self, messageHandler):
        super().__init__()
        
        self.messageHandler = messageHandler

        # The figure, canvas, toolbar and axes
        self.figure  = None
        self.canvas  = None
        self.toolbar = None
        self.axes    = None
        self.ax1     = ''
        self.ax2     = ''

        # Options
        self.axisTitle       = []
        self.sigma_x         = False
        self.sigma_y         = False
        self.log_x           = False
        self.log_y           = False
        self.legend          = False
        self.grid            = False
        self.residuals       = False
        self.symbol_color    = ''
        self.symbol_size     = 3
        self.symbol          = ''
        self.curve_color     = ''
        self.curve_thickness = 2
        self.curve_style     = ''
        self.expression      = ''
        self.xmin            = 0.
        self.xmax            = 0.
        self.xdiv            = 0.
        self.ymin            = 0.
        self.ymax            = 0.
        self.ydiv            = 0.
        self.resmin          = 0.
        self.resmax          = 0. 

        # This is used to display the coordinates of the mouse in the window
        self._coordinates = ""

    def updateWithCanvas(self, canvas):
        """ initialize with the canvas for the figure
        """
        self.canvas  = canvas
        self.figure  = self.canvas.figure
        self.toolbar = NavigationToolbar2QtQuick(canvas=canvas)
        self.axes    = self.figure.add_subplot(111)
        self.axes.grid(False)
        canvas.draw_idle()

        # Connect for displaying the coordinates
        self.figure.canvas.mpl_connect('motion_notify_event', self.on_motion)

    def Plot(self, model):
        px, py, y_r    = None, None, None

        if model._has_data:

            # Fitting expression to data, if there's any expression
            if model._exp_model != '':
                model.fit(wsx = not self.sigma_x, wsy = not self.sigma_y)

            else:
                model._isvalid = False

            # Plotting if the model is valid
            if model._isvalid:
                # Clearing the current plot
                self.clearAxis()

                # Getting data
                x, y, sy, sx = model.data
                px, py       = model.get_predict()
                y_r          = model.residuo

                if self.residuals:
                    self.ax1, self.ax2 = self.figure.subplots(2, 1, sharex=True, gridspec_kw={'height_ratios': [3, 1.0]})
                    self.figure.subplots_adjust(left = None, bottom = None, right = None, top = None, wspace = None, hspace = 0)

                    if self.xdiv != 0. and (self.xmax != 0. or self.xmin != 0.):
                        self.ax1.set_xticks(np.linspace(self.xmin, self.xmax, self.xdiv + 1))
                        self.ax2.set_xticks(np.linspace(self.xmin, self.xmax, self.xdiv + 1))
                        self.ax1.set_xlim(left = self.xmin, right = self.xmax)
                        self.ax2.set_xlim(left = self.xmin, right = self.xmax)
                    else:
                        if self.xmin == 0. and self.xmax != 0.:
                            self.ax1.set_xlim(left = None, right = self.xmax)
                            self.ax2.set_xlim(left = None, right = self.xmax)
                        elif self.xmin != 0. and self.xmax == 0.:
                            self.ax1.set_xlim(left = self.xmin, right = None)
                            self.ax2.set_xlim(left = self.xmin, right = None)
                        elif self.xmin != 0. and self.xmax != 0.:
                            self.ax1.set_xlim(left = self.xmin, right = self.xmax)
                            self.ax2.set_xlim(left = self.xmin, right = self.xmax)
                    
                    if self.ydiv != 0. and (self.ymax != 0. or self.ymin != 0.):
                        self.ax1.set_yticks(np.linspace(self.ymin, self.ymax, self.ydiv + 1))
                        self.ax2.set_yticks(np.linspace(self.ymin, self.ymax, self.ydiv + 1))
                        self.ax1.set_ylim(bottom = self.ymin, top = self.ymax)
                    else:
                        if self.ymin == 0. and self.ymax != 0.:
                            self.ax1.set_ylim(bottom = None, top = self.ymax)
                        elif self.ymin != 0. and self.ymax == 0.:
                            self.ax1.set_ylim(bottom = self.ymin, top = None)
                        elif self.ymin != 0. and self.ymax != 0.:
                            self.ax1.set_ylim(bottom = self.ymin, top = self.ymax)
                    
                    if self.resmin != 0. or self.resmax != 0.:
                        self.ax2.set_ylim(bottom = self.resmin, top = self.resmax)



                    if self.grid:
                        self.ax1.grid(True,  which='major')
                        # self.ax1.grid(True, which='minor', alpha = 0.3)
                        self.ax2.grid(True,  which='major')
                        # self.ax2.grid(True, which='minor', alpha = 0.3)
                    if self.log_y:
                        self.ax1.set_yscale('log')
                    if self.log_x:
                        self.ax1.set_xscale('log')

                    # Making Plots
                    self.ax1.plot(px, py, lw = self.curve_thickness, color = self.curve_color, ls = self.curve_style, label = '${}$'.format(self.expression))

                    if self.legend:
                        self.ax1.legend(frameon=False)

                    if model._mode == 2:
                        self.ax2.errorbar(x, y_r, yerr=sy, xerr = sx, ecolor = self.symbol_color, capsize = 0, elinewidth = 1, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                        self.ax1.errorbar(x, y, yerr=sy, xerr=sx, ecolor = self.symbol_color, capsize = 0, elinewidth = 1, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                    elif model._has_sx:
                        self.ax2.errorbar(x, y_r, xerr = sx, ecolor = self.symbol_color, capsize = 0, elinewidth = 1, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                        self.ax1.errorbar(x, y, xerr=sx, ecolor = self.symbol_color, capsize = 0, elinewidth = 1, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                    elif model._has_sy:
                        self.ax2.errorbar(x, y_r, yerr=sy, ecolor = self.symbol_color, capsize = 0, elinewidth = 1, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                        self.ax1.errorbar(x, y, yerr=sy, ecolor = self.symbol_color, capsize = 0, elinewidth = 1, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                    else:
                        self.ax2.errorbar(x, y_r, ecolor = self.symbol_color, capsize = 0, elinewidth = 1, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                        self.ax1.errorbar(x, y, ecolor = self.symbol_color, capsize = 0, elinewidth = 1, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')

                    self.ax1.minorticks_on()
                    self.ax2.minorticks_on()

                    # Setting titles
                    self.ax1.set_title(str(self.axisTitle[0]))
                    self.ax2.set(xlabel = str(self.axisTitle[1]))
                    self.ax1.set(ylabel = str(self.axisTitle[2]))
                    self.ax2.set(ylabel = "Resíduos")
                else:
                    self.axes = self.figure.add_subplot(111)

                    if self.grid:
                        self.axes.grid(True,  which='major')
                        # self.axes.grid(True, which='minor', alpha = 0.3)
                    if self.log_y:
                        self.axes.set_yscale('log')
                    if self.log_x:
                        self.axes.set_xscale('log')

                    if self.xdiv != 0. and (self.xmax != 0. or self.xmin != 0.):
                        self.axes.set_xticks(np.linspace(self.xmin, self.xmax, self.xdiv + 1))
                        self.axes.set_xlim(left = self.xmin, right = self.xmax)

                    else:
                        if self.xmin == 0. and self.xmax != 0.:
                            self.axes.set_xlim(left = None, right = self.xmax)
                        elif self.xmin != 0. and self.xmax == 0.:
                            self.axes.set_xlim(left = self.xmin, right = None)
                        elif self.xmin != 0. and self.xmax != 0.:
                            self.axes.set_xlim(left = self.xmin, right = self.xmax)
                    
                    if self.ydiv != 0. and (self.ymax != 0. or self.ymin != 0.):
                        self.axes.set_yticks(np.linspace(self.ymin, self.ymax, self.ydiv + 1))
                        self.axes.set_ylim(bottom = self.ymin, top = self.ymax)
                    else:
                        if self.ymin == 0. and self.ymax != 0.:
                            self.axes.set_ylim(bottom = None, top = self.ymax)
                        elif self.ymin != 0. and self.ymax == 0.:
                            self.axes.set_ylim(bottom = self.ymin, top = None)
                        elif self.ymin != 0. and self.ymax != 0.:
                            self.axes.set_ylim(bottom = self.ymin, top = self.ymax)
                    
                    # Making Plots
                    if model._mode == 2:
                        self.axes.plot(px, py, lw = self.curve_thickness, color = self.curve_color, ls = self.curve_style, label = '${}$'.format(self.expression))
                        self.axes.errorbar(x, y, yerr=sy, xerr=sx, capsize = 0, elinewidth = 1, ecolor = self.symbol_color, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                    elif model._has_sx:
                        self.axes.plot(px, py, lw = self.curve_thickness, color = self.curve_color, ls = self.curve_style, label = '${}$'.format(self.expression))
                        self.axes.errorbar(x, y, xerr=sx, capsize = 0, elinewidth = 1, ecolor = self.symbol_color, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                    elif model._has_sy:
                        self.axes.plot(px, py, lw = self.curve_thickness, color = self.curve_color, ls = self.curve_style, label = '${}$'.format(self.expression))
                        self.axes.errorbar(x, y, yerr=sy, capsize = 0, elinewidth = 1, ecolor = self.symbol_color, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                    else:
                        self.axes.plot(px, py, lw = self.curve_thickness, color = self.curve_color, ls = self.curve_style, label = '${}$'.format(self.expression))
                        self.axes.errorbar(x, y, capsize = 0, elinewidth = 1, ecolor = self.symbol_color, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')
                    
                    if self.legend:
                        self.axes.legend(frameon=False)
                    
                    self.axes.minorticks_on()

                    # Setting titles
                    self.axes.set_title(str(self.axisTitle[0]))
                    self.axes.set(xlabel = str(self.axisTitle[1]))
                    self.axes.set(ylabel = str(self.axisTitle[2]))
            else:
                self.clearAxis()
                self.axes = self.figure.add_subplot(111)

                if self.grid:
                    self.axes.grid(True, which='major')
                    # self.axes.grid(True, which='minor', alpha = 0.3)
                if self.log_y:
                    self.axes.set_yscale('log')
                if self.log_x:
                    self.axes.set_xscale('log')

                if self.xdiv != 0. and (self.xmax != 0. or self.xmin != 0.):
                    self.axes.set_xticks(np.linspace(self.xmin, self.xmax, self.xdiv + 1))
                    self.axes.set_xlim(left = self.xmin, right = self.xmax)

                else:
                    if self.xmin == 0. and self.xmax != 0.:
                        self.axes.set_xlim(left = None, right = self.xmax)
                    elif self.xmin != 0. and self.xmax == 0.:
                        self.axes.set_xlim(left = self.xmin, right = None)
                    elif self.xmin != 0. and self.xmax != 0.:
                        self.axes.set_xlim(left = self.xmin, right = self.xmax)
                
                if self.ydiv != 0. and (self.ymax != 0. or self.ymin != 0.):
                    self.axes.set_yticks(np.linspace(self.ymin, self.ymax, self.ydiv + 1))
                    self.axes.set_ylim(bottom = self.ymin, top = self.ymax)
                else:
                    if self.ymin == 0. and self.ymax != 0.:
                        self.axes.set_ylim(bottom = None, top = self.ymax)
                    elif self.ymin != 0. and self.ymax == 0.:
                        self.axes.set_ylim(bottom = self.ymin, top = None)
                    elif self.ymin != 0. and self.ymax != 0.:
                        self.axes.set_ylim(bottom = self.ymin, top = self.ymax)

                x, y, sy, sx = model.data

                # Making Plots
                if model._has_sx and model._has_sy:
                    self.axes.errorbar(x, y, yerr=sy, xerr=sx, elinewidth = 1, ecolor = self.symbol_color, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none', capsize = 0)
                elif model._has_sx:
                    self.axes.errorbar(x, y, xerr=sx, elinewidth = 1, ecolor = self.symbol_color, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none', capsize = 0)
                elif model._has_sy:
                    self.axes.errorbar(x, y, yerr=sy, elinewidth = 1, ecolor = self.symbol_color, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none', capsize = 0)
                else:
                    self.axes.errorbar(x, y, capsize = 0, elinewidth = 1, ecolor = self.symbol_color, ms = self.symbol_size, marker = self.symbol, color = self.symbol_color, ls = 'none')

                self.axes.minorticks_on()
                # self.axes.twinx()
                # self.axes.twiny()

                # Setting titles
                self.axes.set_title(str(self.axisTitle[0]))
                self.axes.set(xlabel = str(self.axisTitle[1]))
                self.axes.set(ylabel = str(self.axisTitle[2]))

        # Reseting parameters
        px, py, y_r   = None, None, None
        model.isvalid = False

        self.canvas.draw_idle()

    def clearAxis(self):
        """Clear the current plot in the axis"""
        try:
            self.axes.remove()
        except:
            pass
        try:
            self.ax1.remove()
            self.ax2.remove()
        except:
            pass

    def setCanvasProps(self, props, expr):
        self.log_x      = bool(props['log_x'])
        self.log_y      = bool(props['log_y'])
        self.legend     = bool(props['legend'])
        self.residuals  = bool(props['residuals'])
        self.grid       = bool(props['grid'])
        self.xmin       = props['xmin']
        self.xmax       = props['xmax']
        self.xdiv       = props['xdiv']
        self.ymin       = props['ymin']
        self.ymax       = props['ymax']
        self.ydiv       = props['ydiv']
        self.resmin     = props['resmin']
        self.resmax     = props['resmax']
        self.axisTitle  = [props['title'], props['xaxis'], props['yaxis']]
        self.expression = expr

    def setDataProps(self, dataProps, fitProps):
        self.symbol_color    = dataProps['marker_color']
        self.symbol_size     = dataProps['marker_size']
        self.symbol          = dataProps['marker']
        self.curve_color     = dataProps['curve_color']
        self.curve_thickness = dataProps['curve_thickness']
        self.curve_style     = dataProps['curve_style']
        self.sigma_x         = bool(fitProps['wsx'])
        self.sigma_y         = bool(fitProps['wsy'])

    def reset(self):
        '''Resets the class'''
        # The figure, canvas, toolbar and axes
        self.clearAxis()
        self.axes = self.figure.add_subplot(111)
        self.canvas.draw_idle()

        # Options
        self.sigma_x         = False
        self.sigma_y         = False
        self.log_x           = False
        self.log_y           = False
        self.legend          = False
        self.grid            = False
        self.residuals       = False
        self.symbol_color    = ''
        self.symbol_size     = 3
        self.symbol          = ''
        self.curve_color     = ''
        self.curve_thickness = 2
        self.curve_style     = ''
        self.expression      = ''

        # This is used to display the coordinates of the mouse in the window
        self._coordinates = ""
    
    def getCoordinates(self):
        """Gets the cordinates in the plot"""
        return self._coordinates
    
    def setCoordinates(self, coordinates):
        """Sets the cordinates"""
        self._coordinates = coordinates
        self.coordinatesChanged.emit(self._coordinates)

    coordinates = QtCore.Property(str, getCoordinates, setCoordinates, notify=coordinatesChanged)

    # The toolbar commands
    @QtCore.Slot(str, bool)
    def savePlot(self, save_path, transparent):
        """Gets the path from input and save the actual plot"""
        path = QtCore.QUrl(save_path).toLocalFile()

        # Getting extension
        extension = path.split('/')[-1].split('.')[1]

        if transparent and extension != 'png':
            self.messageHandler.raiseWarn('O fundo transparente funciona apenas na extensão .png')
            self.canvas.figure.savefig(path, dpi = 400, transparent=transparent)
        else:
            self.canvas.figure.savefig(path, dpi = 400, transparent=transparent)
            self.messageHandler.raiseSuccess('Imagem salva com sucesso!')

    @QtCore.Slot()
    def copyToClipboard(self):
        '''Copy imagine to the clipboard'''
        # Getting clipboard
        clipboard = QtGui.QGuiApplication.clipboard()

        # Saving image to a path   
        try:
            path = os.path.join(os.path.expanduser('~\Documents'), 'image.png')
            self.canvas.figure.savefig(path, dpi = 400, transparent=False)
            pixmap = QtGui.QPixmap()
            # Loading image as pixmap and saving to clipboard
            if pixmap.load(path):
                clipboard.setImage(pixmap.toImage())
                self.messageHandler.raiseSuccess('Copiado com sucesso para a área de transferência!')
            os.remove(path)
        except:
            self.messageHandler.raiseError('Erro copiar para a área de transferência, contatar os desenvolvedores.')

    @QtCore.Slot()
    def pan(self, *args):
        self.toolbar.pan(*args)

    @QtCore.Slot()
    def zoom(self, *args):
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
        """Update the coordinates on the display
        """
        if event.inaxes == self.axes or event.inaxes == self.ax1 or event.inaxes == self.ax2:
            self.coordinates = f"({event.xdata:.2f}, {event.ydata:.2f})"

        