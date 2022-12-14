import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import "../colors.js" as Colors
import "../controls"

Popup {
    id: root
    anchors.centerIn: Overlay.overlay
    closePolicy: Popup.CloseOnEscape
    width: 400
    height: 250
    modal: true
    focus: true
    leftInset: 0
    rightInset: 0
    bottomInset: 0
    topInset: 0
    margins: 5

    signal applied(string operation, string column1, string column2, string value)

    background: Rectangle{
        id: bg
        anchors.fill: parent
        border.width: 2
        border.color: "#fff"
        color: Colors.color2 
        opacity: 0.95
        radius: 5

        IconButton{
            anchors.right: parent.right
            anchors.rightMargin: -width/3
            anchors.top: parent.top
            anchors.topMargin: -width/3
            width: 30
            height: 30
            r: 20
            z: 1
            primaryColor: Colors.color1
            hoverColor: Colors.color1
            clickColor: Colors.color3
            iconColor: '#fff'
            iconUrl: '../../images/icons/close-24px.svg'
            iconWidth: 20
            borderWidth: 2
            borderColor: "#fff"

            onClicked: root.close()
        }

        GridLayout{
            anchors.fill: parent
            anchors.margins: 10
            columns: 12

            ComboBoxCustom{
                id: operation
                Layout.fillWidth: true
                Layout.columnSpan: 12
                model: ["Substituir", "Somar", "Subtrair", "Multiplicar", "Dividir", "Coluna 1 proporcional à coluna 2", "Trocar", "Adicionar linhas"]
                highlightColor: Colors.mainColor2
                label: "Operação"
            }

            ComboBoxCustom{
                id: column1
                Layout.fillWidth: true
                Layout.columnSpan: 5
                implicitWidth: parent.width/3
                model: ["x", "sx", "y", "sy"]
                highlightColor: Colors.mainColor2
                label: "Coluna 1"
                color: operation.currentText === "Adicionar linhas" ? "#76808a":"#fff"
                textColor: operation.currentText === "Adicionar linhas" ? "#76808a":"#fff"
                enabled: !(operation.currentText === "Adicionar linhas")
            }

            Image {
                id: image
                Layout.fillWidth: true
                Layout.columnSpan: 2
                source: "../../images/svg_images/compare_arrows_white_24dp.svg"
                width: 24
                height: 24
                mipmap: true
                smooth: true
                fillMode: Image.PreserveAspectFit

                ColorOverlay{
                    width: image.width
                    height: image.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: image
                    color: operation.currentText === "Trocar" ? "#4CAF50" : "#76808a"
                }
            }

            ComboBoxCustom{
                id: column2
                Layout.fillWidth: true
                Layout.columnSpan: 5
                model: ["x", "sx", "y", "sy"]
                highlightColor: Colors.mainColor2
                color: operation.currentText === "Trocar" ? "#fff" : "#76808a"
                textColor: operation.currentText === "Trocar" ? "#fff" : "#76808a"
                implicitWidth: parent.width/3
                enabled: operation.currentText === "Trocar" ? true : false
                label: "Coluna 2"
            }

            TextInputCustom{
                id: value
                Layout.columnSpan: 12
                Layout.fillWidth: true
                focusColor: Colors.mainColor2
                textColor: "#fff"
                defaultColor: "#fff"
                disabledColor: "#76808a"
                title: "Valor"
                textHolder: ""
                enabled: operation.currentText !== "Trocar" ? true : false
                validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
            }

            TextButton{
                Layout.alignment: Qt.AlignHCenter
                Layout.columnSpan: 12
                primaryColor: "transparent"
                textColor: "#4CAF50"
                texto: "Aplicar"
                radius: 0
                onClicked: {
                    root.close()
                    root.applied(operation.currentText, column1.currentText, column2.currentText, Number(value.text))
                }
            }
        }

    }
}