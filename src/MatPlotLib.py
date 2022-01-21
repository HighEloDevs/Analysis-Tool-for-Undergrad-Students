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
import os

import matplotlib.pyplot as plt
import numpy as np
from matplotlib import gridspec
from matplotlib_backend_qtquick.backend_qtquick import NavigationToolbar2QtQuick
from PyQt5.QtCore import QObject, QUrl, pyqtProperty, pyqtSignal, pyqtSlot
from PyQt5.QtGui import QGuiApplication, QPixmap


class MPLCanvas(QObject):
    """A bridge class to interact with the plot in python."""

    # Some signals for the frontend
    coordinates_changed = pyqtSignal(str)

    def __init__(self, message_handler):
        super().__init__()

        self.message_handler = message_handler

        # The figure, canvas, toolbar and axes
        self.figure = None
        self.canvas = None
        self.toolbar = None
        self.axes = None
        self.axes1 = None
        self.axes2 = None
        self.oid = 0
        self.cid = 0
        self.grid = False
        self.top = 0.92
        self.bottom = 0.12
        self.left = 0.10
        self.right = 0.95
        self.figmode = 0

        # This is used to display the coordinates of the mouse in the window
        self._coordinates = ""

    def updateWithCanvas(self, canvas):
        """Initialize with the canvas for the figure."""
        self.canvas = canvas
        self.figure = self.canvas.figure
        self.toolbar = NavigationToolbar2QtQuick(canvas=canvas)
        self.gm = gridspec.GridSpec(2,
                                    1,
                                    figure=self.figure,
                                    height_ratios=[3.0, 1.0])
        self.gs = gridspec.GridSpec(1,
                                    1,
                                    figure=self.figure,
                                    height_ratios=[1.0])
        self.axes1 = self.figure.add_subplot(self.gm[0],
                                             picker=True,
                                             autoscale_on=True)
        self.axes2 = self.figure.add_subplot(self.gm[1],
                                             picker=True,
                                             sharex=self.axes1,
                                             autoscale_on=False)
        self.set_tight_layout()
        self.axes2.set_visible(False)
        self.axes1.set_position(self.gs[:, :].get_position(self.figure),
                                which="original")
        self.axes1.grid(False)
        self.canvas.draw_idle()

        # Connect for displaying the coordinates
        self.figure.canvas.mpl_connect("motion_notify_event", self.on_motion)

    def Plot(self, model, canvas_props, fit_props, data_props):
        self.set_tight_layout()
        sigma_x         = not not fit_props["wsx"]
        sigma_y         = not not fit_props["wsy"]
        grid            = not not canvas_props["grid"]
        log_x           = not not canvas_props["log_x"]
        log_y           = not not canvas_props["log_y"]
        legend          = not not canvas_props["legend"]
        residuals       = not not canvas_props["residuals"]
        xmin            = canvas_props["xmin"]
        xmax            = canvas_props["xmax"]
        xdiv            = canvas_props["xdiv"]
        ymin            = canvas_props["ymin"]
        ymax            = canvas_props["ymax"]
        ydiv            = canvas_props["ydiv"]
        resmin          = canvas_props["resmin"]
        resmax          = canvas_props["resmax"]
        partial_titles  = canvas_props["title"].split(";")
        symbol_color    = data_props["marker_color"]
        symbol_size     = data_props["marker_size"]
        symbol          = data_props["marker"]
        curve_color     = data_props["curve_color"]
        curve_thickness = data_props["curve_thickness"]
        curve_style     = data_props["curve_style"]
        px, py, y_r     = None, None, None
        self.grid       = grid
        axis_titles     = []
        if len(partial_titles) == 1:
            axis_titles = [
                canvas_props["title"].strip(),
                canvas_props["xaxis"].strip(),
                canvas_props["yaxis"].strip(),
                "",
            ]
        else:
            axis_titles = [
                partial_titles[0].strip(),
                partial_titles[1].strip(),
                canvas_props["xaxis"].strip(),
                canvas_props["yaxis"].strip(),
            ]

        if model._has_data:

            # Fitting expression to data, if there's any expression
            if fit_props["adjust"]:
                if model._exp_model != "":
                    model.fit(wsx=not sigma_x, wsy=not sigma_y)
                else:
                    model._isvalid = False
            else:
                if model._exp_model != "":
                    model.createDummyModel()
                else:
                    model._isvalid = False

            # Plotting if the model is valid
            if model._isvalid:
                # Clearing the current plot
                self.clearAxis()

                # Getting data
                x, y, sy, sx = model.data
                y_r = None
                if fit_props["adjust"]:
                    y_r = model.residuo
                else:
                    y_r = model.residuoDummy
                if residuals:
                    self.switchAxes(hideAxes2=False)
                    if sigma_x and sigma_y:  # Caso considerar as duas incertezas
                        ssy = model.predictInc(not sigma_x)
                        self.axes1.errorbar(
                            x,
                            y,
                            yerr=sy,
                            xerr=sx,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                        self.axes2.errorbar(
                            x,
                            y_r,
                            yerr=ssy,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                    elif (sigma_x is False
                          and sigma_y is False):  # Caso desconsiderar as duas
                        self.axes1.errorbar(
                            x,
                            y,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                        self.axes2.errorbar(
                            x,
                            y_r,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                    elif sigma_x is False and sigma_y is True:  # Caso considerar só sy
                        ssy = model.predictInc(not sigma_x)
                        self.axes1.errorbar(
                            x,
                            y,
                            yerr=sy,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                        self.axes2.errorbar(
                            x,
                            y_r,
                            yerr=ssy,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                    else:  # Caso considerar só sx
                        ssy = model.predictInc(not sigma_x)
                        self.axes1.errorbar(
                            x,
                            y,
                            xerr=sx,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                        self.axes2.errorbar(
                            x,
                            y_r,
                            yerr=ssy,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                    self.set_axes_props_with_axes_2(
                        xmin,
                        xmax,
                        xdiv,
                        ymin,
                        ymax,
                        ydiv,
                        resmin,
                        resmax,
                        grid,
                        log_x,
                        log_y,
                    )
                    left, right = self.axes1.get_xlim()
                    px, py = 0.0, 0.0
                    if log_x:
                        px, py = model.get_predict_log(self.axes1.figure, left,
                                                       right)
                    else:
                        px, py = model.get_predict(self.axes1.figure, left,
                                                   right)

                    # Making Plots
                    (line_func, ) = self.axes1.plot(
                        px,
                        py,
                        lw=curve_thickness,
                        color=curve_color,
                        ls=curve_style,
                        label=f"${model._exp_model}$",
                    )

                    # Setting titles
                    self.axes1.set_title(axis_titles[0])
                    self.axes2.set(xlabel=axis_titles[1])
                    self.axes1.set(ylabel=axis_titles[2])
                    self.axes2.set(ylabel=axis_titles[3])
                    if legend:
                        self.axes1.legend(frameon=False)

                    def update(evt):
                        left, right = self.axes1.get_xlim()
                        ppx, ppy = model.get_predict(self.axes1.figure, left,
                                                     right)
                        line_func.set_data(ppx, ppy)
                        self.axes1.figure.canvas.draw_idle()

                    if log_x:

                        def update(evt):
                            left, right = self.axes1.get_xlim()
                            ppx, ppy = model.get_predict_log(
                                self.axes1.figure, left, right)
                            line_func.set_data(ppx, ppy)
                            self.axes1.figure.canvas.draw_idle()

                    self.axes1.remove_callback(self.oid)
                    self.axes1.figure.canvas.mpl_disconnect(self.cid)
                    self.oid = self.axes1.callbacks.connect(
                        "xlim_changed", update)
                    self.cid = self.axes1.figure.canvas.mpl_connect(
                        "resize_event", update)
                else:
                    self.clearAxis()
                    self.switchAxes(hideAxes2=True)

                    # Making Plots
                    if sigma_x and sigma_y:  # Caso considerar as duas incertezas
                        self.axes1.errorbar(
                            x,
                            y,
                            yerr=sy,
                            xerr=sx,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                    elif (sigma_x is False
                          and sigma_y is False):  # Caso desconsiderar as duas
                        self.axes1.errorbar(
                            x,
                            y,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                    elif sigma_x is False and sigma_y is True:  # Caso considerar só sy
                        self.axes1.errorbar(
                            x,
                            y,
                            yerr=sy,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )
                    else:  # Caso considerar só sx
                        self.axes1.errorbar(
                            x,
                            y,
                            xerr=sx,
                            ecolor=symbol_color,
                            capsize=0,
                            elinewidth=1,
                            ms=symbol_size,
                            marker=symbol,
                            color=symbol_color,
                            ls="none",
                        )

                    self.set_axes_props_without_axes_2(xmin, xmax, xdiv, ymin,
                                                       ymax, ydiv, grid, log_x,
                                                       log_y)
                    left, right = self.axes1.get_xlim()
                    px, py = 0.0, 0.0
                    if log_x:
                        px, py = model.get_predict_log(self.axes1.figure, left,
                                                       right)
                    else:
                        px, py = model.get_predict(self.axes1.figure, left,
                                                   right)

                    (line_func, ) = self.axes1.plot(
                        px,
                        py,
                        lw=curve_thickness,
                        color=curve_color,
                        ls=curve_style,
                        label=f"${model._exp_model}$",
                        picker=True,
                    )
                    if legend:
                        self.axes1.legend(fancybox=True)

                    # Setting titles
                    self.axes1.set_title(str(axis_titles[0]))
                    self.axes1.set(xlabel=str(axis_titles[1]))
                    self.axes1.set(ylabel=str(axis_titles[2]))

                    # One piece
                    def update(evt):
                        left, right = self.axes1.get_xlim()
                        ppx, ppy = model.get_predict(self.axes1.figure, left,
                                                     right)
                        line_func.set_data(ppx, ppy)
                        self.axes1.figure.canvas.draw_idle()

                    if log_x:

                        def update(evt):
                            left, right = self.axes1.get_xlim()
                            ppx, ppy = model.get_predict_log(
                                self.axes1.figure, left, right)
                            line_func.set_data(ppx, ppy)
                            self.axes1.figure.canvas.draw_idle()

                    self.axes1.remove_callback(self.oid)
                    self.axes1.figure.canvas.mpl_disconnect(self.cid)
                    self.oid = self.axes1.callbacks.connect(
                        "xlim_changed", update)
                    self.cid = self.figure.canvas.mpl_connect(
                        "resize_event", update)

            else:
                self.clearAxis()
                self.switchAxes(hideAxes2=True)

                x, y, sy, sx = model.data

                # Making Plots
                if sigma_x and sigma_y:  # Caso considerar as duas incertezas
                    self.axes1.errorbar(
                        x,
                        y,
                        yerr=sy,
                        xerr=sx,
                        ecolor=symbol_color,
                        capsize=0,
                        elinewidth=1,
                        ms=symbol_size,
                        marker=symbol,
                        color=symbol_color,
                        ls="none",
                    )
                elif (sigma_x is False
                      and sigma_y is False):  # Caso desconsiderar as duas
                    self.axes1.errorbar(
                        x,
                        y,
                        ecolor=symbol_color,
                        capsize=0,
                        elinewidth=1,
                        ms=symbol_size,
                        marker=symbol,
                        color=symbol_color,
                        ls="none",
                    )
                elif sigma_x is False and sigma_y is True:  # Caso considerar só sy
                    self.axes1.errorbar(
                        x,
                        y,
                        yerr=sy,
                        ecolor=symbol_color,
                        capsize=0,
                        elinewidth=1,
                        ms=symbol_size,
                        marker=symbol,
                        color=symbol_color,
                        ls="none",
                    )
                else:  # Caso considerar só sx
                    self.axes1.errorbar(
                        x,
                        y,
                        xerr=sx,
                        ecolor=symbol_color,
                        capsize=0,
                        elinewidth=1,
                        ms=symbol_size,
                        marker=symbol,
                        color=symbol_color,
                        ls="none",
                    )

                # Setting titles
                self.axes1.set_title(str(axis_titles[0]))
                self.axes1.set(xlabel=str(axis_titles[1]))
                self.axes1.set(ylabel=str(axis_titles[2]))
                self.set_axes_props_without_axes_2(xmin, xmax, xdiv, ymin,
                                                   ymax, ydiv, grid, log_x,
                                                   log_y)

        # Reseting parameters
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
            self.axes1.set_position(self.gs[0].get_position(self.figure),
                                    which="both")
            self.figmode = 0
        else:
            self.axes2.set_visible(True)
            self.axes1.set_position(self.gm[0].get_position(self.figure),
                                    which="both")
            self.axes2.set_position(self.gm[1].get_position(self.figure),
                                    which="both")
            self.figmode = 1

    def set_axes_props_without_axes_2(self, xmin, xmax, xdiv, ymin, ymax, ydiv,
                                      grid, log_x, log_y):
        left, right = self.axes1.get_xlim()
        bottom, top = self.axes1.get_ylim()
        divs_x = len(self.axes1.get_xticks()) - 1
        divs_y = len(self.axes1.get_yticks()) - 1
        xmin = self.makeFloat(xmin, left)
        xmax = self.makeFloat(xmax, right)
        xdiv = self.makeInt(xdiv, divs_x)
        ymin = self.makeFloat(ymin, bottom)
        ymax = self.makeFloat(ymax, top)
        ydiv = self.makeInt(ydiv, divs_y)

        if grid:
            self.axes1.grid(True, which="major")
        if log_y:
            self.axes1.set_yscale("log")
        if log_x:
            self.axes1.set_xscale("log")

        if xdiv != divs_x:
            self.axes1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
            self.axes1.set_xlim(left=xmin, right=xmax)
        else:
            if left != xmin or right != xmax:
                self.axes1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                self.axes1.set_xlim(left=xmin, right=xmax)

        if ydiv != divs_y:
            self.axes1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
            self.axes1.set_ylim(bottom=ymin, top=ymax)
        else:
            if bottom != ymin or top != ymax:
                self.axes1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
                self.axes1.set_ylim(bottom=ymin, top=ymax)

    def set_axes_props_with_axes_2(self, xmin, xmax, xdiv, ymin, ymax, ydiv,
                                   resmin, resmax, grid, log_x, log_y):
        left, right = self.axes1.get_xlim()
        bottom, top = self.axes1.get_ylim()
        botres, topres = self.axes2.get_ylim()
        divs_x = len(self.axes1.get_xticks()) - 1
        divs_y = len(self.axes1.get_yticks()) - 1

        xmin = self.makeFloat(xmin, left)
        xmax = self.makeFloat(xmax, right)
        xdiv = self.makeInt(xdiv, divs_x)
        ymin = self.makeFloat(ymin, bottom)
        ymax = self.makeFloat(ymax, top)
        ydiv = self.makeInt(ydiv, divs_y)
        self.axes2.set_ylim(bottom=self.makeFloat(resmin, botres),
                            top=self.makeFloat(resmax, topres))
        if xdiv != divs_x:
            self.axes1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
            self.axes2.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
            self.axes1.set_xlim(left=xmin, right=xmax)
            self.axes2.set_xlim(left=xmin, right=xmax)
        else:
            if left != xmin or right != xmax:
                self.axes1.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                self.axes2.set_xticks(np.linspace(xmin, xmax, xdiv + 1))
                self.axes1.set_xlim(left=xmin, right=xmax)
                self.axes2.set_xlim(left=xmin, right=xmax)
            else:
                self.axes1.set_xlim(left=xmin, right=xmax)
                self.axes2.set_xlim(left=xmin, right=xmax)

        if ydiv != divs_y:
            self.axes1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
            self.axes1.set_ylim(bottom=ymin, top=ymax)
        else:
            if bottom != ymin or top != ymax:
                self.axes1.set_yticks(np.linspace(ymin, ymax, ydiv + 1))
                self.axes1.set_ylim(bottom=ymin, top=ymax)

        if grid:
            self.axes1.grid(True, which="major")
            self.axes2.grid(True, which="major")
        if log_y:
            self.axes1.set_yscale("log")
        if log_x:
            self.axes1.set_xscale("log")
        plt.setp(self.axes1.get_xticklabels(), visible=False)

    def set_tight_layout(self):
        self.figure.subplots_adjust(left=self.left,
                                    bottom=self.bottom,
                                    right=self.right,
                                    top=self.top)

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
        self.coordinates_changed.emit(self._coordinates)

    coordinates = pyqtProperty(str,
                               getCoordinates,
                               setCoordinates,
                               notify=coordinates_changed)

    @pyqtSlot(str, str, str, str)
    def setPaddings(self, top, bottom, left, right):
        self.top = self.makeFloat(top, valor=0.92)
        self.bottom = self.makeFloat(bottom, valor=0.12)
        self.left = self.makeFloat(left, valor=0.10)
        self.right = self.makeFloat(right, valor=0.95)
        if self.figmode:
            self.figure.subplots_adjust(left=self.left,
                                        bottom=self.bottom,
                                        right=self.right,
                                        top=self.top)
        else:
            self.figure.subplots_adjust(left=self.left,
                                        bottom=self.bottom,
                                        right=self.right,
                                        top=self.top)
            self.switchAxes()
        self.canvas.draw_idle()

    @pyqtSlot(result=str)
    def getPaddings(self):
        return "0.92;0.12;0.10;0.95"

    @pyqtSlot(str, bool)
    def savePlot(self, save_path, transparent):
        """Gets the path from input and save the actual plot."""
        path = QUrl(save_path).toLocalFile()

        # Getting extension
        _, extension = os.path.splitext(path)  # Recebe filename e extension

        if transparent and extension != "png":
            self.message_handler.raiseWarn(
                "O fundo transparente funciona apenas na extensão .png")
            self.canvas.figure.savefig(path, dpi=400, transparent=transparent)
        else:
            self.canvas.figure.savefig(path, dpi=400, transparent=transparent)
            self.message_handler.raiseSuccess("Imagem salva com sucesso!")

    @pyqtSlot()
    def copyToClipboard(self):
        """Copy imagine to the clipboard."""
        # Getting clipboard
        clipboard = QGuiApplication.clipboard()

        # Saving image to a path
        try:
            path = os.path.join(os.path.expanduser(r"~\Documents"),
                                "image.png")
            self.canvas.figure.savefig(path, dpi=150, transparent=False)
            pixmap = QPixmap()
            # Loading image as pixmap and saving to clipboard
            if pixmap.load(path):
                clipboard.setImage(pixmap.toImage())
                self.message_handler.raiseSuccess(
                    "Copiado com sucesso para a área de transferência!")
            os.remove(path)
        except:
            self.message_handler.raiseError(
                "Erro copiar para a área de transferência, contatar os desenvolvedores."
            )

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
            self.axes1.axis("off")
        else:
            self.axes1.axis("on")
        self.canvas.draw_idle()

    @pyqtSlot()
    def SHORTAxis2(self):
        if self.axes2.axison:
            self.axes2.axis("off")
        else:
            self.axes2.axis("on")
        self.canvas.draw_idle()

    @pyqtSlot(int, int)
    def set_canvas_size(self, width, height):
        if width == 0 or height == 0:
            self.resize_canvas()
            return
        dpi = self.canvas.figure.get_dpi()
        self.canvas.figure.set_size_inches(width / dpi, height / dpi)
        self.canvas.draw_idle()

    @pyqtSlot(result=list)
    def get_canvas_size(self):
        # Getting the dpi of the figure
        dpi = self.canvas.figure.get_dpi()
        # Getting the size of the figure
        width, height = self.canvas.figure.get_size_inches()

        return [int(width * dpi), int(height * dpi), dpi]

    @pyqtSlot()
    def resize_canvas(self):
        """Resizes the figure to fit the canvas"""
        self.canvas.geometryChanged(self.canvas.boundingRect(),
                                    self.canvas.boundingRect())

    @pyqtSlot(int, int, int, int, int)
    def set_font_sizes(self, title_size, x_size, y_size, residual_size,
                       caption_size):
        print(title_size, x_size, y_size, residual_size, caption_size)

    @pyqtSlot(str)
    def set_legend_position(self, position):
        print(position)

    @pyqtSlot(int)
    def set_dpi(self, dpi):
        print(dpi)

    def on_motion(self, event):
        """Update the coordinates on the display."""
        if event.inaxes in (self.axes1, self.axes2):
            self.coordinates = f"({event.xdata:.2f}, {event.ydata:.2f})"
