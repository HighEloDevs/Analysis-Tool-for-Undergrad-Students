import sys
from PyQt5 import QtWidgets, QtCore
from PyQt5.QtWidgets import QApplication, QMainWindow, QAction, qApp
from PyQt5.QtGui import QIcon

class MainWindow(QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()
        
        # Main window properties
        self.setWindowTitle("Analysis Tool for Undergrad Students | ATUS")
        self.setGeometry(100, 100, 1500, 700)
        self.setAnimated(True)
        self.setTabShape(QtWidgets.QTabWidget.Rounded)
        
        # Initializing UI
        self.initUI()
        
    def initUI(self):
        
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
        
        self.label = QtWidgets.QLabel(self)
        self.label.setText("Teste")
        self.label.move(500, 450)
        
        self.button = QtWidgets.QPushButton(self)
        self.button.setText("CLICA")
        self.button.move(200, 200)
        self.button.clicked.connect(self.click)
        
        self.retranslateUi()
        QtCore.QMetaObject.connectSlotsByName(self)
        
    def retranslateUi(self):
        _translate = QtCore.QCoreApplication.translate
        self.menuArquivo.setTitle(_translate("MainWindow", "Arquivo"))
        
        self.actionNovoArquivo.setText("Novo Arquivo")
        
    def click(self):
        self.label.setText("<font color=red>PINTO DO MURILLO TEM 50CM</font>")
        self.resize()
        
    def resize(self):
        self.label.adjustSize()

def main():
    app = QApplication(sys.argv)
    win = MainWindow()
    win.show()
    sys.exit(app.exec_())
    
if __name__ == "__main__":
    main()