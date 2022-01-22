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

import numpy as np
from PyQt5.QtCore import QObject
from scipy.stats import chi2, norm, t
from numpy import array

def calc_chi2_sim(ngl, nc):
    return array([chi2.ppf(0.5 - nc/2, ngl), chi2.ppf(0.5 + nc/2, ngl)])

def calc_chi2_lim_inf(ngl, nc):
    return chi2.ppf(1 - nc, ngl)

def calc_chi2_lim_sup(ngl, nc):
    return chi2.ppf(nc, ngl)

def calc_gauss_sim(nc):
    return array([norm.ppf(0.5 - nc/2), norm.ppf(0.5 + nc/2)])

def calc_gauss_lim_inf(nc):
    return norm.ppf(1 - nc)

def calc_gauss_lim_sup(nc):
    return norm.ppf(nc)

def calc_t_sim(ngl, nc):
    return array([t.ppf(0.5 - nc/2, df = ngl), t.ppf(0.5 + nc/2, df = ngl)])

def calc_t_lim_inf(ngl, nc):
    return t.ppf(1 - nc, df = ngl)

def calc_t_lim_sup(ngl, nc):
    return t.ppf(nc, df = ngl)

def calc_chi2r_sim(ngl, nc):
    return [chi2.ppf(0.5 - nc/2, ngl), chi2.ppf(0.5 + nc/2, ngl)]

def calc_chi2r_lim_inf(ngl, nc):
    return chi2.ppf(1 - nc, ngl)

def calc_chi2r_lim_sup(ngl, nc):
    return chi2.ppf(nc, ngl)

