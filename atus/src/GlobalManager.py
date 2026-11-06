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

from PyQt5.QtCore import QObject, pyqtSlot, QUrl, QStandardPaths
import os


class GlobalManager(QObject):
    def __init__(self) -> None:
        super().__init__()

        # Get correct path for '~/Documents' in any OS and language
        docs_dir = QStandardPaths.writableLocation(QStandardPaths.DocumentsLocation) or os.path.expanduser("~")
        self.atus_dir = os.path.join(docs_dir, "ATUS")
        self.last_folder = self.atus_dir

        # legacy
        #self.atus_dir = os.path.join(os.path.expanduser("~/Documents"), "ATUS")
        #self.last_folder = self.atus_dir

        # Checking if the ATUS's directory exists
        if not os.path.exists(self.atus_dir):
            try:
                os.makedirs(self.atus_dir, exist_ok=True)
            except Exception:
                print("Cannot create ATUS's directory")
                #self.atus_dir = os.path.expanduser(r"~\Desktop")
                self.atus_dir = QStandardPaths.writableLocation(QStandardPaths.DesktopLocation) or os.path.expanduser("~")

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
