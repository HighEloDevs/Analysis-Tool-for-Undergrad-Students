import QtQuick 2.0
import QtQuick.Controls 2.15
import "../colors.js" as Colors

Item {
    anchors.fill: parent
    Rectangle {
        id: rectangle
        color: Colors.color3
        anchors.fill: parent

        Text {
            id: text1

            text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">Analysis Tool for Undergrad Students | ATUS</span></p>\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">Copyright (c) 2021</span></p>\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">Autores:</span></p>\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">Guilherme Ferrari Fortino (Dev) - </span><a name=\"@guiiferrari\"></a><a href=\"https://github.com/GuiiFerrari/\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; text-decoration: underline; color:#10f418; background-color:transparent;\">@GuiiFerrari</span></a><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\"> </span></p>\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">Leonardo Eiji Tamayose (Dev) - </span><a name=\"@leoeiji\"></a><a href=\"https://github.com/leoeiji/\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; text-decoration: underline; color:#10f418; background-color:transparent;\">@leoeiji</span></a><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\"> </span></p>\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">Thais Silva Abelha (Dev) - </span><a name=\"@ThaisBee\"></a><a href=\"https://github.com/ThaisBee/\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; text-decoration: underline; color:#10f418; background-color:transparent;\">@ThaisBee</span></a><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\"> </span></p>\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">Sara Santos (Artes) - </span><a name=\"@_imscl\"></a><a href=\"https://www.instagram.com/imscl_/\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; text-decoration: underline; color:#10f418; background-color:transparent;\">@_imscl</span></a><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">   </span></p>\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2; background-color:transparent;\">Contato: </span><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#10f418; background-color:transparent;\">atusdevs@gmail.com</span></p>\n<p align=\"center\" style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; color:#f8f8f2;\"><br /></p>\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Consolas','Courier New','monospace','Bahnschrift'; font-size:14pt; font-weight:600; font-style:italic; color:#f8f8f2; background-color:transparent;\">Aqui o &quot;mundo&quot; é criado. O mundo é lógico!</span></p></body></html>"
            // text: "Lançamento inicial do ATUS. Como ainda estamos na versão alfa, ainda existem muitos bugs.\r\nNa descrição se encontra o instalador do software para Windows."
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
