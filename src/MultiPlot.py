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
import numpy as np
import platform
from PyQt5.QtCore import QObject, QJsonValue, QUrl, pyqtSignal, pyqtSlot
from .Model_multiplot import MultiModel

class Multiplot(QObject):
    """Backend for multiplot page"""

    setData          = pyqtSignal(QJsonValue, arguments='data')
    removeRow        = pyqtSignal(int, arguments='row')
    fillPageSignal   = pyqtSignal(QJsonValue, arguments='props')
    addRow           = pyqtSignal(QJsonValue, arguments='rowData')

    def __init__(self, displayBridge, messageHandler):
        super().__init__()
        self.path          = ''
        self.displayBridge = displayBridge
        self.msg           = messageHandler
        self.Multi_Model   = None
        self.grid          = 0.
        self.xmin          = 0.
        self.xmax          = 0.
        self.xdiv          = 0.
        self.ymin          = 0.
        self.ymax          = 0.
        self.ydiv          = 0.
        self.logy          = 0.
        self.logx          = 0.
        self.title         = ''
        self.xaxis         = ''
        self.yaxis         = ''

        self.defaultProps  = {
            'id': '',
            'rowsData': [],
            'canvasProps': {
                'title': '',
                'xaxis': '',
                'yaxis': '',
                'xmin': '',
                'xmax': '',
                'xdiv': '',
                'ymin': '',
                'ymax': '',
                'ydiv': '',
                'logx': False,
                'logy': False,
                'grid': False,
            }
        }

    def fillPage(self, props):
        props = QJsonValue.fromVariant(props)
        self.fillPageSignal.emit(props)

    @pyqtSlot()
    def new(self):
        # Reseting path
        self.path = ''

        # Reseting frontend
        self.displayBridge.clearAxis()
        self.displayBridge.switchAxes(True)
        self.fillPage(self.defaultProps)

    @pyqtSlot(str)
    def load(self, path):
        curveStyles = {
            '-': 0,
            '--': 1,
            '-.':2
        }
        # Reseting frontend
        self.new()

        # Setting path
        self.path = QUrl(path).toLocalFile()

        # Getting props
        with open(self.path, encoding='utf-8') as file:
            try:
                props = json.load(file)
            except:
                self.msg.raiseError("O arquivo carregado é incompatível.")

        if "key" in props:
            # Loading data from the table
            key = props["key"].split('-')
            if key[0] != "2":
                self.msg.raiseWarn("O carregamento de arquivos antigos está limitado à uma versão anterior.")
                return 0
            if key[-1] != 'multiplot':
                self.msg.raiseError("O arquivo carregado é incompatível ou está desatualizado.")
                return 0
        else:
            self.msg.raiseError("O arquivo carregado é incompatível ou está desatualizado.")
            return 0

        for row, rowData in enumerate(props['rowsData'], start=0):
            prop = QJsonValue.fromVariant({
                'row': row,
                'data': rowData['df'],
                'params': rowData['params'],
                'fileName': 'Carregado do projeto',
                'projectName': rowData['label'],
                'expr': rowData['expr'],
                'p0': rowData['p0'],
                'symbolColor': rowData["markerColor"],
                'curve': curveStyles[rowData['curve']]
            })
            self.addRow.emit(prop)

        # Removing rowData from props
        del props['rowsData']

        # Filling page
        self.fillPageSignal.emit(QJsonValue.fromVariant(props))

    @pyqtSlot(QJsonValue, result=int)
    def save(self, props):
        # If there's no path for saving, saveAs()
        if self.path == '':
            return 1

        # Getting properties
        props = props.toVariant()

        if platform.system() == "Linux":
            if self.path[-5:] == ".json":
                with open(self.path, 'w', encoding='utf-8') as file:
                    json.dump(props, file, ensure_ascii=False, indent=4)
            else: 
                with open(self.path + ".json", 'w', encoding='utf-8') as file:
                    json.dump(props, file, ensure_ascii=False, indent=4)
        else:
            with open(self.path, 'w', encoding='utf-8') as file:
                json.dump(props, file, ensure_ascii=False, indent=4)

        return 0
    
    @pyqtSlot(str, QJsonValue)
    def saveAs(self, path, props):
        # Getting path
        self.path = QUrl(path).toLocalFile()

        # Getting properties
        props = props.toVariant()

        if platform.system() == "Linux":
            if self.path[-5:] == ".json":
                with open(self.path, 'w', encoding='utf-8') as file:
                    json.dump(props, file, ensure_ascii=False, indent=4)
            else: 
                with open(self.path + ".json", 'w', encoding='utf-8') as file:
                    json.dump(props, file, ensure_ascii=False, indent=4)
        else:
            with open(self.path, 'w', encoding='utf-8') as file:
                json.dump(props, file, ensure_ascii=False, indent=4)

    @pyqtSlot(str, int)
    def loadData(self, fileUrl, row):
        curveStyles = {
            '-': 0,
            '--': 1,
            '-.':2
        }
        # Opening json file
        with open(QUrl(fileUrl).toLocalFile(), encoding='utf-8') as file:
            data = json.load(file)

        try:
            # Getting function to fit
            # Anti-dummies system
            expr = data["fitProps"]['expr']
            if expr != '':
                expr = expr.replace('^', '**')
                expr = expr.replace('arctan', 'atan')
                expr = expr.replace('arcsin', 'asin')
                expr = expr.replace('arccos', 'acos')
                expr = expr.replace('sen', 'sin')
                
            self.setData.emit(QJsonValue.fromVariant({
                'row': row,
                'data': data['data'],
                'params': data["fitProps"]['parameters'],
                'fileName': QUrl(fileUrl).toLocalFile().split('/')[-1],
                'projectName': data['id'],
                'expr': expr,
                'p0': data["fitProps"]['p0'],
                'symbolColor': data["dataProps"]["marker_color"],
                'curve': curveStyles[data["dataProps"]['curve_style']]
            }))
        except:
            self.msg.raiseError("Erro ao carregar arquivo. Verificar arquivo de entrada.")
            self.removeRow.emit(row)

    @pyqtSlot(QJsonValue)
    def getData(self, data):
        '''Get data from frontend and make a plot'''

        def mk_float(s):
            '''Make a float from the string'''
            s = s.strip()
            return np.float64(s) if s else 0
        def mk_int(s):
            '''Make a float from the string'''
            s = s.strip()
            return np.int64(s) if s else 0

        dados              = data.toVariant()
        graph_options      = dados['canvasProps']
        projetos           = dados['rowsData']
        self.Multi_Model   = MultiModel(graph_options, projetos)
        self.grid          = graph_options['grid']
        self.logx          = graph_options['logx']
        self.logy          = graph_options['logy']

        self.xmin          = mk_float(graph_options['xmin'])
        self.xmax          = mk_float(graph_options['xmax'])
        self.xdiv          = mk_int(graph_options['xdiv'])
        self.ymin          = mk_float(graph_options['ymin'])
        self.ymax          = mk_float(graph_options['ymax'])
        self.ydiv          = mk_int(graph_options['ydiv'])
        self.title         = graph_options['title']
        self.xaxis         = graph_options['xaxis']
        self.yaxis         = graph_options['yaxis']
        self.Plot()

    def Plot(self):
        self.displayBridge.figure.tight_layout(rect=[0.015, 0.045, 0.985, 0.985])
        self.displayBridge.clearAxis()
        self.displayBridge.switchAxes(hideAxes2 = True)
        self.displayBridge.grid = self.grid
        self.displayBridge.setAxesPropsWithoutAxes2(self.xmin, self.xmax, self.xdiv,
         self.ymin, self.ymax, self.ydiv, self.grid, self.logx, self.logy)

        for i in range(len(self.Multi_Model.models)):
            if self.Multi_Model.arquivos[i]['marker'] == True:
                self.Plot_sx_sy(self.Multi_Model.dfs[i], self.Multi_Model.arquivos[i])
        left, right = self.displayBridge.axes1.get_xlim()
        self.displayBridge.axes1.set_xlim(left = left, right = right)
        self.displayBridge.axes1.set_xlim(left = left, right = right)
        lines = list()
        for i in range(len(self.Multi_Model.models)):
            if self.Multi_Model.arquivos[i]['func'] == True and self.Multi_Model.models[i] != 0.:
                self.Func_plot(self.Multi_Model.arquivos[i], self.Multi_Model.models[i], self.Multi_Model.parameters[i], self.Multi_Model.indVars[i], left, right, lines)
        self.displayBridge.axes1.set_title(self.title)
        self.displayBridge.axes1.set(xlabel = self.xaxis, ylabel = self.yaxis)
        handles, labels = self.displayBridge.axes1.get_legend_handles_labels()

        if len(handles) > 1:
            labels.reverse()
            handles.reverse()
            by_label = dict(zip(labels, handles))
            self.displayBridge.axes1.legend(by_label.values(), by_label.keys())
        elif len(handles) == 1:
            by_label = dict(zip(labels, handles))
            self.displayBridge.axes1.legend(by_label.values(), by_label.keys())
        self.displayBridge.canvas.draw_idle()
        

    def Plot_sx_sy(self, df, options):
        if options['label'] != '':
            self.displayBridge.axes1.errorbar(df['x'], df['y'], yerr=df['sy'], xerr = df['sx'],
            ecolor = options['markerColor'], capsize = 0, elinewidth = 1, ms = 3, marker = '.', color = options['markerColor'], ls = 'none', label = options['label'])
        else:
            self.displayBridge.axes1.errorbar(df['x'], df['y'], yerr=df['sy'], xerr = df['sx'],
            ecolor = options['markerColor'], capsize = 0, elinewidth = 1, ms = 3, marker = '.', color = options['markerColor'], ls = 'none')
    
    def Plot_sy(self, df, options): # Depreciada
        if options['label'] != '':
            self.displayBridge.axes1.errorbar(df['x'], df['y'], yerr=df['sy'],
            ecolor = options['markerColor'], capsize = 0, elinewidth = 1, ms = 3, marker = '.', color = options['markerColor'], ls = 'none', label = options['label'])
        else:
            self.displayBridge.axes1.errorbar(df['x'], df['y'], yerr=df['sy'],
            ecolor = options['markerColor'], capsize = 0, elinewidth = 1, ms = 3, marker = '.', color = options['markerColor'], ls = 'none')
    
    def Plot_op(self, df, options): # Depreciada
        if options['label'] != '':
            self.displayBridge.axes1.errorbar(df['x'], df['y'],
            ecolor = options['markerColor'], capsize = 0, elinewidth = 1, ms = 3, marker = '.', color = options['markerColor'], ls = 'none', label = options['label'])
        else:
            self.displayBridge.axes1.errorbar(df['x'], df['y'],
            ecolor = options['markerColor'], capsize = 0, elinewidth = 1, ms = 3, marker = '.', color = options['markerColor'], ls = 'none')
    
    def Func_plot(self, options, model, params, var, left, right, lines):
        x_plot = None
        if self.logx:
            x_plot = np.logspace(np.np.log10(left), np.np.log10(right), int(self.displayBridge.axes1.figure.get_size_inches()[0]*self.displayBridge.axes1.figure.dpi*1.75))
        else:
            x_plot = np.linspace(left, right, int(self.displayBridge.axes1.figure.get_size_inches()[0]*self.displayBridge.axes1.figure.dpi*1.75)) 
        y_plot = eval("model.eval(%s = x_plot, params = params)"%var, None,
         {'x_plot': x_plot, 'model': model, 'params': params})
        if options['label'] != '':
            line_func, = self.displayBridge.axes1.plot(x_plot, y_plot, lw = 1.5, color = options['markerColor'], ls = options['curve'], label = options['label'])
            lines.append(line_func)
        else:
            line_func, = self.displayBridge.axes1.plot(x_plot, y_plot, lw = 1.5, color = options['markerColor'], ls = options['curve'])
            lines.append(line_func)
