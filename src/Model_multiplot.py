'''
Classe que gerencia os arquivos do multiplot
'''

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib_backend_qtquick.qt_compat import QtCore
from lmfit.models import ExpressionModel
from lmfit import Parameters
from scipy.odr import ODR, Model as SciPyModel, Data, RealData

class MultiModel(QtCore.QObject):
    def __init__(self, options: dict, arquivos: list):
        super().__init__()
        self.options    = options
        self.arquivos   = arquivos
        self.dfs        = [pd.read_json(arquivo['df']) for arquivo in self.arquivos]
        self.min_x      = np.inf
        self.max_x      = -np.inf
        self.num_cols   = [len(df.columns) for df in self.dfs]
        self.models     = []
        self.parameters = []
        for arquivo, df in zip(arquivos, self.dfs):
            if arquivo['expr'] != '':
                self.models.append(ExpressionModel(arquivo['expr']))
                parametros = Parameters()
                for parametro in arquivo['params'].keys():
                    parametros.add(parametro, value = arquivo['params'][parametro])
                self.parameters.append(parametros)
            else:
                self.models.append(0)
                self.parameters.append(0)
            self.min_x = np.minimum(self.min_x, df['x'].min())
            self.max_x = np.maximum(self.max_x, df['x'].max())
        # print(self.dfs[0]['x'][0])
    

        

        

        
