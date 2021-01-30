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

class Model():
    def __init__(self):
        self.data       = None
        self.eixos      = [["Eixo x"], ["Eixo y"], ["Título"]]
        self.exp_model  = ""
        self.model      = None
        self.report_fit = ""
        self.result     = None
        self.coef       = list()
        self.params     = Parameters
        
    def load_data(self, data_path):
        """ Loads the data from a given path """
        
        # Janela que seleciona dados -> path
        
        # Making data frame and renaming columns
        df = pd.read_csv(data_path, sep='\t', header=None).dropna()
        # Making sure dot is a decimal separator
        try:
            df = df.applymap(lambda x: x.replace(',', '.')).astype(float)
        except:
            pass
        
        # Naming columns
        try:
            df.columns=['x', 'sx', 'y', 'sy']
        except:
            df.columns=['x', 'y']
            
        self.data = deepcopy(df)
        
    def set_x_axis(self, name = ""):
        """ Set new x label to the graph """
        self.eixos[0] = [name]
    
    def set_y_axis(self, name = ""):
        """ Set new y label to the graph """
        self.eixos[1] = [name]

    def set_title(self, name = ""):
        """ Set new title to the graph """
        self.eixos[2] = [name]
        
    def set_expression(self, exp = ""):
        """ Set new expression to model"""
# =============================================================================
#         if type(exp) != str:
#             print("Expression is not a string. Setting to default")
#             return None
# =============================================================================
        self.exp_model = exp
        self._set_model()
        
    def _set_model(self):
        """ Creates the new model """
        self.model = ExpressionModel(self.exp_model)
        for i in self.model.param_names:
            self.coef.append(i)            
            self.params.add(i, value=1)
        

    def plot_data(self, figsize = None, dpi = 120, size = 1, lw = 1, mstyle = '.', color = 'blue'):
        """ Scatter the data """
        fig = plt.figure(figsize = figsize, dpi = dpi)
        plt.scatter(x = self.data["x"], y = self.data["y"], s = size, c = color, marker = mstyle,
                    linewidths = 1)
        plt.errorbar(x = self.data["x"], y = self.data["y"], yerr=self.data["sy"], xerr = self.data["sx"],
                     fmt = 'ko', ecolor = 'black', capsize = 2, ms = size, elinewidth = 1)
        fig.show()
        
    def get_coefficients(self):
        return self.coef 
        

    #def fit(self):
        
        
