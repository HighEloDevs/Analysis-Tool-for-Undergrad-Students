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
import pandas as pd
from io import StringIO
from scipy.odr import ODR, Model as SciPyModel, Data, RealData
from matplotlib_backend_qtquick.qt_compat import QtCore, QtGui
from lmfit.models import ExpressionModel
from lmfit import Parameters
from copy import deepcopy

class Model(QtCore.QObject):
    """Class used for fit
    """
    # Signals
    fillDataTable = QtCore.Signal(str, str, str, str, str, arguments=['x', 'y', 'sy', 'sx', 'filename'])
    fillParamsTable = QtCore.Signal(str, float, float, arguments=['param', 'value', 'uncertainty'])
    writeInfos = QtCore.Signal(str, arguments='expr')

    def __init__(self):
        super().__init__()
        self._data       = None
        self._data_json  = None
        self._eixos      = [["Eixo x"], ["Eixo y"], ["Título"]]
        self._exp_model  = ""
        self._model      = None
        self._report_fit = ""
        self._result     = None
        self._coef       = list()
        self._params     = Parameters()
        self._dict       = dict()
        self._dict2      = dict()
        self._p0         = None
        self._mode       = 0
        self._has_data   = False
        self._isvalid    = False
        self._has_sx     = True
        self._has_sy     = True
        
    def __str__(self):
        return self._report_fit
        
    @QtCore.Slot(QtCore.QJsonValue)
    def loadDataTable(self, data = None):
        """Getting data from table"""
        df = pd.DataFrame.from_records(data)
        df.columns = ['x', 'y', 'sy', 'sx', 'bool']

        # Removing not chosen rows
        df = df[df['bool'] == 1]

        # Dropping some useless columns
        df = df.replace('', '0')
        if df[df['sx'] != '0'].empty: del df['sx']
        if df[df['sy'] != '0'].empty: del df['sy']
        del df['bool']
        self._mode   = len(df.columns) - 2
        self._has_sx = True
        self._has_sy = True

        # Naming columns
        if self._mode == 0:
            self._data_json    = deepcopy(df)
            self._has_sy       = False
            self._has_sx       = False
            df["sy"]           = 1
            df["sx"]           = 1
        elif self._mode == 1:
            self._data_json    = deepcopy(df)
            self._has_sx       = False
            df["sx"]           = 1
        else:
            self._data_json    = deepcopy(df)

        df.columns = ['x', 'y', 'sy', 'sx']

        # Turn everything into number (str -> number)
        df = df.astype(float)

        self._data     = deepcopy(df)
        self._has_data = True

    @QtCore.Slot()
    def loadDataClipboard(self):
        # Instantiating clipboard
        clipboard = QtGui.QGuiApplication.clipboard()
        clipboardText = clipboard.mimeData().text()
        try:
            # Creating a dataframe from the string
            df = pd.read_csv(StringIO(clipboardText), sep = '\t', header = None, dtype = str).dropna()
            # Replacing all commas for dots
            for i in df.columns:
                df[i] = [x.replace(',', '.') for x in df[i]]
                df[i] = df[i].astype(str)
            self.load_data(df=df)
        except Exception:
            print(Exception)
                
    @QtCore.Slot(str)
    def load_data(self, data_path='', df=None):
        """ Loads the data from a given path or from a given dataframe """

        # Name of the loaded file
        fileName = 'Dados Carregados do Projeto'

        # If no dataframe passed, loading data from the given path
        if df is None:
            # Loading from .csv or (.txt and .tsv)
            data_path = QtCore.QUrl(data_path).toLocalFile()
            if data_path[-3:] == "csv":
                df = pd.read_csv(data_path, sep=',', header=None, dtype = str).dropna()
            else:
                df = pd.read_csv(data_path, sep='\t', header=None, dtype = str).dropna()
            # Getting file name
            fileName = data_path.split('/')[-1]
            
        # Saving the dataframe in the class
        self._data_json = deepcopy(df)

        # Applying some filters over the df
        for i in df.columns:
            # Replacing comma for dots
            df[i]              = [x.replace(',', '.') for x in df[i]]
            self._data_json[i] = [x.replace(',', '.') for x in self._data_json[i]]
            # df                 = df.replace('', '0')
            # Converting everything to float
            df[i]              = df[i].astype(float)

        # Getting mode:
        # mode = 2 -> no uncertainties
        # mode = 1 -> no uncertainty on x
        # mode = 0 -> both variables has uncertainties
        self._mode   = len(df.columns) - 2
        self._has_sx = True
        self._has_sy = True

        # Naming columns
        if self._mode == 0:
            self._has_sy = False
            self._has_sx = False
            self._data_json.columns = ['x', 'y']
            df["sy"]     = 1
            df["sx"]     = 1
        elif self._mode == 1:
            self._has_sx = False
            self._data_json.columns = ['x', 'y', 'sy']
            df["sx"]     = 1
        else:
            self._data_json.columns = ['x', 'y', 'sy', 'sx']

        df.columns     = ['x', 'y', 'sy', 'sx']
        self._data     = deepcopy(df)
        self._has_data = True
        
        if self._has_sx and self._has_sy:
            for i in range(len(self._data["x"])):
                self.fillDataTable.emit(self._data_json["x"][i], self._data_json["y"][i], self._data_json["sy"][i], self._data_json["sx"][i], fileName)
        elif self._has_sx:
            for i in range(len(self._data["x"])):
                self.fillDataTable.emit(self._data_json["x"][i], self._data_json["y"][i], str(0), self._data_json["sx"][i], fileName)
        elif self._has_sy:
            for i in range(len(self._data["x"])):
                self.fillDataTable.emit(self._data_json["x"][i], self._data_json["y"][i], self._data_json["sy"][i], str(0), fileName)
        else:
            for i in range(len(self._data["x"])):
                self.fillDataTable.emit(self._data_json["x"][i], self._data_json["y"][i], str(0), str(0), fileName)

    def set_x_axis(self, name = ""):
        """ Set new x label to the graph. """
        self._eixos[0] = [name]
    
    def set_y_axis(self, name = ""):
        """ Set new y label to the graph. """
        self._eixos[1] = [name]

    def set_title(self, name = ""):
        """ Set new title to the graph. """
        self._eixos[2] = [name]

    def set_p0(self, p0):
        self._p0 = p0
        
    def set_expression(self, exp = ""):
        """ Set new expression to model. """
        self._exp_model = exp
        
    def fit(self, **kargs):

        wsx = kargs.pop("wsx", True)
        wsy = kargs.pop("wsy", True)

        # Getting Model
        try:
            self._model = ExpressionModel(self._exp_model)
        except ValueError:
            self._model = ExpressionModel(self._exp_model + " + 0*x")

        # Getting coefficients
        self._coef = [i for i in self._model.param_names]
        
        # If there's no p0, everything is set to 1.0
        pi = list()   # Inital values

        if self._p0 is None:
            for i in range(len(self._model.param_names)):
                pi.append(1.0)
        else:
            for i in range(len(self._model.param_names)):
                try:
                    pi.append(float(self._p0[i]))
                except:
                    pi.append(1.0)

        # Data
        x, y, sy, sx = self.data

        data = None
        if self._mode == 0:
            self.__fit_lm_wy(x, y, pi)
            self.__set_param_values_lm()
            self.__set_report_lm_special()
            
        elif self._mode == 1:
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

        self.writeInfos.emit(self._report_fit)

    def __fit_ODR(self, data, pi):
        def f(a, x):
            param = Parameters()
            for i in range(len(a)):
                param.add(self._model.param_names[i], value=a[i])
            return self._model.eval(x=x, params=param)
        model = SciPyModel(f)
        myodr = ODR(data, model, beta0 = pi)
        self._result = myodr.run()
        

    def __fit_lm(self, x, y, sy, pi):
        params = Parameters()
        for i in range(len(self._coef)):
            params.add(self._coef[i], pi[i])
        self._result = self._model.fit(data = y, x = x, weights = 1/sy, params = params, scale_covar=False)
    
    def __fit_lm_wy(self, x, y, pi):
        params = Parameters()
        for i in range(len(self._coef)):
            params.add(self._coef[i], pi[i])
        self._result = self._model.fit(data = y, x = x, params = params, scale_covar=False)
        
    def get_params(self):
        ''' Retorna um dicionário onde as keys são os parâmetros e que retornam uma lista com [valor, incerteza]. '''
        return self._dict
        
    def __set_param_values_lm(self):
        self._dict.clear()
        self._params = Parameters()
        ngl          = len(self._data["x"]) - len(self._coef)
        inc_cons     = np.sqrt(self._result.chisqr/ngl)
        # inc_cons_q   = inc_cons**2
        for i in range(len(self._coef)):
            self._params.add(self._coef[i], self._result.values[self._coef[i]])
            self._dict.update({self._coef[i]: [self._result.values[self._coef[i]], np.sqrt(self._result.covar[i, i])*inc_cons]})
            self._dict2.update({self._coef[i]: [self._result.values[self._coef[i]], np.sqrt(self._result.covar[i, i])]})

    def __set_param_values_ODR(self):
        self._dict.clear()
        self._params = Parameters()
        for i in range(len(self._coef)):
            self._params.add(self._coef[i], self._result.beta[i])
            self._dict.update({self._coef[i]: [self._result.beta[i], np.sqrt(self._result.cov_beta[i, i])]})

    def __set_report_lm(self):
        self._report_fit  = ""
        self._report_fit += "\nAjuste: y = %s\n"%self._exp_model
        self._report_fit += "\nNGL  = %d"%(len(self._data["x"]) - len(self._coef))
        self._report_fit += "\nChi² = %f"%self._result.chisqr
        self._report_fit += "\nMatriz de covariância:\n\n" + str(self._result.covar) + "\n"
        lista             = list(self._params.keys())
        matriz_corr       = np.zeros((len(self._result.covar), len(self._result.covar)))
        z                 = range(len(matriz_corr))
        for i in z:
            for j in z:
                matriz_corr[i, j] = self._result.covar[i, j]/(self._dict[lista[i]][1]*self._dict[lista[j]][1])
        matriz_corr       = matriz_corr.round(3)
        self._report_fit += "\nMatriz de correlação:\n\n" + str(matriz_corr) + "\n\n"
        self._isvalid     = True
    
    def __set_report_lm_special(self):
        ngl               = len(self._data["x"]) - len(self._coef)
        inc_considerada   = np.sqrt(self._result.chisqr/ngl)
        inc_considerada_q = inc_considerada**2
        self._report_fit  = ""
        self._report_fit += "\nAjuste: y = %s\n"%self._exp_model
        self._report_fit += "\nNGL  = %d"%(ngl)
        self._report_fit += "\nSomatória dos resíduos absolutos ao quadrado = %f\n"%self._result.chisqr
        self._report_fit += "Incerteza considerada = %f\n"%inc_considerada
        self._report_fit += "\nMatriz de covariância:\n\n" + str(self._result.covar*inc_considerada_q) + "\n"
        lista             = list(self._params.keys())
        matriz_corr       = np.zeros((len(self._result.covar), len(self._result.covar)))
        z                 = range(len(matriz_corr))
        for i in z:
            for j in z:
                matriz_corr[i, j] = self._result.covar[i, j]/(self._dict2[lista[i]][1]*self._dict2[lista[j]][1])
        matriz_corr       = matriz_corr.round(3)
        self._report_fit += "\nMatriz de correlação:\n\n" + str(matriz_corr) + "\n\n"
        self._isvalid     = True

    def __set_report_ODR(self):
        self._report_fit  = ""
        self._report_fit += "\nAjuste: y = %s\n"%self._exp_model
        self._report_fit += "\nNGL  = %d"%(len(self._data["x"]) - len(self._coef))
        self._report_fit += "\nChi² = %f"%self._result.sum_square
        self._report_fit += "\nMatriz de covariância:\n\n" + str(self._result.cov_beta) + "\n"
        lista             = list(self._params.keys())
        matriz_corr       = np.zeros((len(self._result.cov_beta), len(self._result.cov_beta)))
        z                 = range(len(matriz_corr))
        for i in z:
            for j in z:
                matriz_corr[i, j] = self._result.cov_beta[i, j]/(self._dict[lista[i]][1]*self._dict[lista[j]][1])
        matriz_corr       = matriz_corr.round(3)
        self._report_fit += "\nMatriz de correlação:\n\n" + str(matriz_corr) + "\n\n"
        self._isvalid     = True
        
    @property
    def coefficients(self):
        ''' Retorna uma lista com os nomes dos coeficientes. '''
        return self._coef 
    
    @property
    def data(self, *args):
        ''' Retorna x, y, sx e sy. '''
        return self._data["x"], self._data["y"], self._data["sy"], self._data["sx"]
        
    @property
    def residuo(self):
        ''' Retorna os valores de y_i - f(x_i). '''
        return self._data["y"] - self._model.eval(x = self._data["x"])

    def get_predict(self, x_min = None, x_max = None):
        ''' Retorna a previsão do modelo. '''
        if x_min is None:
            x_min = self._data['x'].min()
        if x_max is None:
            x_max = self._data['x'].max()
        x_plot = np.linspace(x_min, x_max, 10*len(self._data['x']))
        return x_plot, self._model.eval(x = x_plot, params = self._params)
    
    def reset(self):
        self._data       = None
        self._eixos      = [["Eixo x"], ["Eixo y"], ["Título"]]
        self._exp_model  = ""
        self._model      = None
        self._report_fit = ""
        self._result     = None
        self._coef       = list()
        self._params     = Parameters()
        self._dict       = dict()
        self._p0         = None
        self._mode       = 0
        self._has_data   = False
        self._isvalid    = False
        self._has_sx     = True
        self._has_sy     = True
        self.writeInfos.emit('')