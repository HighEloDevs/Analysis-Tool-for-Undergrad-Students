# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

Model Class

"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib_backend_qtquick.qt_compat import QtCore
# from PySide2.QtCore import Slot, Signal
from copy import deepcopy
from lmfit.models import ExpressionModel
from lmfit import Parameters
from scipy.odr import ODR, Model as SciPyModel, Data, RealData
from copy import deepcopy

class Model(QtCore.QObject):
    """Class used for fit
    """
    # Signals
    fillDataTable = QtCore.Signal(float, float, float, float, str, arguments=['x', 'y', 'sy', 'sx', 'filename'])
    fillParamsTable = QtCore.Signal(str, float, float, arguments=['param', 'value', 'uncertainty'])
    writeInfos = QtCore.Signal(str, arguments='expr')

    def __init__(self):
        super().__init__()
        self.data       = None
        self.data_json  = None
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
        self.x          = None
        self.y          = None
        self.sy         = None
        self.sx         = None
        
    def __str__(self):
        return self.report_fit
        
    @QtCore.Slot(QtCore.QJsonValue)
    def getData(self, data):
        """Getting data from table"""
        df = pd.DataFrame.from_records(data.toVariant())
        df.columns = ['x', 'y', 'sy', 'sx', 'bool']

        df = df[df['bool'] == 1]

        # Dropping some useless columns
        if df[df['sx'] != 0].empty: del df['sx']
        if df[df['sy'] != 0].empty: del df['sy']
        del df['bool']

        self.mode = len(df.columns) - 2
        self.has_sx     = True
        self.has_sy     = True

        # Naming columns
        if self.mode == 0:
            self.data_json        = deepcopy(df)
            # self.data_json.colums = ['x', 'y']
            df["sy"]              = 1
            df["sx"]              = 1
            self.has_sy           = False
            self.has_sx           = False
        elif self.mode == 1:
            self.data_json        = deepcopy(df)
            # self.data_json.colums = ['x', 'y', 'sy']
            df["sx"]              = 1
            self.has_sx           = False
        else:
            self.data_json         = deepcopy(df)
            # self.data_json.columns = ['x', 'y', 'sy', 'sx']
        df.columns    = ['x', 'y', 'sy', 'sx']
        self.data     = deepcopy(df)
        self.has_data = True
        
        self.x  = self.data["x"].to_numpy()
        self.y  = self.data["y"].to_numpy()
        self.sy = self.data["sy"].to_numpy()
        self.sx = self.data["sx"].to_numpy()
                
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
            self.data_json        = deepcopy(df)
            # self.data_json.colums = ['x', 'y']
            df["sy"]              = 1
            df["sx"]              = 1
            self.has_sy           = False
            self.has_sx           = False
        elif self.mode == 1:
            self.data_json        = deepcopy(df)
            # self.data_json.colums = ['x', 'y', 'sy']
            df["sx"]              = 1
            self.has_sx           = False
        else:
            self.data_json         = deepcopy(df)
            # self.data_json.columns = ['x', 'y', 'sy', 'sx']
        df.columns    = ['x', 'y', 'sy', 'sx']
        self.data     = deepcopy(df)
        self.has_data = True

        self.x  = self.data["x"].to_numpy()
        self.y  = self.data["y"].to_numpy()
        self.sy = self.data["sy"].to_numpy()
        self.sx = self.data["sx"].to_numpy()

        x, y, sy, sx = self.get_data()  

        fileName = data_path.split('/')[-1]
        if self.has_sx and self.has_sy:
            for i in range(len(x)):
                self.fillDataTable.emit(x[i], y[i], sy[i], sx[i], fileName)
        elif self.has_sx:
            for i in range(len(x)):
                self.fillDataTable.emit(x[i], y[i], 0, sx[i], fileName)
        elif self.has_sy:
            for i in range(len(x)):
                self.fillDataTable.emit(x[i], y[i], sy[i], 0, fileName)
        else:
            for i in range(len(x)):
                self.fillDataTable.emit(x[i], y[i], 0, 0, fileName)

    def load_data_json(self, df):
        """ Loads the data """
        self.data = df
        self.mode = len(df.columns) - 2
        self.has_sx     = True
        self.has_sy     = True

        # Naming columns
        if self.mode == 0:
            self.data_json        = deepcopy(df)
            # self.data_json.colums = ['x', 'y']
            df["sy"]              = 1
            df["sx"]              = 1
            self.has_sy           = False
            self.has_sx           = False
        elif self.mode == 1:
            self.data_json        = deepcopy(df)
            # self.data_json.colums = ['x', 'y', 'sy']
            df["sx"]              = 1
            self.has_sx           = False
        else:
            self.data_json         = deepcopy(df)
            # self.data_json.columns = ['x', 'y', 'sy', 'sx']
        df.columns    = ['x', 'y', 'sy', 'sx']
        self.data     = deepcopy(df)
        self.has_data = True

        self.x  = self.data["x"].to_numpy()
        self.y  = self.data["y"].to_numpy()
        self.sy = self.data["sy"].to_numpy()
        self.sx = self.data["sx"].to_numpy()

        fileName = 'Dados Carregados do Projeto'

        x, y, sy, sx = self.get_data() 

        if self.has_sx and self.has_sy:
            for i in range(len(x)):
                self.fillDataTable.emit(x[i], y[i], sy[i], sx[i], fileName)
        elif self.has_sx:
            for i in range(len(x)):
                self.fillDataTable.emit(x[i], y[i], 0, sx[i], fileName)
        elif self.has_sy:
            for i in range(len(x)):
                self.fillDataTable.emit(x[i], y[i], sy[i], 0, fileName)
        else:
            for i in range(len(x)):
                self.fillDataTable.emit(x[i], y[i], 0, 0, fileName)
        
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

        pi = list()   # Inital values

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

        if self.mode == 0:
            self.__fit_lm_wy(x, y, pi)
            self.__set_param_values_lm()
            self.__set_report_lm_special()
            
        elif self.mode == 1:
            if wsy:
                self.__fit_lm_wy(x, y, pi)
                self.__set_param_values_lm()
                self.__set_report_lm_special()

            else:
                self.__fit_lm(x, y, sy, pi)
                self.__set_param_values_lm()
                self.__set_report_lm_special()

        else:
            if wsx == True and wsy == True:
                self.__fit_lm_wy(x, y, pi)
                self.__set_param_values_lm()
                self.__set_report_lm_special()
            
            elif wsx:
                self.__fit_lm(x, y, sy, pi)
                self.__set_param_values_lm()
                self.__set_report_lm()
            
            elif wsy:
                data = RealData(x, y, sx = sx)
                self.__fit_ODR(data, pi)
                self.__set_param_values_ODR()
                self.__set_report_ODR()

            else:
                data = RealData(x, y, sx = sx, sy = sy)
                self.__fit_ODR(data, pi)
                self.__set_param_values_ODR()
                self.__set_report_ODR()

        params = self.get_params()
        keys = list(params.keys())
            
        for i in range(len(keys)):
            self.fillParamsTable.emit(keys[i], params[keys[i]][0], params[keys[i]][1])

        self.writeInfos.emit(self.report_fit)

    def __fit_ODR(self, data, pi):
        def f(a, x):
            param = Parameters()
            for i in range(len(a)):
                param.add(self.model.param_names[i], value=a[i])
            return self.model.eval(x=x, params=param)
        model = SciPyModel(f)
        myodr = ODR(data, model, beta0 = pi)
        self.result = myodr.run()
        

    def __fit_lm(self, x, y, sy, pi):
        params = Parameters()
        for i in range(len(self.coef)):
            params.add(self.coef[i], pi[i])
        self.result = self.model.fit(data = y, x = x, weights = 1/sy, params = params, scale_covar=False)
    
    def __fit_lm_wy(self, x, y, pi):
        params = Parameters()
        for i in range(len(self.coef)):
            params.add(self.coef[i], pi[i])
        self.result = self.model.fit(data = y, x = x, params = params, scale_covar=False)
        
    def get_params(self):
        ''' Return a dict with parameters as keys and returns a list with [value, uncertainty]. '''
        return self.dict
        
    def __set_param_values_lm(self):
        self.dict.clear()
        self.params = Parameters()
        for i in range(len(self.coef)):
            self.params.add(self.coef[i], self.result.values[self.coef[i]])
            self.dict.update({self.coef[i]: [self.result.values[self.coef[i]], np.sqrt(self.result.covar[i, i])]})

    def __set_param_values_ODR(self):
        self.dict.clear()
        self.params = Parameters()
        for i in range(len(self.coef)):
            self.params.add(self.coef[i], self.result.beta[i])
            self.dict.update({self.coef[i]: [self.result.beta[i], np.sqrt(self.result.cov_beta[i, i])]})

    def __set_report_lm(self):
        self.report_fit = ""
        self.report_fit += "\nAjuste: y = %s\n"%self.exp_model
        self.report_fit += "\nNGL  = %d"%(len(self.data["x"]) - len(self.coef))
        self.report_fit += "\nChi² = %f"%self.result.chisqr
        self.report_fit += "\nMatriz de covariância:\n\n" + str(self.result.covar) + "\n"
        lista           = list(self.params.keys())
        matriz_corr     = np.zeros((len(self.result.covar), len(self.result.covar)))
        z = len(matriz_corr)
        for i in range(z):
            for j in range(z):
                matriz_corr[i, j] = self.result.covar[i, j]/(self.dict[lista[i]][1]*self.dict[lista[j]][1])
        matriz_corr = matriz_corr.round(3)
        self.report_fit += "\nMatriz de correlação:\n\n" + str(matriz_corr) + "\n\n"
        self.isvalid     = True
    
    def __set_report_lm_special(self):
        ngl             = len(self.data["x"]) - len(self.coef)
        self.report_fit = ""
        self.report_fit += "\nAjuste: y = %s\n"%self.exp_model
        self.report_fit += "\nNGL  = %d"%(ngl)
        self.report_fit += "\nSomatória dos resíduos absolutos ao quadrado = %f\n"%self.result.chisqr
        self.report_fit += "Incerteza considerada = %f\n"%(np.sqrt(self.result.chisqr/ngl))
        self.report_fit += "\nMatriz de covariância:\n\n" + str(self.result.covar) + "\n"
        lista           = list(self.params.keys())
        matriz_corr     = np.zeros((len(self.result.covar), len(self.result.covar)))
        z = len(matriz_corr)
        for i in range(z):
            for j in range(z):
                matriz_corr[i, j] = self.result.covar[i, j]/(self.dict[lista[i]][1]*self.dict[lista[j]][1])
        matriz_corr = matriz_corr.round(3)
        self.report_fit += "\nMatriz de correlação:\n\n" + str(matriz_corr) + "\n\n"
        self.isvalid     = True

    def __set_report_ODR(self):
        self.report_fit = ""
        self.report_fit += "\nAjuste: y = %s\n"%self.exp_model
        self.report_fit += "\nNGL  = %d"%(len(self.data["x"]) - len(self.coef))
        self.report_fit += "\nChi² = %f"%self.result.sum_square
        self.report_fit += "\nMatriz de covariância:\n\n" + str(self.result.cov_beta) + "\n"
        lista           =list(self.params.keys())
        matriz_corr     = np.zeros((len(self.result.cov_beta), len(self.result.cov_beta)))
        z = len(matriz_corr)
        for i in range(z):
            for j in range(z):
                matriz_corr[i, j] = self.result.cov_beta[i, j]/(self.dict[lista[i]][1]*self.dict[lista[j]][1])
        matriz_corr = matriz_corr.round(3)
        self.report_fit += "\nMatriz de correlação:\n\n" + str(matriz_corr) + "\n\n"
        self.isvalid     = True
        
    def get_coefficients(self):
        ''' Return coefficients names. '''
        return self.coef 
    
    def get_data(self, *args):
        ''' Return data arrays based on mode attribute. '''
        # if self.mode == 0:
        #     return self.data["x"].to_numpy(), self.data["y"].to_numpy()
        # elif self.mode == 1:
        #     return self.data["x"].to_numpy(), self.data["y"].to_numpy(), self.data["sy"].to_numpy()
        # return self.data["x"].to_numpy(), self.data["y"].to_numpy(), self.data["sy"].to_numpy(), self.data["sx"].to_numpy()
        return self.x, self.y, self.sy, self.sx
        
    def get_predict(self, x_min = None, y_min = None):
        ''' Return the model prediction. '''
        if x_min is None:
            x_min = self.data['x'].min()
        if y_min is None:
            x_max = self.data['x'].max()
        x_plot = np.linspace(x_min, x_max, 10*len(self.data['x']))
        return x_plot, self.model.eval(x = x_plot, params = self.params)
    
    def get_residuals(self):
        ''' Return residuals from adjust. '''
        return self.y - self.model.eval(x = self.x)

    def reset(self):
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
        self.writeInfos.emit('')
        
        
