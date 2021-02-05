import QtQuick 2.0
import QtQuick.Controls 2.15
import "../controls"
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

Item {
    id: item1
    Rectangle {
        id: bg
        color: "#565e66"
        anchors.fill: parent
        clip: true
        z: 1

        Rectangle {
            id: topBar
            height: 60
            color: "#383d42"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.rightMargin: 0

            Row {
                id: row
                anchors.fill: parent

                TabButton{
                    id: tabBtn1
                    width: topBar.width / 3
                    text: "Função de Ajuste"
                    activeMenuColorRight: "#565e66"
                    btnColorDefault: "#34334a"
                    isActiveMenu: true

                    onClicked: {
                        tabBtn1.isActiveMenu = true
                        tabBtn2.isActiveMenu = false
                        tabBtn3.isActiveMenu = false

                        stackViewTab.push(Qt.resolvedUrl("../pages/subpages/funcaoAjustePage.qml"))
                    }
                }

                TabButton {
                    id: tabBtn2
                    width: topBar.width / 3
                    text: "Propriedades do gráfico"
                    activeMenuColorRight: "#565e66"
                    btnColorDefault: "#34334a"
                    isActiveMenu: false

                    onClicked: {
                        tabBtn1.isActiveMenu = false
                        tabBtn2.isActiveMenu = true
                        tabBtn3.isActiveMenu = false

                        stackViewTab.push(Qt.resolvedUrl("../pages/subpages/propriedadesPage.qml"))
                    }
                }

                TabButton {
                    id: tabBtn3
                    width: topBar.width / 3
                    text: "Exemplos"
                    activeMenuColorRight: "#565e66"
                    btnColorDefault: "#34334a"
                    isActiveMenu: false

                    onClicked: {
                        tabBtn1.isActiveMenu = false
                        tabBtn2.isActiveMenu = false
                        tabBtn3.isActiveMenu = true

                        stackViewTab.push(Qt.resolvedUrl("../pages/subpages/exemplosPage.qml"))
                    }
                }
            }
        }

        Rectangle {
            id: bottomBar
            y: 165
            height: 20
            color: "#34334a"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
        }

        Rectangle {
            id: content
            color: "#00000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: topBar.bottom
            anchors.bottom: bottomBar.top
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            clip: true

            StackView {
                id: stackViewTab
                anchors.top: topBar.bottom
                anchors.bottom: bottomBar.top
                anchors.fill: parent
                initialItem: Qt.resolvedUrl("../pages/subpages/funcaoAjustePage.qml")

                layer.textureMirroring: ShaderEffectSource.NoMirroring
                layer.enabled: false
                enabled: true
                layer.wrapMode: ShaderEffectSource.ClampToEdge
                antialiasing: false
            }
        }


    }

    DropShadow{
        anchors.fill: bg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10
        samples: 16
        color: "#80000000"
        source: bg
        z: 0
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:600;width:1000}
}
##^##*/
