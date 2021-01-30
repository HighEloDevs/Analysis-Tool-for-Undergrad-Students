# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: guilh

Model Class

"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from copy import deepcopy

class Model():
    def __init__(self):
        self.data       = None
        self.eixos      = [["Eixo x"], ["Eixo y"], ["Título"]]
        self.exp_model  = ""
        self.report_fit = ""
        self.result     = None
        
    def load_data(self, data_path):
        
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
        self.eixos[0] = [name]
    
    def set_y_axis(self, name = ""):
        self.eixos[1] = [name]

    def set_title(self, name = ""):
        self.eixos[2] = [name]
        
    def set_expression(self, exp = ""):
# =============================================================================
#         if type(exp) != str:
#             print("Expression is not a string. Setting to default")
#             return None
# =============================================================================
        self.exp_model = exp

    #def fit(self):
        
        
