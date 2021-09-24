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
from PyQt5.QtCore import QObject, QVariant, pyqtProperty, QUrl, pyqtSignal, pyqtSlot
from PyQt5.QtGui import QGuiApplication, QPixmap
import matplotlib.pyplot as plt
import numpy as np
import os
import matplotlib.gridspec as gridspec

class MPLCanvas(QObject):
    """A bridge class to interact with the plot in python."""
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
        self.axes1   = None
        self.axes2   = None
        self.oid     = 0
        self.cid     = 0
        self.grid    = False
        self.top     = 0.92
        self.bottom  = 0.12
        self.left    = 0.10
        self.right   = 0.95
        self.figmode = 0

        # This is used to display the coordinates of the mouse in the window
        self._coordinates = ""

    def updateWithCanvas(self, canvas):
        """Initialize with the canvas for the figure."""
        self.canvas  = canvas
        self.figure  = self.canvas.figure
        self.toolbar = NavigationToolbar2QtQuick(canvas=canvas)
        self.gm      = gridspec.GridSpec(2, 1, figure =  self.figure, height_ratios = [3., 1.])
        self.gs      = gridspec.GridSpec(1, 1, figure =  self.figure, height_ratios = [1.])
        self.axes1   = self.figure.add_subplot(self.gm[0], picker = True, autoscale_on = True)
        self.axes2   = self.figure.add_subplot(self.gm[1], picker = True, sharex = self.axes1, autoscale_on = False)
        self.set_tight_layout()
        self.axes2.set_visible(False)
        self.axes1.set_position(self.gs[:, :].get_position(self.figure), which = "original")
        self.axes1.grid(False)
        self.canvas.draw_idle()

        # Connect for displaying the coordinates
        self.figure.canvas.mpl_connect('motion_notify_event', self.on_motion)

    def Plot(self, model, canvasProps, fitProps, dataProps):
        self.set_tight_layout()
        log_x           = not not canvasProps['log_x']  # O mesmo que bool porém mais rápido
        log_y           = not not canvasProps['log_y']
        legend          = not not canvasProps['legend']
        residuals       = not not canvasProps['residuals']
        grid            = not not canvasProps['grid']
        self.grid       = grid
        xmin            = canvasProps['xmin']
        xmax            = canvasProps['xmax']
        xdiv            = canvasProps['xdiv']
        ymin            = canvasProps['ymin']
        ymax            = canvasProps['ymax']
        ydiv            = canvasProps['ydiv']
        resmin          = canvasProps['resmin']
        resmax          = canvasProps['resmax']
        partialTitles   = canvasProps['title'].split(";")
        axisTitle       = []
        if len(partialTitles) == 1:
            axisTitle       = [canvasProps['title'].strip(), canvasProps['xaxis'].strip(), canvasProps['yaxis'].strip(), ""]
        else:
            axisTitle       = [partialTitles[0].strip(), canvasProps['xaxis'].strip(), canvasProps['yaxis'].strip(),
             partialTitles[1].strip()]
        symbol_color    = dataProps['marker_color']
        symbol_size     = dataProps['marker_size']
        symbol          = dataProps['marker']
        curve_color     = dataProps['curve_color']
        curve_thickness = dataProps['curve_thickness']
        curve_style     = dataProps['curve_style']
        sigma_x         = not not fitProps['wsx']
        sigma_y         = not not fitProps['wsy']
        px, py, y_r     = None, None, None

        if model._has_data:

            # Fitting expression to data, if there's any expression
            if fitProps["adjust"]:
                if model._exp_model != '':
                    model.fit(wsx = not sigma_x, wsy = not sigma_y)
                else:
                    model._isvalid = False
            else:
                if model._exp_model != '':
                    model.createDummyModel()
                else:
                    model._isvalid = False

            # Plotting if the model is valid
            if model._isvalid:
                # Clearing the current plot
                self.clearAxis()

                # Getting data
                x, y, sy, sx = model.data
                y_r          = None
                if fitProps["adjust"]:
                    y_r      = model.residuo
                else:
                    y_r      = model.residuoDummy
                if residuals:
                    self.switchAxes(hideAxes2 = False)
                    if sigma_x and sigma_y:                     # Caso considerar as duas incertezas
                        ssy = model.predictInc(not sigma_x)
                        self.axes1.errorbar(x, y, yerr=sy, xerr=sx, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                        self.axes2.errorbar(x, y_r, yerr=ssy, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    elif sigma_x == False and sigma_y == False: # Caso desconsiderar as duas
                        self.axes1.errorbar(x, y, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                        self.axes2.errorbar(x, y_r, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    elif sigma_x == False and sigma_y == True:  # Caso considerar só sy
                        ssy = model.predictInc(not sigma_x)
                        self.axes1.errorbar(x, y, yerr=sy, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                        self.axes2.errorbar(x, y_r, yerr=ssy, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    else:                                       # Caso considerar só sx
                        ssy = model.predictInc(not sigma_x)
                        self.axes1.errorbar(x, y, xerr=sx, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                        self.axes2.errorbar(x, y_r, yerr=ssy, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    self.setAxesPropsWithAxes2(xmin, xmax, xdiv, ymin, ymax, ydiv, resmin, resmax, grid, log_x, log_y)
                    left, right = self.axes1.get_xlim()
                    # self.axes1.set_xlim(left = left, right = right)
                    # self.axes2.set_xlim(left = left, right = right)
                    px, py = 0., 0.
                    if log_x:
                        px, py      = model.get_predict_log(self.axes1.figure, left, right)
                    else:
                        px, py      = model.get_predict(self.axes1.figure, left, right)

                    # Making Plots
                    line_func, = self.axes1.plot(px, py, lw = curve_thickness, color = curve_color, ls = curve_style, label = '${}$'.format(model._exp_model))

                    # Setting titles
                    self.axes1.set_title(axisTitle[0])
                    self.axes2.set(xlabel = axisTitle[1])
                    self.axes1.set(ylabel = axisTitle[2])
                    self.axes2.set(ylabel = axisTitle[3])
                    if legend:
                        self.axes1.legend(frameon=False)

                    def update(evt=None):
                        left, right = self.axes1.get_xlim()
                        ppx, ppy = model.get_predict(self.axes1.figure, left, right)
                        line_func.set_data(ppx, ppy)
                        self.axes1.figure.canvas.draw_idle()
                    if log_x:
                        def update(evt=None):
                            left, right = self.axes1.get_xlim()
                            ppx, ppy = model.get_predict_log(self.axes1.figure, left, right)
                            line_func.set_data(ppx, ppy)
                            self.axes1.figure.canvas.draw_idle()
                    self.axes1.remove_callback(self.oid)
                    self.axes1.figure.canvas.mpl_disconnect(self.cid)
                    self.oid = self.axes1.callbacks.connect('xlim_changed', update)
                    self.cid = self.axes1.figure.canvas.mpl_connect("resize_event", update)
                else:
                    self.clearAxis()
                    self.switchAxes(hideAxes2 = True)

                    # Making Plots
                    if sigma_x and sigma_y:                     # Caso considerar as duas incertezas
                        self.axes1.errorbar(x, y, yerr=sy, xerr=sx, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    elif sigma_x == False and sigma_y == False: # Caso desconsiderar as duas
                        self.axes1.errorbar(x, y, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')                        
                    elif sigma_x == False and sigma_y == True:  # Caso considerar só sy
                        self.axes1.errorbar(x, y, yerr=sy, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                    else:                                       # Caso considerar só sx
                        self.axes1.errorbar(x, y, xerr=sx, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')

                    self.setAxesPropsWithoutAxes2(xmin, xmax, xdiv, ymin, ymax, ydiv, grid, log_x, log_y)
                    left, right = self.axes1.get_xlim()
                    # self.axes1.set_xlim(left = left, right = right)
                    px, py = 0., 0.
                    if log_x:
                        px, py      = model.get_predict_log(self.axes1.figure, left, right)
                    else:
                        px, py      = model.get_predict(self.axes1.figure, left, right)
                    
                    line_func, = self.axes1.plot(px, py, lw = curve_thickness, color = curve_color, ls = curve_style, label = '${}$'.format(model._exp_model), picker = True)
                    if legend:
                        self.axes1.legend(fancybox=True)

                        # def on_pick(event):
                        #     print("ok")
                        #     visible = not self.teste.get_visible()
                        #     self.teste.set_visible(visible)
                        #     self.teste.set_alpha(1.0 if visible else 0.2)
                        # self.figure.canvas.draw()
                        # self.figure.canvas.mpl_connect('pick_event', on_pick)
                    # Setting titles
                    self.axes1.set_title(str(axisTitle[0]))
                    self.axes1.set(xlabel = str(axisTitle[1]))
                    self.axes1.set(ylabel = str(axisTitle[2]))

                    # One piece
                    def update(evt=None):
                        left, right = self.axes1.get_xlim()
                        ppx, ppy = model.get_predict(self.axes1.figure, left, right)
                        line_func.set_data(ppx,ppy)
                        self.axes1.figure.canvas.draw_idle()
                    if log_x:
                        def update(evt=None):
                            left, right = self.axes1.get_xlim()
                            ppx, ppy = model.get_predict_log(self.axes1.figure, left, right)
                            line_func.set_data(ppx,ppy)
                            self.axes1.figure.canvas.draw_idle()
                    self.axes1.remove_callback(self.oid)
                    self.axes1.figure.canvas.mpl_disconnect(self.cid)
                    self.oid = self.axes1.callbacks.connect('xlim_changed', update)
                    self.cid = self.figure.canvas.mpl_connect("resize_event", update)

            else:
                self.clearAxis()
                self.switchAxes(hideAxes2 = True)

                x, y, sy, sx = model.data

                # Making Plots
                if sigma_x and sigma_y:                     # Caso considerar as duas incertezas
                    self.axes1.errorbar(x, y, yerr=sy, xerr=sx, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                elif sigma_x == False and sigma_y == False: # Caso desconsiderar as duas
                    self.axes1.errorbar(x, y, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')                        
                elif sigma_x == False and sigma_y == True:  # Caso considerar só sy
                    self.axes1.errorbar(x, y, yerr=sy, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')
                else:                                       # Caso considerar só sx
                    self.axes1.errorbar(x, y, xerr=sx, ecolor = symbol_color, capsize = 0, elinewidth = 1, ms = symbol_size, marker = symbol, color = symbol_color, ls = 'none')

                # Setting titles
                self.axes1.set_title(str(axisTitle[0]))
                self.axes1.set(xlabel = str(axisTitle[1]))
                self.axes1.set(ylabel = str(axisTitle[2]))
                self.setAxesPropsWithoutAxes2(xmin, xmax, xdiv, ymin, ymax, ydiv, grid, log_x, log_y)

        # Reseting parameters
        # px, py, y_r   = None, None, None
        model.isvalid = False
        self.canvas.draw_idle()

    def clearAxis(self):
        """Clear the current plot in the axis."""
        self.axes1.cla()
        self.axes2.cla()
        self.axes1.relim()
        self.axes2.relim()
        self.canvas.draw_idle()
    
    def switchAxes(self, hideAxes2: bool = True):
        """Função que oculta ou não o eixo secundário."""
        if hideAxes2:
            self.axes2.set_visible(False)
            self.axes1.set_position(self.gs[0].get_position(self.figure), which = 'both')
            self.figmode = 0
        else:
            self.axes2.set_visible(True)
            self.axes1.set_position(self.gm[0].get_position(self.figure), which = 'both')
            self.axes2.set_position(self.gm[1].get_position(self.figure), which = 'both')
            self.figmode = 1

    def setAxesPropsWithoutAxes2(self, xmin, xmax, xdiv, ymin, ymax, ydiv, grid, log_x, log_y):
        left, right = self.axes1.get_xlim()
        bottom, top = self.axes1.get_ylim()
        divs_x      = len(self.axes1.get_xticks()) - 1
        divs_y      = len(self.axes1.get_yticks()) - 1
        xmin = self.makeFloat(xmin, left)
        xmax = self.makeFloat(xmax, right)
        xdiv = self.makeInt(xdiv, divs_x)
        ymin = self.makeFloat(ymin, bottom)
        ymax = self.makeFloat(ymax, top)
        ydiv = self.makeInt(ydiv, divs_y)

        if grid:
            self.axes1.grid(True,  which='major')
        if log_y:
            self.axes1.set_yscale('log')
        if log_x:
            self.axes1.set_xscale('log')

        if xdiv != divs_x:
            self.axes1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
            self.axes1.set_xlim(left = xmin, right = xmax)
        else:
            if left != xmin or right != xmax:
                self.axes1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                self.axes1.set_xlim(left = xmin, right = xmax)

        if ydiv != divs_y:
            self.axes1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
            self.axes1.set_ylim(bottom = ymin, top = ymax)
        else:
            if bottom != ymin or top != ymax:
                self.axes1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
                self.axes1.set_ylim(bottom = ymin, top = ymax)

    def setAxesPropsWithAxes2(self, xmin, xmax, xdiv, ymin, ymax, ydiv, resmin, resmax, grid, log_x, log_y):
        left, right    = self.axes1.get_xlim()
        bottom, top    = self.axes1.get_ylim()
        botres, topres = self.axes2.get_ylim()
        divs_x         = len(self.axes1.get_xticks()) - 1
        divs_y         = len(self.axes1.get_yticks()) - 1

        xmin   = self.makeFloat(xmin, left)
        xmax   = self.makeFloat(xmax, right)
        xdiv   = self.makeInt(xdiv, divs_x)
        ymin   = self.makeFloat(ymin, bottom)
        ymax   = self.makeFloat(ymax, top)
        ydiv   = self.makeInt(ydiv, divs_y)
        self.axes2.set_ylim(bottom = self.makeFloat(resmin, botres), top = self.makeFloat(resmax, topres))
        if xdiv != divs_x:
            self.axes1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
            self.axes2.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
            self.axes1.set_xlim(left = xmin, right = xmax)
            self.axes2.set_xlim(left = xmin, right = xmax)
        else:
            if left != xmin or right != xmax:
                self.axes1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                self.axes2.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                self.axes1.set_xlim(left = xmin, right = xmax)
                self.axes2.set_xlim(left = xmin, right = xmax)
            else:
                self.axes1.set_xlim(left = xmin, right = xmax)
                self.axes2.set_xlim(left = xmin, right = xmax)
        # self.axes1.set_xticks([])

        if ydiv != divs_y:
            self.axes1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
            self.axes1.set_ylim(bottom = ymin, top = ymax)
        else:
            if bottom != ymin or top != ymax:
                self.axes1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
                self.axes1.set_ylim(bottom = ymin, top = ymax)

        if grid:
            self.axes1.grid(True,  which='major')
            # self.axes1.grid(True, which='minor', alpha = 0.3)
            self.axes2.grid(True,  which='major')
            # self.axes2.grid(True, which='minor', alpha = 0.3)
        if log_y:
            self.axes1.set_yscale('log')
        if log_x:
            self.axes1.set_xscale('log')
        plt.setp(self.axes1.get_xticklabels(), visible=False)
    
    def set_tight_layout(self):
        self.figure.subplots_adjust(left = self.left, bottom = self.bottom, right = self.right, top = self.top)

    def makeFloat(self, var, valor):
        try:
            return float(var)
        except:
            return valor

    def makeInt(self, var, valor):
        try:
            return int(var)
        except:
            return valor

    def getCoordinates(self):
        """Retorna as coordenadas no gráfico."""
        return self._coordinates
    
    def setCoordinates(self, coordinates):
        """Seta as coordenadas do gráfico."""
        self._coordinates = coordinates
        self.coordinatesChanged.emit(self._coordinates)

    coordinates = pyqtProperty(str, getCoordinates, setCoordinates, notify=coordinatesChanged)

    @pyqtSlot(str, str, str, str)
    def setPaddings(self, top, bottom, left, right):
        self.top    = self.makeFloat(top, valor = 0.92)
        self.bottom = self.makeFloat(bottom, valor = 0.12)
        self.left   = self.makeFloat(left, valor = 0.10)
        self.right  = self.makeFloat(right, valor = 0.95)
        if self.figmode:
            self.figure.subplots_adjust(left = self.left, bottom = self.bottom, right = self.right, top = self.top)
        else:
            self.figure.subplots_adjust(left = self.left, bottom = self.bottom, right = self.right, top = self.top)
            self.switchAxes()
        self.canvas.draw_idle()
        # self.messageHandler.raiseSuccess("Valores alterados com sucesso.")

    @pyqtSlot(result = str)
    def getPaddings(self):
        return "0.92;0.12;0.10;0.95"

    # The toolbar commands
    @pyqtSlot(str, bool)
    def savePlot(self, save_path, transparent):
        """Gets the path from input and save the actual plot."""
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
        '''Copy imagine to the clipboard.'''
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

    @pyqtSlot()
    def SHORTGrid(self):
        self.axes1.grid(not self.grid)
        self.axes2.grid(not self.grid)
        self.grid = not self.grid
        self.canvas.draw_idle()

    @pyqtSlot()
    def SHORTAxis1(self):
        if self.axes1.axison:
            self.axes1.axis('off')
        else:
            self.axes1.axis('on')
        self.canvas.draw_idle()

    @pyqtSlot()
    def SHORTAxis2(self):
        if self.axes2.axison:
            self.axes2.axis('off')
        else:
            self.axes2.axis('on')
        self.canvas.draw_idle()

    @pyqtSlot(int, int)
    def set_canvas_size(self, width, height):
        if width == 0 or height == 0:
            self.resize_canvas()
            return
        dpi = self.canvas.figure.get_dpi()
        self.canvas.figure.set_size_inches(width/dpi, height/dpi)
        self.canvas.draw_idle()

    @pyqtSlot(result=list)
    def get_canvas_size(self):
        # Getting the dpi of the figure
        dpi = self.canvas.figure.get_dpi()
        # Getting the size of the figure
        width, height = self.canvas.figure.get_size_inches()

        return [int(width*dpi), int(height*dpi), dpi]

    @pyqtSlot()
    def resize_canvas(self):
        '''Resizes the figure to fit the canvas'''
        self.canvas.geometryChanged(self.canvas.boundingRect(), self.canvas.boundingRect())

    def on_motion(self, event):
        """Update the coordinates on the display."""
        if event.inaxes == self.axes1 or event.inaxes == self.axes2:
            self.coordinates = f"({event.xdata:.2f}, {event.ydata:.2f})"
