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

# from matplotlib_backend_qtquick.qt_compat import QtCore
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot


class MessageHandler(QObject):
    """
    Class that sends all messages (warning, errors, fatal errors) from the backend to frontend
    """

    # Signals to the frontend
    # show_message() shows a snackbar with the message and respective color to the type
    # Types -> warn, error or success
    show_message = pyqtSignal(str, str, arguments=["message", "type"])

    def __init__(self) -> None:
        super().__init__()

    @pyqtSlot(str)
    def raise_warn(self, message=""):
        self.show_message.emit(message, "warn")

    @pyqtSlot(str)
    def raise_error(self, message=""):
        self.show_message.emit(message, "error")

    @pyqtSlot(str)
    def raise_success(self, message=""):
        self.show_message.emit(message, "success")
