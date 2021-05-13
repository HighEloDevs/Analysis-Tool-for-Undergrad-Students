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

class MessageHandler(QtCore.QObject):
    '''Class that sends all messages (warning, errors, fatal errors) from the backend to frontend'''

    # Signals to the frontend
    # showMessage() shows a snackbar with the message and respective color to the type
    # Types -> warn, error or success
    showMessage = QtCore.Signal(str, str, arguments=['message', 'type'])

    def __init__(self) -> None:
        super().__init__()

    def raiseWarn(self, message=''):
        self.showMessage.emit(message, 'warn')

    def raiseError(self, message=''):
        self.showMessage.emit(message, 'error')

    def raiseSuccess(self, message=''):
        self.showMessage.emit(message, 'success')