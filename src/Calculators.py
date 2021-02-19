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

def interpreter_calculator(f, opt, nc, ngl, mean, std):
    if f == 0:
        x_plot = np.linspace(chi2.ppf(0.005, ngl), chi2.ppf(0.999, ngl), 350)
        y_plot = chi2.pdf(x_plot, ngl)
        if opt == 0:
            result = calc_chi2_sim(ngl, nc)
            s      = "Limite inferior = %f \n Limite superior  = %f"%(result[0], result[1])
            return s, x_plot, y_plot
        elif opt == 1:
            result = calc_chi2_lim_inf(ngl, nc)
            s      = "Limite inferior = %f \n Limite superior = inf"%result
            return s, x_plot, y_plot 
        result = calc_chi2_lim_sup(ngl, nc)
        s      = "Limite inferior = -inf \n Limite superior = %f"%result
        return s, x_plot, y_plot
    elif f == 1:
        x_plot = np.linspace(chi2.ppf(0.005, ngl), chi2.ppf(0.999, ngl), 350)
        y_plot = chi2.pdf(x_plot, ngl)
        x_plot = x_plot/chi2.ppf(0.5, ngl)
        y_plot = y_plot/chi2.pdf(chi2.ppf(0.5, ngl), ngl)
        if opt == 0:
            result = calc_chi2r_sim(ngl, nc)
            s      = "Limite inferior = %f \n Limite superior  = %f"%(result[0], result[1])
            return s, x_plot, y_plot
        elif opt == 1:
            result = calc_chi2r_lim_inf(ngl, nc)
            s      = "Limite inferior = %f \n Limite superior = inf"%result
            return s, x_plot, y_plot
        result = calc_chi2r_lim_sup(ngl, nc)
        s      = "Limite inferior = -inf \n Limite superior = %f"%result
        return s, x_plot, y_plot
    elif f == 2:
        x_plot = np.linspace(norm.ppf(0.005) , norm.ppf(0.999), 350)
        y_plot = norm.pdf(x_plot)
        x_plot = x_plot * std + mean
        if opt == 0:
            result = calc_gauss_sim(mean, std, nc)
            s      = "Limite inferior = %f \n Limite superior  = %f"%(result[0], result[1])
            return s, x_plot, y_plot
        elif opt == 1:
            result = calc_gauss_lim_inf(mean, std, nc)
            s      = "Limite inferior = %f \n Limite superior = inf"%result
            return s, x_plot, y_plot
        result = calc_gauss_lim_sup(mean, std, nc)
        s      = "Limite inferior = -inf \n Limite superior = %f"%result
        return s, x_plot, y_plot
    x_plot = np.linspace(t.ppf(0.005, df = ngl)*std + mean, t.ppf(0.999, df = ngl)*std + mean)
    y_plot = t.pdf(x_plot)
    if opt == 0:
        result = calc_t_sim(mean, std, ngl, nc)
        s      = "Limite inferior = %f \n Limite superior  = %f"%(result[0], result[1])
        return s, x_plot, y_plot
    elif opt == 1:
            result = calc_t_lim_inf(mean, std, ngl, nc)
            s      = "Limite inferior = %f \n Limite superior = inf"%result
            return s, x_plot, y_plot
    result = calc_t_lim_sup(mean, std, ngl, nc)
    s      = "Limite inferior = -inf \n Limite superior = %f"%result
    return s, x_plot, y_plot

class CalculatorCanvas(QtCore.QObject):
    """ A bridge class to interact with the plot in python
    """
    def __init__(self, parent=None):
        super().__init__(parent)

        # The figure, canvas, toolbar and axes
        self.figure  = None
        self.canvas  = None
        self.toolbar = None
        self.axes    = None
        self.ax1     = None
        self.ax2     = None

    def updateWithCanvas(self, canvas):
        """ initialize with the canvas for the figure
        """
        self.canvas = canvas
        self.figure = self.canvas.figure
        self.axes = self.figure.add_subplot(111)
        self.axes.grid(True)
        self.canvas.draw_idle()

    def Plot(self, x, y):
        try:
            self.axes.remove()
        except:
            pass
        self.axes = self.figure.add_subplot(111)
        self.axes.grid(True)
        self.axes.plot(x, y, lw = 1, c = 'red')
        self.axes.set_title("P.D.F")
        self.canvas.draw_idle()