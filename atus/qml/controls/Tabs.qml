import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.11
import "../colors.js" as Colors
import "../controls"

Item {
    id: root
    width: 372
    height: 673

    property alias pageFunc: pageFuncaoAjuste.item
    property alias pageProp: pageProps.item
    property alias btnSinglePlot: btnSinglePlot
    property bool isPlotable: false

    Rectangle {
        id: bg
        color: Colors.color3
        anchors.fill: parent
        radius: 5
        clip: true

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0.5
            verticalOffset: 1
            radius: 10
            spread: 0.05
            samples: 17
            color: "#252525"
        }

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            spacing: 0

            Rectangle {
                id: topBar
                Layout.fillWidth: true
                height: 60
                color: "#00000000"

                Row {
                    id: row
                    anchors.fill: parent

                    TabButton{
                        id: tabBtn1
                        width: topBar.width / 2
                        text: "Função de Ajuste"
                        activeMenuColorRight: "#565e66"
                        isActiveMenu: true
                        iconUrl: "../../images/icons/functions_white_24dp.svg"

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
                        text: "Propriedades"
                        activeMenuColorRight: "#565e66"
                        isActiveMenu: false
                        iconUrl: "../../images/icons/settings_white_24dp.svg"

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
                id: content
                color: "#00000000"
                Layout.fillWidth: true
                Layout.fillHeight: true
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

            TextButton{
                id: btnSinglePlot
                height: 25
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                Layout.bottomMargin: 5
                Layout.topMargin: 5
                Layout.fillWidth: true
                texto: 'PLOT / ATUALIZAR'
                primaryColor: "#009900"
                clickColor: Colors.c_button_active
                hoverColor: Colors.c_button_hover
                enabled: {root.isPlotable || (!pageFunc.adjust.checked && pageFunc.expr.text.length > 0)}
            }

        }

    }
}
