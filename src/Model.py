# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

Model Class

"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from copy import deepcopy
from lmfit.models import ExpressionModel
from lmfit import Parameters
from scipy.odr import ODR, Model as SciPyModel, Data, RealData

class Model():
    def __init__(self):
        self.data       = None
        self.eixos      = [["Eixo x"], ["Eixo y"], ["Título"]]
        self.exp_model  = ""
        self.model      = None
        self.report_fit = ""
        self.result     = None
        self.coef       = list()
        self.params     = Parameters()
        self.dict       = dict()
        self.p0         = None
        self.mode       = 0
        self.has_data   = False
        self.isvalid    = False
        self.has_sx     = True
        self.has_sy     = True
        
    def __str__(self):
        return self.report_fit
        
    def load_data(self, data_path):
        """ Loads the data from a given path. """
        df = pd.read_csv(data_path, sep='\t', header=None, dtype = str).dropna()
        for i in df.columns:
            df[i] = [x.replace(',', '.') for x in df[i]]
            df[i] = df[i].astype(float)
        self.mode = len(df.columns) - 2

        self.has_sx     = True
        self.has_sy     = True

        # Naming columns
        
        if self.mode == 0:
            df["sy"] = [1]*len(df[0])
            df["sx"] = [1]*len(df[0])
            self.has_sy = False
            self.has_sx = False
        elif self.mode == 1:
            df["sx"] = [1]*len(df[0])
            self.has_sx = False
        df.columns= ['x', 'y', 'sy', 'sx']
            
        self.data     = deepcopy(df)
        self.has_data = True
        
    def set_x_axis(self, name = ""):
        """ Set new x label to the graph. """
        self.eixos[0] = [name]
    
    def set_y_axis(self, name = ""):
        """ Set new y label to the graph. """
        self.eixos[1] = [name]

    def set_title(self, name = ""):
        """ Set new title to the graph. """
        self.eixos[2] = [name]

    def set_p0(self, p0):
        self.p0 = p0
        
    def set_expression(self, exp = ""):
        """ Set new expression to model. """
        self.exp_model = exp
        
    def fit(self, **kargs):

        wsx = kargs.pop("wsx", True)
        wsy = kargs.pop("wsy", True)

        # Getting Model
        self.model = ExpressionModel(self.exp_model)

        # Getting coefficients
        self.coef = [i for i in self.model.param_names]
        
        # If there's no p0, everything is set to 1.0

        pi = list()

        if self.p0 is None:
            for i in range(len(self.model.param_names)):
                pi.append(1.0)

        else:
            for i in range(len(self.model.param_names)):
                try:
                    pi.append(self.p0[i])
                except:
                    pi.append(1.0)




        # Data
        x, y, sy, sx = self.get_data()
        data = None
        if wsx == True and wsy == True:
            data = RealData(x, y)
        
        elif wsx:
            data = RealData(x, y, sy = sy)
        
        elif wsy:
            data = RealData(x, y, sx = sx)

        else:
            data = RealData(x, y, sx = sx, sy = sy)
        
        def f(a, x):
            param = Parameters()
            for i in range(len(a)):
                param.add(self.model.param_names[i], value=a[i])
            return self.model.eval(x=x, params=param)
        model = SciPyModel(f)
        myodr = ODR(data, model, beta0 = pi)
        self.result = myodr.run()

        # self.result = self.model.fit(data=self.data["y"].to_numpy(), x = self.data["x"].to_numpy(),
        #                              params=self.params, scale_covar = False,
        #                              weights = 1/self.data["sy"].to_numpy())
        self._set_param_values()
        self._set_report()
        
    def get_params(self):
        ''' Return a dict with parameters as keys and returns a list with [value, uncertainty]. '''
        return self.dict
        
    def _set_param_values(self):
        self.dict.clear()
        for i in range(len(self.coef)):
            self.params.add(self.coef[i], self.result.beta[i])
            self.dict.update({self.coef[i]: [self.result.beta[i], np.sqrt(self.result.cov_beta[i, i])]})
                
    def _set_report(self):
        self.report_fit = ""
        self.report_fit += "\nAjuste: y = %s\n"%self.exp_model
        self.report_fit += "\nNGL  = %d"%(len(self.data["x"]) - len(self.coef))
        self.report_fit += "\nChi² = %f"%self.result.sum_square
        self.report_fit += "\nMatriz de covariância:\n" + str(self.result.cov_beta) + "\n\n"
        self.isvalid     = True

    def plot_data(self, figsize = None, dpi = 120, size = 1, lw = 1, mstyle = '.', color = 'blue'):
        """ Scatter the data. """
        fig = plt.figure(figsize = figsize, dpi = dpi)
        plt.scatter(x = self.data["x"].to_numpy(), y = self.data["y"].to_numpy(), s = size,
                    c = color, marker = mstyle, linewidths = 1)
        plt.errorbar(x = self.data["x"].to_numpy(), y = self.data["y"].to_numpy(),
                     yerr=self.data["sy"].to_numpy(), xerr = self.data["sx"].to_numpy(),
                     fmt = 'ko', ecolor = 'black', capsize = 2, ms = size, elinewidth = 1)
        fig.show()
        
    def get_coefficients(self):
        ''' Deprecated function. '''
        return self.coef 
    
    def get_data(self, *args):
        ''' Return data arrays based on mode attribute. '''
        # if self.mode == 0:
        #     return self.data["x"].to_numpy(), self.data["y"].to_numpy()
        # elif self.mode == 1:
        #     return self.data["x"].to_numpy(), self.data["y"].to_numpy(), self.data["sy"].to_numpy()
        return self.data["x"].to_numpy(), self.data["y"].to_numpy(), self.data["sy"].to_numpy(), self.data["sx"].to_numpy()
        
    def get_predict(self):
        ''' Return two points to form the adjusted function. '''
        x_min = self.data['x'].min()
        x_max = self.data['x'].max()
        x_plot = np.linspace(x_min, x_max, len(self.data['x']))
        return x_plot, self.model.eval(x = x_plot, params = self.params)
    
    def get_residuals(self):
        ''' Return residuals from adjust. '''
        return self.data["y"].to_numpy() - self.model.eval(x = self.data["x"].to_numpy())
        
        
