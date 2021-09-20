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
    closePolicy: Popup.NoAutoClose
    modal: true
    focus: true
    leftInset: 0
    rightInset: 0
    bottomInset: 0
    topInset: 0
    margins: 5

    background: Rectangle {
        anchors.fill: parent
        color: Colors.color2
        opacity: 0.95
        border.color: "#fff"
        border.width: 2
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
    }

    contentItem: GridLayout {
        anchors.fill: parent
        columns: 1
        Text {
            Layout.topMargin: 15
            Layout.alignment: Qt.AlignHCenter

            text: "Configurações da figura"
            font.bold: true
            font.pointSize: 15
            color: "#e5e5e5"
        }

        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            columns: 12
            
            TextInputCustom{
                id: figWidth
                Layout.columnSpan: 6
                Layout.fillWidth: true
                focusColor: Colors.mainColor2
                textHolder: ""
                title: "Largura (px)"
                textColor: "#fff"
                defaultColor: "#fff"
                validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
            }
            TextInputCustom{
                id: figHeight
                Layout.columnSpan: 6
                Layout.fillWidth: true
                focusColor: Colors.mainColor2
                textHolder: ""
                title: "Altura (px)"
                textColor: "#fff"
                defaultColor: "#fff"
                validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
            }

            Text{
                Layout.columnSpan: 12
                Layout.alignment: Qt.AlignHCenter
                text: "Distância do gráfico às bordas"
                font.bold: true
                font.pointSize: 11
                color: "#a4a4a4"
            }
            TextInputCustom{
                id: paddingTop
                Layout.columnSpan: 3
                focusColor: Colors.mainColor2
                textHolder: ""
                title: "Topo (px)"
                textColor: "#fff"
                defaultColor: "#fff"
                validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
            }
            TextInputCustom{
                id: paddingBottom
                Layout.columnSpan: 3
                focusColor: Colors.mainColor2
                textHolder: ""
                title: "Baixo (px)"
                textColor: "#fff"
                defaultColor: "#fff"
                validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
            }
            TextInputCustom{
                id: paddingLeft
                Layout.columnSpan: 3
                focusColor: Colors.mainColor2
                textHolder: ""
                title: "Esquerda (px)"
                textColor: "#fff"
                defaultColor: "#fff"
                validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
            }
            TextInputCustom{
                id: paddingRight
                Layout.columnSpan: 3
                focusColor: Colors.mainColor2
                textHolder: ""
                title: "Direita (px)"
                textColor: "#fff"
                defaultColor: "#fff"
                validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
            }
            
        }

        RowLayout{
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 15
            spacing: 20
            TextButton{
                radius: 0
                primaryColor: "transparent"
                textColor: "#FF5252"
                texto: "Restaurar"

                onClicked: {
                    canvas.resize_canvas()
                }
            }
            TextButton{
                radius: 0
                primaryColor: "transparent"
                textColor: "#4CAF50"
                texto: "Aplicar"
                onClicked: {
                    canvas.set_canvas_size(Number(figWidth.text), Number(figHeight.text))
                    // Aqui, burro, você coloca sua função que chama o backend
                    // Vou te dar um exemplo, tá? :)
                    // canvas.suafunçãoAQUI(ARGUMENTOS, ARGUMENTOS, ARGUMENTOS)
                    // canvas é o objeto, tá?
                    // canvas.suafunçãoAQUI é o método, tá?
                    // ARGUMENTOS é o que você passa como argumento, tá?
                    // id.paddingRight.text é a distância do gráfico à direita
                    // id.paddingLeft.text  é a distância do gráfico à esquerda
                    // id.paddingTop.text  é a distância do gráfico à cima
                    // id.paddingBottom.text  é a distância do gráfico à baixo
                    // ":D"
                }
            }
        }
    }
}