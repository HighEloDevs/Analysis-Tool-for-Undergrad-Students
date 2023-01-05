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

from PyQt5.QtCore import QObject, pyqtSlot, QUrl
import os


class GlobalManager(QObject):
    def __init__(self) -> None:
        super().__init__()
        self.atus_dir = os.path.join(os.path.expanduser("~/Documents"), "ATUS")
        self.last_folder = self.atus_dir

        # Checking if the ATUS's directory exists
        if not os.path.exists(self.atus_dir):
            try:
                os.mkdir(self.atus_dir)
            except FileExistsError:
                print("Cannot create ATUS's directory")
                self.atus_dir = os.path.expanduser(r"~\Desktop")

    @pyqtSlot(str)
    def setLastFolder(self, path):
        """Set last folder opened by user"""
        path = QUrl(path).toLocalFile()

        if os.path.isfile(path):
            self.last_folder = os.path.split(path)[0]
        else:
            self.last_folder = path

    @pyqtSlot(result=QUrl)
    def getLastFolder(self):
        """Get last folder opened by user"""
        return QUrl.fromLocalFile(self.last_folder)

    @pyqtSlot(result=QUrl)
    def getAtusDir(self):
        """Get ATUS's directory"""
        return QUrl.fromLocalFile(self.atus_dir)
