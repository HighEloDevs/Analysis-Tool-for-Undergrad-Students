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
from matplotlib_backend_qtquick.backend_qtquick import NavigationToolbar2QtQuick
from PyQt5.QtCore import QObject, pyqtProperty, QUrl, pyqtSignal, pyqtSlot
from PyQt5.QtGui import QGuiApplication, QPixmap
import numpy as np
import os

class MPLCanvas(QObject):
    """ A bridge class to interact with the plot in python
    """
    # Some signals for the frontend
    coordinatesChanged = pyqtSignal(str)

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
        self.oid     = 0
        self.cid     = 0

        # This is used to display the coordinates of the mouse in the window
        self._coordinates = ""

    def updateWithCanvas(self, canvas):
        """Initialize with the canvas for the figure."""
        self.canvas  = canvas
        self.figure  = self.canvas.figure
        self.toolbar = NavigationToolbar2QtQuick(canvas=canvas)
        self.axes    = self.figure.add_subplot(111)
        self.axes.grid(False)
        canvas.draw_idle()

        # Connect for displaying the coordinates
        self.figure.canvas.mpl_connect('motion_notify_event', self.on_motion)

    def Plot(self, model, canvasProps, fitProps, dataProps):
        log_x           = bool(canvasProps['log_x'])
        log_y           = bool(canvasProps['log_y'])
        legend          = bool(canvasProps['legend'])
        residuals       = bool(canvasProps['residuals'])
        grid            = bool(canvasProps['grid'])
        xmin            = canvasProps['xmin']
        xmax            = canvasProps['xmax']
        xdiv            = canvasProps['xdiv']
        ymin            = canvasProps['ymin']
        ymax            = canvasProps['ymax']
        ydiv            = canvasProps['ydiv']
        resmin          = canvasProps['resmin']
        resmax          = canvasProps['resmax']
        axisTitle       = [canvasProps['title'], canvasProps['xaxis'], canvasProps['yaxis']]
        symbol_color    = dataProps['marker_color']
        symbol_size     = dataProps['marker_size']
        symbol          = dataProps['marker']
        curve_color     = dataProps['curve_color']
        curve_thickness = dataProps['curve_thickness']
        curve_style     = dataProps['curve_style']
        sigma_x         = bool(fitProps['wsx'])
        sigma_y         = bool(fitProps['wsy'])
        px, py, y_r     = None, None, None

        if model._has_data:

            # Fitting expression to data, if there's any expression
            if model._exp_model != '':
                model.fit(wsx = not sigma_x, wsy = not sigma_y)
            else:
                model._isvalid = False

            # Plotting if the model is valid
            if model._isvalid:
                # Clearing the current plot
                self.clearAxis()

                # Getting data
                x, y, sy, sx = model.data
                y_r          = model.residuo

                if residuals:
                    self.ax1, self.ax2 = self.figure.subplots(2, 1, sharex=True, gridspec_kw={'height_ratios': [3, 1.0]})

                    if xdiv != 0. and (xmax != 0. or xmin != 0.):
                        self.ax1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                        self.ax2.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                        self.ax1.set_xlim(left = xmin, right = xmax)
                        self.ax2.set_xlim(left = xmin, right = xmax)
                    else:
                        if xmin == 0. and xmax != 0.:
                            self.ax1.set_xlim(left = None, right = xmax)
                            self.ax2.set_xlim(left = None, right = xmax)
                        elif xmin != 0. and xmax == 0.:
                            self.ax1.set_xlim(left = xmin, right = None)
                            self.ax2.set_xlim(left = xmin, right = None)
                        elif xmin != 0. and xmax != 0.:
                            self.ax1.set_xlim(left = xmin, right = xmax)
                            self.ax2.set_xlim(left = xmin, right = xmax)
                    
                    if ydiv != 0. and (ymax != 0. or ymin != 0.):
                        self.ax1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
                        self.ax1.set_ylim(bottom = ymin, top = ymax)
                    else:
                        if ymin == 0. and ymax != 0.:
                            self.ax1.set_ylim(bottom = None, top = ymax)
                        elif ymin != 0. and ymax == 0.:
                            self.ax1.set_ylim(bottom = ymin, top = None)
                        elif ymin != 0. and ymax != 0.:
                            self.ax1.set_ylim(bottom = ymin, top = ymax)
                    if resmin != 0. or resmax != 0.:
                        self.ax2.set_ylim(bottom = resmin, top = resmax)

                    if grid:
                        self.ax1.grid(True,  which='major')
                        # self.ax1.grid(True, which='minor', alpha = 0.3)
                        self.ax2.grid(True,  which='major')
                        # self.ax2.grid(True, which='minor', alpha = 0.3)
                    if log_y:
                        self.ax1.set_yscale('log')
                    if log_x:
                        self.ax1.set_xscale('log')

                    ssy = model.predictInc(not sigma_x)
                    self.ax2.errorbar(x, y_r, yerr=ssy, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    self.ax1.errorbar(x, y, yerr=sy, xerr=sx, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    
                    left, right = self.ax1.get_xlim()
                    self.ax1.set_xlim(left = left, right = right)
                    self.ax2.set_xlim(left = left, right = right)
                    px, py = 0., 0.
                    if log_x:
                        px, py      = model.get_predict_log(self.ax1.figure, left, right)

                    else:
                        px, py      = model.get_predict(self.ax1.figure, left, right)

                    # Making Plots
                    line_func, = self.ax1.plot(px, py, lw = curve_thickness, color = curve_color, ls = curve_style, label = '${}$'.format(model._exp_model))

                    # Setting titles
                    self.ax1.set_title(str(axisTitle[0]))
                    self.ax2.set(xlabel = str(axisTitle[1]))
                    self.ax1.set(ylabel = str(axisTitle[2]))
                    self.ax2.set(ylabel = "Resíduos")
                    if legend:
                        self.ax1.legend(frameon=False)

                    def update(evt=None):
                        left, right = self.ax1.get_xlim()
                        ppx, ppy = model.get_predict(self.ax1.figure, left, right)
                        line_func.set_data(ppx, ppy)
                        self.ax1.figure.canvas.draw_idle()
                    if log_x:
                        def update(evt=None):
                            left, right = self.ax1.get_xlim()
                            ppx, ppy = model.get_predict_log(self.ax1.figure, left, right)
                            line_func.set_data(ppx, ppy)
                            self.ax1.figure.canvas.draw_idle()
                    self.ax1.remove_callback(self.oid)
                    self.ax1.figure.canvas.mpl_disconnect(self.cid)
                    self.oid = self.ax1.callbacks.connect('xlim_changed', update)
                    self.cid = self.ax1.figure.canvas.mpl_connect("resize_event", update)
                else:
                    self.axes = self.figure.add_subplot(111)

                    if grid:
                        self.axes.grid(True,  which='major')
                        # self.axes.grid(True, which='minor', alpha = 0.3)
                    if log_y:
                        self.axes.set_yscale('log')
                    if log_x:
                        self.axes.set_xscale('log')

                    if xdiv != 0. and (xmax != 0. or xmin != 0.):
                        self.axes.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                        self.axes.set_xlim(left = xmin, right = xmax)

                    else:
                        if xmin == 0. and xmax != 0.:
                            self.axes.set_xlim(left = None, right = xmax)
                        elif xmin != 0. and xmax == 0.:
                            self.axes.set_xlim(left = xmin, right = None)
                        elif xmin != 0. and xmax != 0.:
                            self.axes.set_xlim(left = xmin, right = xmax)
                    
                    if ydiv != 0. and (ymax != 0. or ymin != 0.):
                        self.axes.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
                        self.axes.set_ylim(bottom = ymin, top = ymax)
                    else:
                        if ymin == 0. and ymax != 0.:
                            self.axes.set_ylim(bottom = None, top = ymax)
                        elif ymin != 0. and ymax == 0.:
                            self.axes.set_ylim(bottom = ymin, top = None)
                        elif ymin != 0. and ymax != 0.:
                            self.axes.set_ylim(bottom = ymin, top = ymax)
                    
                    # Making Plots

                    self.axes.errorbar(x, y, yerr=sy, xerr=sx, capsize = 0, elinewidth = 1, ecolor = symbol_color, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    
                    left, right = self.axes.get_xlim()
                    self.axes.set_xlim(left = left, right = right)
                    px, py = 0., 0.
                    if log_x:
                        px, py      = model.get_predict_log(self.axes.figure, left, right)
                    else:
                        px, py      = model.get_predict(self.axes.figure, left, right)
                    
                    line_func, = self.axes.plot(px, py, lw = curve_thickness, color = curve_color, ls = curve_style, label = '${}$'.format(model._exp_model))

                    if legend:
                        self.axes.legend(fancybox=True)

                    # Setting titles
                    self.axes.set_title(str(axisTitle[0]))
                    self.axes.set(xlabel = str(axisTitle[1]))
                    self.axes.set(ylabel = str(axisTitle[2]))

                    # One piece
                    def update(evt=None):
                        left, right = self.axes.get_xlim()
                        ppx, ppy = model.get_predict(self.axes.figure, left, right)
                        line_func.set_data(ppx,ppy)
                        self.axes.figure.canvas.draw_idle()
                    if log_x:
                        def update(evt=None):
                            left, right = self.axes.get_xlim()
                            ppx, ppy = model.get_predict_log(self.axes.figure, left, right)
                            line_func.set_data(ppx,ppy)
                            self.axes.figure.canvas.draw_idle()
                    self.axes.remove_callback(self.oid)
                    self.axes.figure.canvas.mpl_disconnect(self.cid)
                    self.oid = self.axes.callbacks.connect('xlim_changed', update)
                    self.cid = self.axes.figure.canvas.mpl_connect("resize_event", update)
            else:
                self.clearAxis()
                self.axes = self.figure.add_subplot(111)

                if grid:
                    self.axes.grid(True, which='major')
                    # self.axes.grid(True, which='minor', alpha = 0.3)
                if log_y:
                    self.axes.set_yscale('log')
                if log_x:
                    self.axes.set_xscale('log')

                if xdiv != 0. and (xmax != 0. or xmin != 0.):
                    self.axes.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                    self.axes.set_xlim(left = xmin, right = xmax)

                else:
                    if xmin == 0. and xmax != 0.:
                        self.axes.set_xlim(left = None, right = xmax)
                    elif xmin != 0. and xmax == 0.:
                        self.axes.set_xlim(left = xmin, right = None)
                    elif xmin != 0. and xmax != 0.:
                        self.axes.set_xlim(left = xmin, right = xmax)
                
                if ydiv != 0. and (ymax != 0. or ymin != 0.):
                    self.axes.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
                    self.axes.set_ylim(bottom = ymin, top = ymax)
                else:
                    if ymin == 0. and ymax != 0.:
                        self.axes.set_ylim(bottom = None, top = ymax)
                    elif ymin != 0. and ymax == 0.:
                        self.axes.set_ylim(bottom = ymin, top = None)
                    elif ymin != 0. and ymax != 0.:
                        self.axes.set_ylim(bottom = ymin, top = ymax)

                x, y, sy, sx = model.data

                # Making Plots

                self.axes.errorbar(x, y, yerr=sy, xerr=sx, elinewidth = 1, ecolor = symbol_color, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none', capsize = 0)
                
                # self.axes.minorticks_on()
                # self.axes.xaxis.set_minor_locator(mpl.ticker.AutoMinorLocator(3))
                # self.axes.yaxis.set_minor_locator(mpl.ticker.AutoMinorLocator(3))

                # Setting titles
                self.axes.set_title(str(axisTitle[0]))
                self.axes.set(xlabel = str(axisTitle[1]))
                self.axes.set(ylabel = str(axisTitle[2]))

        # Reseting parameters
        px, py, y_r   = None, None, None
        model.isvalid = False
        self.figure.tight_layout()
        self.figure.subplots_adjust(left = None, bottom = None, right = None, top = None, wspace = None, hspace = 0.)
        self.canvas.draw_idle()

    def clearAxis(self):
        """Clear the current plot in the axis."""
        try:
            self.figure.gca().remove()
        except:
            pass
        try:
            # ax1, ax2 = self.figure.gca()
            self.ax1.remove()
            self.ax2.remove()
        except:
            pass

    def reset(self):
        '''Resets the class.'''
        # The figure, canvas, toolbar and axes
        self.clearAxis()
        self.axes = self.figure.add_subplot(111)
        self.canvas.draw_idle()
        self.oid = 0
        self.cid = 0

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
        """Gets the cordinates in the plot."""
        return self._coordinates
    
    def setCoordinates(self, coordinates):
        """Sets the cordinates."""
        self._coordinates = coordinates
        self.coordinatesChanged.emit(self._coordinates)

    coordinates = pyqtProperty(str, getCoordinates, setCoordinates, notify=coordinatesChanged)

    # The toolbar commands
    @pyqtSlot(str, bool)
    def savePlot(self, save_path, transparent):
        """Gets the path from input and save the actual plot"""
        path = QUrl(save_path).toLocalFile()

        # Getting extension
        _, extension = os.path.splitext(path) # Recebe filename e extension

        if transparent and extension != 'png':
            self.messageHandler.raiseWarn('O fundo transparente funciona apenas na extensão .png')
            self.canvas.figure.savefig(path, dpi = 400, transparent=transparent)
        else:
            self.canvas.figure.savefig(path, dpi = 400, transparent=transparent)
            self.messageHandler.raiseSuccess('Imagem salva com sucesso!')

    @pyqtSlot()
    def copyToClipboard(self):
        '''Copy imagine to the clipboard'''
        # Getting clipboard
        clipboard = QGuiApplication.clipboard()

        # Saving image to a path   
        try:
            path = os.path.join(os.path.expanduser('~\Documents'), 'image.png')
            self.canvas.figure.savefig(path, dpi = 400, transparent=False)
            pixmap = QPixmap()
            # Loading image as pixmap and saving to clipboard
            if pixmap.load(path):
                clipboard.setImage(pixmap.toImage())
                self.messageHandler.raiseSuccess('Copiado com sucesso para a área de transferência!')
            os.remove(path)
        except:
            self.messageHandler.raiseError('Erro copiar para a área de transferência, contatar os desenvolvedores.')

    @pyqtSlot()
    def pan(self, *args):
        self.toolbar.pan(*args)

    @pyqtSlot()
    def zoom(self, *args):
        self.toolbar.zoom(*args)

    @pyqtSlot()
    def home(self, *args):
        self.toolbar.home(*args)

    @pyqtSlot()
    def back(self, *args):
        self.toolbar.back(*args)

    @pyqtSlot()
    def forward(self, *args):
        self.toolbar.forward(*args)

    def on_motion(self, event):
        """Update the coordinates on the display."""
        if event.inaxes == self.axes or event.inaxes == self.ax1 or event.inaxes == self.ax2:
            self.coordinates = f"({event.xdata:.2f}, {event.ydata:.2f})"

        