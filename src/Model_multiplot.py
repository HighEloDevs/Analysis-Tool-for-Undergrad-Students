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

# from matplotlib_backend_qtquick.qt_compat import QtCore
from PyQt5.QtCore import QObject
from lmfit.models import ExpressionModel
from lmfit import Parameters

class MultiModel(QObject):
    def __init__(self, options: dict, arquivos: list):
        super().__init__()
        self.options    = options
        self.arquivos   = arquivos
        self.dfs        = [pd.DataFrame.from_records(arquivo['df']).astype(float) for arquivo in self.arquivos]
        for i in range(len(self.dfs)):
            self.dfs[i].columns = ['x', 'y', 'sy', 'sx', 'bool']
            self.dfs[i]         = self.dfs[i][self.dfs[i]['bool'] == 1]
            del self.dfs[i]["bool"]
        self.num_cols   = [len(df.columns) for df in self.dfs]
        self.models     = []
        self.parameters = []
        for arquivo in arquivos:
            if arquivo['expr'] != '' and len(arquivo['params']) > 0:
                self.models.append(ExpressionModel(arquivo['expr']))
                parametros = Parameters()
                for parametro in arquivo['params'].keys():
                    parametros.add(parametro, value = arquivo['params'][parametro])
                self.parameters.append(parametros)
            else:
                self.models.append(0)
                self.parameters.append(0)