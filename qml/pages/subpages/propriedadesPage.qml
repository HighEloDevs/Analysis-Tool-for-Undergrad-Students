import QtQuick 2.15
import QtQuick.Controls 2.15

Item {

    Connections{
        target: funcs

        function onSignalPropPage(){
            funcs.loadOptions(titulo.text, eixox.text, eixoy.text, switchResiduos.position, switchGrade.position)
        }
    }

    Rectangle {
        id: rectangle
        width: 372
        height: 673
        color: "#565e66"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Rectangle {
            id: rectangle1
            x: 0
            y: 10
            height: 40
            color: "#00000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            Label {
                id: label
                y: 38
                color: "#ffffff"
                text: qsTr("Título")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            TextField {
                id: titulo
                y: 38
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: label.right
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                placeholderText: qsTr("")
                selectByMouse: true
            }
        }

        Rectangle {
            id: rectangle2
            x: 6
            y: 4
            height: 40
            color: "#00000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rectangle1.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 0
            Label {
                id: label1
                y: 38
                color: "#ffffff"
                text: qsTr("Eixo X")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            TextField {
                id: eixox
                y: 38
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: label1.right
                anchors.right: parent.right
                anchors.leftMargin: 10
                placeholderText: qsTr("")
                anchors.rightMargin: 10
                selectByMouse: true
            }
            anchors.rightMargin: 0
        }

        Rectangle {
            id: rectangle3
            x: 5
            height: 40
            color: "#00000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rectangle2.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 0
            Label {
                id: label2
                y: 38
                color: "#ffffff"
                text: qsTr("Eixo Y")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            TextField {
                id: eixoy
                y: 38
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: label2.right
                anchors.right: parent.right
                anchors.leftMargin: 10
                placeholderText: qsTr("")
                anchors.rightMargin: 10
                selectByMouse: true
            }
            anchors.rightMargin: 0
        }

        Rectangle {
            id: rectangle4
            height: 40
            color: "#00000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rectangle3.bottom
            anchors.topMargin: 0
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            Label {
                id: label3
                x: 77
                y: 214
                color: "#ffffff"
                text: qsTr("Símbolo")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            ComboBox {
                id: simbolo
                y: 13
                width: 90
                height: 25
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: label3.right
                anchors.leftMargin: 10
            }

            ComboBox {
                id: tamanho
                width: 90
                height: 25
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: simbolo.right
                anchors.leftMargin: 10
            }

            ComboBox {
                id: cor
                y: 21
                width: 90
                height: 25
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: tamanho.right
                anchors.leftMargin: 10
            }


        }

        Rectangle {
            id: rectangle5
            height: 40
            color: "#00000000"
            anchors.left: parent.left
            anchors.right: rectangle6.left
            anchors.top: rectangle4.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0

            Switch {
                id: switchGrade
                x: 50
                y: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: label5.right
                display: AbstractButton.TextOnly
                anchors.leftMargin: 10
            }

            Label {
                id: label5
                y: 14
                color: "#ffffff"
                text: qsTr("Grade")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 25
            }
        }

        Rectangle {
            id: rectangle6
            x: 172
            width: 200
            height: 40
            color: "#00000000"
            anchors.right: parent.right
            anchors.top: rectangle4.bottom
            anchors.rightMargin: 0
            anchors.topMargin: 0

            Switch {
                id: switchResiduos
                y: 190
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: label4.right
                anchors.leftMargin: 10
                display: AbstractButton.TextOnly

            }

            Label {
                id: label4
                y: 224
                color: "#ffffff"
                text: qsTr("Resíduos")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 25
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.33;height:673;width:372}
}
##^##*/
