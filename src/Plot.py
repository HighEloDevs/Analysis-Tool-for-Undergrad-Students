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

from matplotlib_backend_qtquick.qt_compat import QtGui, QtQml, QtCore
from src.Calculators import CalculatorCanvas, interpreter_calculator, Plot

class SinglePlot(QtCore.QObject):
    '''Class that controls the single-plot page'''

    # Signal to write infos
    writeInfos      = QtCore.Signal(str, arguments='expr')
    writeCalculator = QtCore.Signal(str, arguments='expr')
    emitData        = QtCore.Signal()

    def __init__(self, displayBridge, model):
        super().__init__()
        self.displayBridge = displayBridge
        self.model = model

        singlePlotData = {}

    @QtCore.Slot(QtCore.QJsonValue)
    def getProps(self, props):
        self.emitData.emit()
        props = props.toVariant()

        self.displayBridge.setSigma(props['sigmax'], props['sigmay'])

        # Setting up initial parameters
        p0_tmp = list()
        p0 = props['p0']
        if p0 != '':
            # Anti-dummies system
            p0 = p0.replace(';', ',')
            p0 = p0.replace('/', ',')
            for i in p0.split(','):
                p0_tmp.append(float(i))
            self.model.set_p0(p0_tmp)

        # Anti-dummies system 2
        expression = props['expr']
        expression = expression.replace('^', '**')
        expression = expression.replace('arctan', 'atan')
        expression = expression.replace('arcsin', 'asin')
        expression = expression.replace('arccos', 'acos')
        expression = expression.replace('sen', 'sin')
        
        # Setting expression
        if self.model._exp_model != expression:
            self.model.set_expression(expression)

        curveStyles = {
            'Sólido':'-',
            'Tracejado':'--',
            'Ponto-Tracejado':'-.'
            }
        symbols = {
            'Círculo':'o',
            'Triângulo':'^',
            'Quadrado':'s',
            'Pentagono':'p',
            'Octagono':'8',
            'Cruz':'P',
            'Estrela':'*',
            'Diamante':'d',
            'Produto':'X'
            }

        # Setting style of the plot 
        self.model.set_title(props['titulo'])
        self.model.set_x_axis(props['eixox'])
        self.model.set_y_axis(props['eixoy'])
        self.displayBridge.setStyle( props['logx'],
                                props['logy'],
                                props['markerColor'],
                                props['markerSize'],
                                symbols[props['marker']],
                                props['curveColor'],
                                props['curveThickness'],
                                curveStyles[props['curveType']],
                                props['legend'],
                                self.model._exp_model.replace('**', '^'))

        # Making plot
        self.displayBridge.Plot(self.model, props['residuos'], props['grade'],
         props['xmin'], props['xmax'], props['xdiv'],
         props['ymin'], props['ymax'], props['ydiv'],
         props['resMin'], props['resMax'])

    @QtCore.Slot(str)
    def loadData(self, file_path):
        """Gets the path to data's file and fills the data's table"""
        self.model.load_data(QtCore.QUrl(file_path).toLocalFile())

    @QtCore.Slot(str)
    def savePlot(self, save_path):
        """Gets the path from input and save the actual plot"""
        self.displayBridge.figure.savefig(QtCore.QUrl(save_path).toLocalFile(), dpi = 400)

    @QtCore.Slot(str, str, str, str, str, str)
    def calculator(self, function, opt1, nc, ngl, mean, std):
        functionDict = {
            'Chi²':0,
            'Chi² Reduzido':1,
            'Gaussiana':2,
            'Student':3
        }
        methodDict = {
            'Simétrico de Dois Lados':0,
            'Apenas Limite Inferior':1,
            'Apenas Limite Superior':2
        }   
        try:
            nc = nc.replace(',', '.')
            nc = float(nc)
        except:
            pass
        try:
            ngl = ngl.replace(',', '.')
            ngl = float(ngl)
        except:
            pass
        try:
            mean = mean.replace(',', '.')
            mean = float(mean)
        except:
            pass
        try:
            std = std.replace(',', '.')
            std = float(std)
        except:
            pass

        s, x, y, x_area, y_area = interpreter_calculator(functionDict[function], methodDict[opt1], nc, ngl, mean, std)
        Plot(self.displayBridge, x, y, x_area, y_area)
        self.writeCalculator.emit(s)