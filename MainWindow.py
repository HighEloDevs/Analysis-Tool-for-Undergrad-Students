import sys
import os
from PyQt5 import QtWidgets, QtCore, QtGui
from PyQt5.QtWidgets import QApplication, QMainWindow, QAction, qApp, QFileDialog
from PyQt5.QtGui import QIcon

app = QApplication(sys.argv)

class MainWindow(QMainWindow):
    
    def __init__(self):
        super(MainWindow, self).__init__()
        
        # Main window properties
        self.setWindowTitle("Analysis Tool for Undergrad Students | ATUS")
        self.setGeometry(100, 100, 1500, 700)
        self.setAnimated(True)
        self.setTabShape(QtWidgets.QTabWidget.Rounded)
        
        # Actual file name
        self.aFile = None
        
        self.setAcceptDrops(True)
        
        # Initializing UI
        self.initUI()
        
    def initUI(self):
        
        self.createMenu()
        
        self.retranslateUi()
        QtCore.QMetaObject.connectSlotsByName(self)
        
    def retranslateUi(self):
        _translate = QtCore.QCoreApplication.translate
        self.menuArquivo.setTitle(_translate("MainWindow", "Arquivo"))
    
    def createMenu(self):
        # Creating menu bar
        self.menubar = QtWidgets.QMenuBar(self)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 22))
        self.menubar.setObjectName("menubar")
        
        # Arquivo button
        self.menuArquivo = QtWidgets.QMenu(self.menubar)
        self.menuArquivo.setObjectName("menuArquivo")
        self.menubar.addAction(self.menuArquivo.menuAction())

        # Setting menu bar
        self.setMenuBar(self.menubar)
        
        # Creating status bar
        self.statusbar = QtWidgets.QStatusBar(self)
        self.statusbar.setObjectName("statusbar")
        self.setStatusBar(self.statusbar)
        
        # "Novo Arquivo"
        self.actionNovoArquivo = QtWidgets.QAction(self)
        self.actionNovoArquivo.setObjectName("NovoArquivo")
        self.menuArquivo.addAction(self.actionNovoArquivo)
        self.actionNovoArquivo.setText("Novo Arquivo")
        self.actionNovoArquivo.setShortcut("CTRL+N")
        self.actionNovoArquivo.triggered.connect(self.newFile)
        
        # "Abrir Arquivo"
        self.actionAbrirArquivo = QtWidgets.QAction(self)
        self.actionAbrirArquivo.setObjectName("AbrirArquivo")
        self.menuArquivo.addAction(self.actionAbrirArquivo)
        self.actionAbrirArquivo.setText("Abrir Arquivo")
        self.actionAbrirArquivo.setShortcut("CTRL+O")
        self.actionAbrirArquivo.triggered.connect(self.loadFile)
        
        # "Salvar Arquivo"
        self.actionSalvarArquivo = QtWidgets.QAction(self)
        self.actionSalvarArquivo.setObjectName("SalvarArquivo")
        self.menuArquivo.addAction(self.actionSalvarArquivo)
        self.actionSalvarArquivo.setText("Salvar")
        self.actionSalvarArquivo.setShortcut("CTRL+S")
        self.actionSalvarArquivo.triggered.connect(self.saveFile)
        
        # "Salvar Arquivo Como"
        self.actionSalvarArquivoComo = QtWidgets.QAction(self)
        self.actionSalvarArquivoComo.setObjectName("SalvarArquivoComo")
        self.menuArquivo.addAction(self.actionSalvarArquivoComo)
        self.actionSalvarArquivoComo.setText("Salvar como...")
        self.actionSalvarArquivoComo.setShortcut("CTRL+Shift+S")
        self.actionSalvarArquivoComo.triggered.connect(self.saveFileAs)
        
    def newFile(self):
        # Saving before closing the window
        self.saveFile()
        
        # Closing window and reopening
        app.closeAllWindows()
        self.win = MainWindow()
        self.win.show()
        
    def loadFile(self):
        # Getting file name
        filename = QFileDialog.getOpenFileName(self, 'Open File', os.getenv('HOME'))
        
        # Saving the actual filename
        self.aFile = filename[0]
        
        # Reading it
        with open(filename[0], 'r') as f:
            file_text = f.read()
            return file_text
        
    def saveFile(self):
        # If you didn't open any file, save as
        if self.aFile == None: 
            self.saveFileAs()
        # Else save in the opened file
        else:
            file = open(self.aFile,'w')
            text = "teste"
            file.write(text)
            file.close()
        
    def saveFileAs(self):
        filename = QFileDialog.getSaveFileName(self, 'Save File', os.getenv('HOME'))
        file = open(filename[0],'w')
        text = "teste"
        file.write(text)
        file.close()

    def dragEnterEvent(self, event):
        if event.mimeData().hasUrls():
            event.accept()
        else:
            event.ignore()

    def dropEvent(self, event):
        files = [u.toLocalFile() for u in event.mimeData().urls()]
        for f in files:
          # Saving the actual filename
          self.aFile = f

def main():
    win = MainWindow()
    win.show()
    sys.exit(app.exec_())
    
if __name__ == "__main__":
    main()
