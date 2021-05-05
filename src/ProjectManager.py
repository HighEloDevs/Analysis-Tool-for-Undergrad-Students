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

import json
import platform
import pandas as pd
from matplotlib_backend_qtquick.qt_compat import QtCore
from .MatPlotLib import DisplayBridge
from .Model import Model

class ProjectManager(QtCore.QObject):
    '''Manages the project and the options, saves the project using json'''

    # Some Signals
    saveAsSignal = QtCore.Signal()
    fillFuncPage = QtCore.Signal(str, str, int, int, arguments=['expr', 'pi', 'sx', 'sy'])
    fillPropPage = QtCore.Signal(str, str, int, str, int, int, int, int, str, int, str, str, int, str, str, str, str, str, str, str, str, str,
                                arguments=['title', 'xaxis', 'log_x', 'yaxis', 'log_y', 'residuals', 'grid', 'legend', 'symbol_color', 'symbol_size', 'symbol_style', 'curve_color', 'curve_thickness', 'curve_style', 'xMin', 'xMax', 'xDiv', 'yMin', 'yMax', 'yDiv', 'resmin', 'resmax'])
    fillDataTable = QtCore.Signal()
    fillParamsTable = QtCore.Signal()
    fillProjectName = QtCore.Signal(str, arguments=['projectName'])
    clearTableParams = QtCore.Signal()
    clearTableData = QtCore.Signal()
    

    def __init__(self, displayBridge, model):
        super().__init__()
        
        self.displayBridge = displayBridge
        self.model = model

        # Stores the actual path
        self.path = ''
        self.projectName = ''

        # Dict for the options
        self.opt = {
            'projectName' : '',
            'expr' : '',
            'p0' : '',
            'xaxis' : '',
            'yaxis' : '',
            'title' : '',
            'data' : None,
            'wsx' : True,
            'wsy' : True,
            'log_x' : 0,
            'log_y' : 0,
            'legend' : 0,
            'symbol_color' : '',
            'symbol_size' : 3,
            'symbol' : '',
            'curve_color' : '',
            'curve_thickness' : 2,
            'curve_style' : '',
            'grid' : 0,
            'xmin' : '',
            'xmax' : '',
            'xdiv' : '',
            'ymin' : '',
            'ymax' : '',
            'ydiv' : '',
            'resmin' : '',
            'resmax' : '',
            'residuals' : 0
        }   
        
    def __importOptions(self):
        '''Import all options from classes'''
        try:
            data = self.model._data_json.to_json(double_precision = 15)
        except:
            data = None

        p0 = ''
        try:
            for i in self.model._p0:
                p0 += '{},'.format(i)
            p0 = p0[:-1]
        except:
            pass

        self.opt = {
            'projectName' : self.projectName,
            'expr' : self.model._exp_model,
            'p0' : p0,
            'xaxis' : self.model._eixos[0][0],
            'yaxis' : self.model._eixos[1][0],
            'title' : self.model._eixos[2][0],
            'data' : data,
            'wsx' : self.displayBridge.sigma_x,
            'wsy' : self.displayBridge.sigma_y,
            'log_x' : self.displayBridge.log_x,
            'log_y' : self.displayBridge.log_y,
            'legend' : self.displayBridge.legend,
            'symbol_color' : self.displayBridge.symbol_color,
            'symbol_size' : self.displayBridge.symbol_size,
            'symbol' : self.displayBridge.symbol,
            'curve_color' : self.displayBridge.curve_color,
            'curve_thickness' : self.displayBridge.curve_thickness,
            'curve_style' : self.displayBridge.curve_style,
            'grid' : self.displayBridge.grid,
            'residuals' : self.displayBridge.residuals,
            'xmin' : self.displayBridge.xmin,
            'xmax' : self.displayBridge.xmax,
            'xdiv' : self.displayBridge.xdiv,
            'ymin' : self.displayBridge.ymin,
            'ymax' : self.displayBridge.ymax,
            'ydiv' : self.displayBridge.ydiv,
            'resmin' : self.displayBridge.resmin,
            'resmax' : self.displayBridge.resmax,
            'parameters': self.model._params.valuesdict()
        }

    def __clearOptions(self):
        '''Clear option's dictionary'''
        self.opt = {
            'projectName' : '',
            'expr' : '',
            'p0' : '',
            'xaxis' : '',
            'yaxis' : '',
            'title' : '',
            'data' : None,
            'wsx' : True,
            'wsy' : True,
            'log_x' : 0,
            'log_y' : 0,
            'legend' : 0,
            'symbol_color' : '',
            'symbol_size' : 3,
            'symbol' : '',
            'curve_color' : '',
            'curve_thickness' : 2,
            'curve_style' : '',
            'grid' : 0,
            'xmin' : '',
            'xmax' : '',
            'xdiv' : '',
            'ymin' : '',
            'ymax' : '',
            'ydiv' : '',
            'resmin' : '',
            'resmax' : '',
            'residuals' : 0
        }

    @QtCore.Slot()
    def save(self):
        """ Saves all options to a already loaded path """
        self.__importOptions()
        if self.path != '':
            # if platform.system() == "Linux":
            #     with open(self.path + ".json", 'w', encoding='utf-8') as file:
            #         json.dump(self.opt, file, ensure_ascii=False, indent=4)
            # else:
            with open(self.path, 'w', encoding='utf-8') as file:
                json.dump(self.opt, file, ensure_ascii=False, indent=4)
        else:
            self.saveAsSignal.emit()
        self.__clearOptions()

    @QtCore.Slot(str)
    def saveAs(self, path):
        """ Saves all options to a given path """
        self.__importOptions()
        self.path = QtCore.QUrl(path).toLocalFile()
        if platform.system() == "Linux":
            with open(self.path + ".json", 'w', encoding='utf-8') as file:
                json.dump(self.opt, file, ensure_ascii=False, indent=4)
        else:
            with open(self.path, 'w', encoding='utf-8') as file:
                json.dump(self.opt, file, ensure_ascii=False, indent=4)
        self.__clearOptions() 

    @QtCore.Slot(str)
    def loadProject(self, path):
        """ Opens a json file with the options and sets everything up """
        curveStyles = {
            '-':'Sólido',
            '--':'Tracejado',
            '-.':'Ponto-Tracejado'
            }
        symbols = {
            'o':'Círculo',
            '^':'Triângulo',
            's':'Quadrado',
            'p':'Pentagono',
            '8':'Octagono',
            'P':'Cruz',
            '*':'Estrela',
            'd':'Diamante',
            'X':'Produto'
            }

        # Reseting front-end
        self.newProject()

        # Saving path
        self.path = QtCore.QUrl(path).toLocalFile()
        
        # Loading and setting up options
        with open(self.path, encoding='utf-8') as file:
            options = json.load(file)
        
        self.model.set_expression(options['expr'])
        self.model.set_title(options['title'])
        self.model.set_x_axis(options['xaxis'])
        self.model.set_y_axis(options['yaxis'])
        self.model.set_p0(options['p0'].split(','))
        # print(options['p0'].split(','))
        self.clearTableData.emit()
        if options['data'] != None:
            self.model.load_data_json(pd.read_json(options['data'], dtype = str))
        self.displayBridge.setStyle(  
                    options['log_x'],
                    options['log_y'],
                    options['symbol_color'],
                    options['symbol_size'],
                    options['symbol'],
                    options['curve_color'],
                    options['curve_thickness'],
                    options['curve_style'],
                    options['legend'],
                    options['expr']
                    )
        self.displayBridge.setSigma(options['wsx'], options['wsy'])
        
        self.displayBridge.Plot(self.model, options['residuals'], options['grid'],
         options['xmin'], options['xmax'], options['xdiv'],
         options['ymin'], options['ymax'], options['ydiv'],
         options['resmin'],  options['resmax'])

        # Setting all options to frontend
        self.fillFuncPage.emit( options['expr'],
                                options['p0'],
                                options['wsx'],
                                options['wsy'])
                                
        self.fillPropPage.emit( options['title'],
                                options['xaxis'],
                                options['log_x'],
                                options['yaxis'],
                                options['log_y'],
                                options['residuals'],
                                options['grid'],
                                options['legend'],
                                options['symbol_color'],
                                options['symbol_size'],
                                symbols[options['symbol']],
                                options['curve_color'],
                                options['curve_thickness'],
                                curveStyles[options['curve_style']],
                                str(options['xmin']),
                                str(options['xmax']),
                                str(options['xdiv']),
                                str(options['ymin']),
                                str(options['ymax']),
                                str(options['ydiv']),
                                str(options['resmin']),
                                str(options['resmax']),
                                )

        self.fillProjectName.emit(options['projectName'])

    @QtCore.Slot()
    def newProject(self):
        self.fillFuncPage.emit( self.opt['expr'],
                                self.opt['p0'],
                                self.opt['wsx'],
                                self.opt['wsy'])
                                
        self.fillPropPage.emit( self.opt['title'],
                                self.opt['xaxis'],
                                self.opt['log_x'],
                                self.opt['yaxis'],
                                self.opt['log_y'],
                                self.opt['residuals'],
                                self.opt['grid'],
                                self.opt['legend'],
                                self.opt['symbol_color'],
                                self.opt['symbol_size'],
                                'Círculo',
                                self.opt['curve_color'],
                                self.opt['curve_thickness'],
                                'Sólido',
                                self.opt['xmin'],
                                self.opt['xmax'],
                                self.opt['xdiv'],
                                self.opt['ymin'],
                                self.opt['ymax'],
                                self.opt['ydiv'],
                                self.opt['resmin'],
                                self.opt['resmax']
                                )
        self.fillProjectName.emit(self.opt['projectName'])
        self.clearTableParams.emit()
        self.model.reset()
        self.displayBridge.reset()

    @QtCore.Slot(str)
    def setProjectName(self, projectName):
        self.projectName = projectName
