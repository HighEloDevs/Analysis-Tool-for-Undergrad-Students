import QtQuick 2.0
import QtQuick.Controls 2.15
import "../controls"
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

Item {
    id: item1
    width: 372
    height: 673
    implicitWidth: 372
    implicitHeight: 673

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
                    width: topBar.width / 2
                    text: "Função de Ajuste"
                    activeMenuColorRight: "#565e66"
                    btnColorDefault: "#34334a"
                    isActiveMenu: true

                    onClicked: {
                        tabBtn1.isActiveMenu = true
                        tabBtn2.isActiveMenu = false

                        pageFuncaoAjuste.visible = true
                        pageProps.visible = false
                    }
                }

                TabButton {
                    id: tabBtn2
                    width: topBar.width / 2
                    text: "Propriedades do gráfico"
                    activeMenuColorRight: "#565e66"
                    btnColorDefault: "#34334a"
                    isActiveMenu: false

                    onClicked: {
                        tabBtn1.isActiveMenu = false
                        tabBtn2.isActiveMenu = true

                        pageFuncaoAjuste.visible = false
                        pageProps.visible = true
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

            Loader{
                id: pageFuncaoAjuste
                anchors.fill: parent
                source: Qt.resolvedUrl("../pages/subpages/funcaoAjustePage.qml")
                visible: true
            }
            Loader{
                id: pageProps
                anchors.fill: parent
                source: Qt.resolvedUrl("../pages/subpages/propriedadesPage.qml")
                visible: false
            }
        }


    }
}


