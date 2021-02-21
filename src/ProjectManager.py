# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

Class Project Manager

"""

import json
from PySide2 import QtCore
import pandas as pd
from .Model import Model
from .MatPlotLib import DisplayBridge

class ProjectManager(QtCore.QObject):
    '''Manages the project and the options, saves the project using json'''

    # Some Signals
    saveAsSignal = QtCore.Signal()

    def __init__(self, displayBridge, model):
        super().__init__()
        
        self.displayBridge = displayBridge
        self.model = model

        # Stores the actual path
        self.path = ''
        self.projectName = ''

        # Dict for the options
        self.opt = dict()
        
    def __importOptions(self):
        '''Import all options from classes'''
        try:
            data = self.model.data.to_json()
        except:
            data = None
        self.opt = {
            'projectName' : '',
            'expr' : self.model.exp_model,
            'p0' : self.model.p0,
            'xaxis' : self.model.eixos[0][0],
            'yaxis' : self.model.eixos[1][0],
            'title' : self.model.eixos[2][0],
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
            'residuals' : self.displayBridge.residuals
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
            'wsx' : '',
            'wsy' : '',
            'log_x' : '',
            'log_y' : '',
            'legend' : '',
            'symbol_color' : '',
            'symbol_size' : '',
            'symbol' : '',
            'curve_color' : '',
            'curve_thickness' : '',
            'curve_style' : '',
            'grid' : '',
            'residuals' : ''
        }

    @QtCore.Slot()
    def save(self):
        """ Saves all options to a already loaded path """
        self.__importOptions()
        if self.path != '':
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
        with open(self.path, 'w', encoding='utf-8') as file:
            json.dump(self.opt, file, ensure_ascii=False, indent=4)
        self.__clearOptions() 

    @QtCore.Slot(str)
    def loadProject(self, path):
        """ Opens a json file with the options and sets everything up """
        # Saving path
        self.path = QtCore.QUrl(path).toLocalFile()
        
        # Loading and setting up options
        with open(self.path) as file:
            options = json.load(file)
        
        self.model.set_expression(options['expr'])
        self.model.set_title(options['title'])
        self.model.set_x_axis(options['xaxis'])
        self.model.set_y_axis(options['yaxis'])
        self.model.load_data_json(pd.read_json(options['data']))
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
        self.displayBridge.Plot(self.model, options['residuals'], options['grid'])
    @QtCore.Slot()
    def newProject(self):
        print('new project')
