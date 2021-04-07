# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 17:10:06 2021

@author: Leonardo Eiji Tamayose & Guilherme Ferrari Fortino 

MultiPlot Class

"""

import json
from PySide2 import QtCore
from PySide2.QtCore import Slot, Signal

class Multiplot(QtCore.QObject):
    """Backend for multiplot page"""

    setData = Signal(QtCore.QJsonValue, arguments='data')

    @Slot(str, int)
    def loadData(self, fileUrl, row):
        curveStyles = {
            '-': 0,
            '--': 1,
            '-.':2
        }
        # Opening json file
        with open(QtCore.QUrl(fileUrl).toLocalFile(), encoding='utf-8') as file:
            data = json.load(file)

        self.setData.emit(QtCore.QJsonValue.fromVariant({
            'row': row,
            'data': data['data'],
            'params': [],
            'fileName': QtCore.QUrl(fileUrl).toLocalFile().split('/')[-1],
            'projectName': data['projectName'],
            'expr': data['expr'],
            'p0': data['p0'],
            'symbolColor': data['symbol_color'],
            'curve': curveStyles[data['curve_style']]
        }))

    @Slot(QtCore.QJsonValue)
    def getData(self, data):
        print(data.toObject())
