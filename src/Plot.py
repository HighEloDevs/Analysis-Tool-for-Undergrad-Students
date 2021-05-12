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

from matplotlib_backend_qtquick.qt_compat import QtCore
from src.Calculators import interpreter_calculator, Plot

class SinglePlot(QtCore.QObject):
    '''Class that controls the single-plot page'''

    # Signal to write infos
    writeInfos      = QtCore.Signal(str, arguments='expr')
    writeCalculator = QtCore.Signal(str, arguments='expr')
    emitData        = QtCore.Signal()

    def __init__(self, canvas, model):
        super().__init__()
        self.canvas = canvas
        self.model = model

    @QtCore.Slot(QtCore.QJsonValue)
    def getPlotData(self, plotData):
        plotData =    plotData.toVariant()
        id =          plotData['id']
        canvasProps = plotData['canvasProps']
        dataProps =   plotData['dataProps']
        fitProps =    plotData['fitProps']
        data =        plotData['data']

        # Loading data from the table
        self.model.loadDataTable(data)

        # Getting function to fit
        # Anti-dummies system
        expr = fitProps['expr']
        expr = expr.replace('^', '**')
        expr = expr.replace('arctan', 'atan')
        expr = expr.replace('arcsin', 'asin')
        expr = expr.replace('arccos', 'acos')
        expr = expr.replace('sen', 'sin')

        # Setting expression
        if self.model._exp_model != expr:
            self.model.set_expression(expr)

        # Getting initial parameters
        if fitProps['p0'] != '':
            p0 = fitProps['p0']
            p0 = p0.replace(';', ',')
            p0 = p0.replace('/', ',')
            p0 = list(map(lambda x: float(x), p0.split(',')))
            self.model.set_p0(p0)

        # Setting style of the plot 
        self.canvas.setCanvasProps(canvasProps, expr)
        self.canvas.setDataProps(dataProps, fitProps)
        self.canvas.Plot(self.model)

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
        Plot(self.canvas, x, y, x_area, y_area)
        self.writeCalculator.emit(s)