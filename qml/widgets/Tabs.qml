import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.11
import "../colors.js" as Colors
import "../controls"

Item {
    id: item1
    width: 372
    height: 673
    implicitWidth: 372
    implicitHeight: 673

    property alias pageFunc: pageFuncaoAjuste.item
    property alias pageProp: pageProps.item

    Rectangle {
        id: bg
        color: Colors.c_section
        anchors.fill: parent
        clip: true
        z: 1

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
                id: btnPlot
                height: 25
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                Layout.bottomMargin: 5
                Layout.topMargin: 5
                Layout.fillWidth: true
                texto: 'Plot / Atualizar'
                textSize: 10
                primaryColor: Colors.c_button
                clickColor: Colors.c_button_active
                hoverColor: Colors.c_button_hover

                onClicked: {
                    pageFunc.clearTableParams()
                    backend.getProps({
                        expr: pageFunc.expr,
                        p0:  pageFunc.initParams,
                        sigmax: pageFunc.sigmax,
                        sigmay: pageFunc.sigmay,
                        titulo: pageProp.titulo_text,
                        eixox: pageProp.eixox_text,
                        eixoy: pageProp.eixoy_text,
                        residuos: pageProp.residuals,
                        grade: pageProp.grid,
                        logx: pageProp.logx,
                        logy: pageProp.logy,
                        markerColor: pageProp.markerColor,
                        markerSize: pageProp.markerSize,
                        marker: pageProp.marker,
                        curveColor: pageProp.curveColor,
                        curveThickness: pageProp.curveThickness,
                        curveType: pageProp.curveType,
                        legend: pageProp.legend,
                        xmin: pageProp.xmin,
                        xmax: pageProp.xmax,
                        xdiv: pageProp.xdiv,
                        ymin: pageProp.ymin,
                        ymax: pageProp.ymax,
                        ydiv: pageProp.ydiv,
                        resMin: pageProp.resMin,
                        resMax: pageProp.resMax
                    })
                }
            }

            Rectangle {
                id: bottomBar
                height: 20
                color: Colors.color2
                Layout.fillWidth: true
            }

        }

    }
}
