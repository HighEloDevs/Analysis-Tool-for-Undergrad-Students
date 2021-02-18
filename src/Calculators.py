# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

MatPlotLib Class

"""
from matplotlib_backend_qtquick.backend_qtquick import NavigationToolbar2QtQuick
from matplotlib_backend_qtquick.qt_compat import QtCore
import numpy as np
from numpy import array
from scipy.stats import chi2, norm, t

def calc_chi2_sim(ngl, nc):
    return array([chi2.ppf(0.5 - nc/2, ngl), chi2.ppf(0.5 + nc/2, ngl)])

def calc_chi2_lim_inf(ngl, nc):
    return chi2.ppf(1 - nc, ngl)

def calc_chi2_lim_sup(ngl, nc):
    return chi2.ppf(nc, ngl)

def calc_gauss_sim(media, dp, nc):
    return array([norm.ppf(0.5 - nc/2)*dp + media, norm.ppf(0.5 + nc/2)*dp + media])

def calc_gauss_lim_inf(media, dp, nc):
    return norm.ppf(1 - nc)*dp + media

def calc_gauss_lim_sup(media, dp, nc):
    return norm.ppf(nc)*dp + media

def calc_t_sim(media, dp, ngl, nc):
    return array([t.ppf(0.5 - nc/2, df = ngl)*dp + media, t.ppf(0.5 + nc/2, df = ngl)*dp + media])

def calc_t_lim_inf(media, dp, ngl, nc):
    return chi2.ppf(1 - nc, df = ngl)*dp + media

def calc_t_lim_sup(media, dp, ngl, nc):
    return chi2.ppf(nc, df = ngl)*dp + media

def calc_chi2r_sim(ngl, nc):
    return [chi2.ppf(0.5 - nc/2, ngl)/ngl, chi2.ppf(0.5 + nc/2, ngl)/ngl]

def calc_chi2r_lim_inf(ngl, nc):
    return chi2.ppf(1 - nc, ngl)/ngl

def calc_chi2r_lim_sup(ngl, nc):
    return chi2.ppf(nc, ngl)/ngl

class CalculatorCanvas(QtCore.QObject):
    """ A bridge class to interact with the plot in python
    """
    def __init__(self, parent=None):
        super().__init__(parent)

        # The figure, canvas, toolbar and axes
        self.figure = None
        self.canvas = None
        self.toolbar = None
        self.axes = None
        self.ax1 = ''
        self.ax2 = ''

    def updateWithCanvas(self, canvas):
        """ initialize with the canvas for the figure
        """
        self.canvas = canvas
        self.figure = self.canvas.figure
        self.axes = self.figure.add_subplot(111)
        self.axes.grid(True)
        canvas.draw_idle()

    def Plot(self):
        pass