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


class Canvas(QObject):
    """TODO"""

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
        self.legend_loc_dict = {
            "Automático" : 0,
            "Direita-Superior" : 1,
            "Esquerda-Superior" : 2,
            "Esquerda-Inferior" : 3,
            "Direita-Inferior" : 4,
            "Esquerda-Centro" : 6,
            "Direita-Centro" : 7,
            "Centro-Inferior" : 8,
            "Centro-Superior" : 9,
            "Centro-Centro" : 10
        }
        self.legend_loc = "best"
        self.dpi = 500
        self.font_sizes = {
            "titulo" : 12,
            "residuos" : 12,
            "legenda" : 12,
            "eixo_x" : 12,
            "eixo_y" : 12,
        }
        self.user_alpha_outliers = 0.25
        self.user_color_outliers = None
        # This is used to display the coordinates of the mouse in the window
        self._coordinates = ""

    def update_with_canvas(self, canvas):
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

    def clear_axis(self):
        """Clear the current plot in the axis."""
        self.axes1.cla()
        self.axes2.cla()
        self.axes1.relim()
        self.axes2.relim()
        self.axes1.remove_callback(self.oid)
        self.axes1.figure.canvas.mpl_disconnect(self.cid)
        self.canvas.draw_idle()

    def switch_axes(self, hide_axes2: bool = True):
        """Função que oculta ou não o eixo secundário."""
        if hide_axes2:
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
        xmin = self.make_float(xmin, left)
        xmax = self.make_float(xmax, right)
        xdiv = self.make_int(xdiv, divs_x)
        ymin = self.make_float(ymin, bottom)
        ymax = self.make_float(ymax, top)
        ydiv = self.make_int(ydiv, divs_y)

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

        xmin = self.make_float(xmin, left)
        xmax = self.make_float(xmax, right)
        xdiv = self.make_int(xdiv, divs_x)
        ymin = self.make_float(ymin, bottom)
        ymax = self.make_float(ymax, top)
        ydiv = self.make_int(ydiv, divs_y)
        self.axes2.set_ylim(bottom=self.make_float(resmin, botres),
                            top=self.make_float(resmax, topres))
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

    def plot_error_bar(self, x, y, kargs_errorbar, alpha, sy= None, sx = None, y_r = None, ssy = None):
        self.axes1.errorbar(x, y, yerr=sy, xerr=sx, alpha = alpha, **kargs_errorbar)
        if y_r is not None:
            self.axes2.errorbar(x, y_r, yerr=ssy, alpha = alpha, **kargs_errorbar)

    def set_tight_layout(self):
        self.figure.subplots_adjust(left=self.left,
                                    bottom=self.bottom,
                                    right=self.right,
                                    top=self.top)

    def make_float(self, var, valor):
        try:
            return float(var)
        except:
            return valor

    def make_int(self, var, valor):
        try:
            return int(var)
        except:
            return valor

    def get_coordinates(self):
        """Retorna as coordenadas no gráfico."""
        return self._coordinates

    def set_coordinates(self, coordinates):
        """Seta as coordenadas do gráfico."""
        self._coordinates = coordinates
        self.coordinates_changed.emit(self._coordinates)

    @pyqtSlot(str, str, str, str)
    def set_paddings(self, top, bottom, left, right):
        self.top = self.make_float(top, valor=0.92)
        self.bottom = self.make_float(bottom, valor=0.12)
        self.left = self.make_float(left, valor=0.10)
        self.right = self.make_float(right, valor=0.95)
        if self.bottom >= self.top or self.left >= self.right:
            self.message_handler.raise_error("Paddings invalidos.")
            return None
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
            self.switch_axes()
        self.canvas.draw_idle()

    @pyqtSlot(result=str)
    def get_paddings(self):
        return "0.92;0.12;0.10;0.95"

    @pyqtSlot(str, bool)
    def save_plot(self, save_path, transparent):
        """Gets the path from input and save the actual plot."""
        path = QUrl(save_path).toLocalFile()

        # Getting extension
        _, extension = os.path.splitext(path)  # Recebe filename e extension

        if transparent and extension != "png":
            self.message_handler.raise_warn(
                "O fundo transparente funciona apenas na extensão .png")
            self.canvas.figure.savefig(path, dpi = self.dpi, transparent = transparent)
        else:
            self.canvas.figure.savefig(path, dpi = self.dpi, transparent = transparent)
            self.message_handler.raise_success("Imagem salva com sucesso!")

    @pyqtSlot()
    def copy_to_clipboard(self):
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
                self.message_handler.raise_success(
                    "Copiado com sucesso para a área de transferência!")
            os.remove(path)
        except:
            self.message_handler.raise_error(
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
    def shortcut_grid(self):
        self.axes1.grid(not self.grid)
        self.axes2.grid(not self.grid)
        self.grid = not self.grid
        self.canvas.draw_idle()

    @pyqtSlot()
    def shortcut_axis_1(self):
        if self.axes1.axison:
            self.axes1.axis("off")
        else:
            self.axes1.axis("on")
        self.canvas.draw_idle()

    @pyqtSlot()
    def shortcut_axis_2(self):
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
        self.font_sizes["titulo"] = title_size
        self.font_sizes["eixo_x"] = x_size
        self.font_sizes["eixo_y"] = y_size
        self.font_sizes["residuos"] = residual_size
        self.font_sizes["legenda"] = caption_size
        if self.figmode:
            self.axes1.set_title(self.axes1.get_title(), fontsize=self.font_sizes["titulo"])
            self.axes1.set_ylabel(self.axes1.get_ylabel(), fontsize=self.font_sizes["eixo_y"])
            self.axes2.set_xlabel(self.axes2.get_xlabel(), fontsize=self.font_sizes["eixo_x"])
            self.axes2.set_ylabel(self.axes2.get_ylabel(), fontsize=self.font_sizes["residuos"])
        else:
            self.axes1.set_title(self.axes1.get_title(), fontsize=self.font_sizes["titulo"])
            self.axes1.set_xlabel(self.axes1.get_xlabel(), fontsize=self.font_sizes["eixo_x"])
            self.axes1.set_ylabel(self.axes1.get_ylabel(), fontsize=self.font_sizes["eixo_y"])
        self.canvas.draw_idle()

    @pyqtSlot(str)
    def set_legend_position(self, position):
        self.legend_loc = self.legend_loc_dict[position]
        h, l = self.axes1.get_legend_handles_labels()
        if len(h) > 0:
            self.axes1.legend(h, l, loc=self.legend_loc,
                 fontsize=self.font_sizes["legenda"])

    @pyqtSlot(int)
    def set_dpi(self, dpi):
        self.dpi = dpi

    def on_motion(self, event):
        """Update the coordinates on the display."""
        if event.inaxes in (self.axes1, self.axes2):
            self.coordinates = f"({event.xdata:.2f}, {event.ydata:.2f})"

    coordinates = pyqtProperty(str,
                               get_coordinates,
                               set_coordinates,
                               notify=coordinates_changed)