def interpreter_calculator(f, opt, nc, ngl, mean, std):
    ''' Return the plot string and the arrays for the graph plot.
    '''
    lim_inf = 0.0001
    lim_sup = 0.9999
    if nc > 0.9999:
        dif = (1 - nc)/2
        lim_inf = dif
        lim_sup = nc + dif
    
    if f == 0:
        # If it's Chi²
        x_plot = np.linspace(chi2.ppf(lim_inf, ngl), chi2.ppf(lim_sup, ngl), 350)
        y_plot = chi2.pdf(x_plot, ngl)
        s      = f"Calculadora de intervalo de confiança do Chi quadrado.\nNível de confiança {nc}.\nNível de significância {1 - nc:.7}\n"

        if opt == 0:
            result = calc_chi2_sim(ngl, nc)
            s     += "Intervalo simétrico.\nLimite inferior = %f \n Limite superior  = %f"%(result[0], result[1])
            x_area = np.linspace(result[0], result[1], 350)
            y_area = chi2.pdf(x_area, ngl)
            return s, x_plot, y_plot, x_area, y_area, f"Chi² com NGL = {int(ngl)}", "Chi²", "Densidade de probabilidade"

        elif opt == 1:
            result = calc_chi2_lim_inf(ngl, nc)
            s     += "Apenas limite inferior.\nLimite inferior = %f \n Limite superior = inf"%result
            x_area = np.linspace(result, chi2.ppf(lim_sup, ngl), 350)
            y_area = chi2.pdf(x_area, ngl)
            return s, x_plot, y_plot, x_area, y_area, f"Chi² com NGL = {int(ngl)}", "Chi²", "Densidade de probabilidade" 

        result = calc_chi2_lim_sup(ngl, nc)
        s     += "Apenas limite superior.\nLimite inferior = -inf \n Limite superior = %f"%result
        x_area = np.linspace(chi2.ppf(lim_inf, ngl), result, 350)
        y_area = chi2.pdf(x_area, ngl)
        return s, x_plot, y_plot, x_area, y_area, f"Chi² com NGL = {int(ngl)}", "Chi²", "Densidade de probabilidade"

    elif f == 1:
        # If it's Red Chi²
        x_plot = np.linspace(chi2.ppf(lim_inf, ngl), chi2.ppf(lim_sup, ngl), 350)
        y_plot = chi2.pdf(x_plot, ngl)
        x_plot = x_plot/ngl
        y_plot = y_plot*ngl
        s      = f"Calculadora de intervalo de confiança do Chi quadrado reduzido.\nNível de confiança {nc}.\nNível de significância {1 - nc:.7}\n"

        if opt == 0:
            result = calc_chi2r_sim(ngl, nc)
            s     += "Intervalo simétrico.\nLimite inferior = %f \n Limite superior  = %f"%(result[0]/ngl, result[1]/ngl)
            x_area = np.linspace(result[0], result[1], 350)
            y_area = chi2.pdf(x_area, ngl)*ngl
            x_area = x_area/ngl
            return s, x_plot, y_plot, x_area, y_area, f"Chi² reduzido com NGL = {int(ngl)}", "Chi² reduzido", "Densidade de probabilidade"

        elif opt == 1:
            result = calc_chi2r_lim_inf(ngl, nc)
            s     += "Apenas limite inferior.\nLimite inferior = %f \n Limite superior = inf"%(result/ngl)
            x_area = np.linspace(result, chi2.ppf(lim_sup, ngl), 350)
            y_area = chi2.pdf(x_area, ngl)*ngl
            x_area = x_area/ngl
            return s, x_plot, y_plot, x_area, y_area, f"Chi² reduzido com NGL = {int(ngl)}", "Chi² reduzido", "Densidade de probabilidade"

        result = calc_chi2r_lim_sup(ngl, nc)
        s     += "Apenas limite superior.\nLimite inferior = -inf \n Limite superior = %f"%(result/ngl)
        x_area = np.linspace(chi2.ppf(lim_inf, ngl), result, 350)
        y_area = chi2.pdf(x_area, ngl)*ngl
        x_area = x_area/ngl
        return s, x_plot, y_plot, x_area, y_area, f"Chi² reduzido com NGL = {int(ngl)}", "Chi² reduzido", "Densidade de probabilidade"

    elif f == 2:
        # If it's Gaussian
        x_plot = np.linspace(norm.ppf(lim_inf) , norm.ppf(lim_sup), 350)
        y_plot = norm.pdf(x_plot)
        x_plot = (x_plot * std) + mean
        s      = f"Calculadora de intervalo de confiança de Gaussiana.\nNível de confiança {nc}.\nNível de significância {1 - nc:.7}\n"

        if opt == 0:
            result = calc_gauss_sim(nc)
            s     += "Intervalo simétrico.\nLimite inferior = %f \n Limite superior  = %f"%(result[0]*std + mean, result[1]*std + mean)
            x_area = np.linspace(result[0], result[1], 350)
            y_area = norm.pdf(x_area)
            x_area = x_area*std + mean
            return s, x_plot, y_plot/std, x_area, y_area/std, "Gaussiana", "Valor", "Densidade de probabilidade"

        elif opt == 1:
            result = calc_gauss_lim_inf(nc)
            s     += "Apenas limite inferior.\nLimite inferior = %f \n Limite superior = inf"%(result*std + mean)
            x_area = np.linspace(result, norm.ppf(lim_sup), 350)
            y_area = norm.pdf(x_area)
            x_area = x_area*std + mean
            return s, x_plot, y_plot/std, x_area, y_area/std, "Gaussiana", "Valor", "Densidade de probabilidade"

        result = calc_gauss_lim_sup(nc)
        s     += "Apenas limite superior.\nLimite inferior = -inf \n Limite superior = %f"%(result*std + mean)
        x_area = np.linspace(result, norm.ppf(lim_inf), 350)
        y_area = norm.pdf(x_area)
        x_area = x_area*std + mean
        return s, x_plot, y_plot/std, x_area, y_area/std, "Gaussiana", "Valor", "Densidade de probabilidade"

    # If it's Student:    
    x_plot = np.linspace(t.ppf(lim_inf, df = ngl), t.ppf(lim_sup, df = ngl), 350)
    y_plot = t.pdf(x_plot, df = ngl)
    x_plot = x_plot * std + mean
    s      = f"Calculadora de intervalo de confiança de Student.\nNível de confiança {nc} | Nível de significância {1 - nc:.7}\n"

    if opt == 0:
        result = calc_t_sim(ngl, nc)
        s     += "Intervalo simétrico.\nLimite inferior = %f \n Limite superior  = %f"%(result[0]*std + mean, result[1]*std + mean)
        x_area = np.linspace(result[0], result[1], 350)
        y_area = t.pdf(x_area, df = ngl)
        x_area = x_area*std + mean
        return s, x_plot, y_plot/std, x_area, y_area/std, "Student", "Valor", "Densidade de probabilidade"
    
    elif opt == 1:
            result = calc_t_lim_inf(ngl, nc)
            s     += "Apenas limite inferior.\nLimite inferior = %f \n Limite superior = inf"%(result*std + mean)
            x_area = np.linspace(result, t.ppf(lim_sup, df = ngl), 350)
            y_area = t.pdf(x_area, df = ngl)
            x_area = x_area*std + mean
            return s, x_plot, y_plot/std, x_area, y_area/std, "Student", "Valor", "Densidade de probabilidade"

    result = calc_t_lim_sup(ngl, nc)
    s     += "Apenas limite superior.\nLimite inferior = -inf \n Limite superior = %f"%(result*std + mean)
    x_area = np.linspace(result, t.ppf(lim_inf, df = ngl), 350)
    y_area = t.pdf(x_area, df = ngl)
    x_area = x_area*std + mean
    return s, x_plot, y_plot/std, x_area, y_area/std, "Student", "Valor", "Densidade de probabilidade"

class CalculatorCanvas(QObject):
    """ A bridge class to interact with the plot in python
    """
    def __init__(self, parent=None):
        super().__init__(parent)
        # self.figure  = None
        

def plot(displayBridge, x, y, x_area, y_area, title, xlabel, ylabel):
    displayBridge.set_tight_layout()
    displayBridge.clear_axis()
    displayBridge.switch_axes(hide_axes2 = True)
    displayBridge.grid = True
    displayBridge.axes1.grid(True)
    displayBridge.axes1.fill_between(x_area, y_area, color = 'blue', alpha = 0.3)
    displayBridge.axes1.plot(x, y, lw = 1, c = 'red')
    displayBridge.axes1.set_title("P.D.F. " + title)
    displayBridge.axes1.set(xlabel = xlabel, ylabel = ylabel)
    displayBridge.set_axes_props_without_axes_2(None, None, None, None, None, None, None, False, False)
    displayBridge.canvas.draw_idle()