import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11

import "../colors.js" as Colors
import "../controls"

ApplicationWindow {
    id: root
    minimumWidth: 600
    minimumHeight: 600
    visibility: Window.AutomaticVisibility
    visible: false
    color: "transparent"

    // Properties
    property alias children: canvasPlaceholder.children
    property string      os: ""

    Rectangle{
        id: bg
        anchors.fill: parent

        ColumnLayout {
                id: rightPanel_layout
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    id: toolBar
                    height: 50
                    color: Colors.color1
                    Layout.fillWidth: true

                    TabButton{
                        id: backBtn
                        y: 0
                        width: toolBar.width/6
                        text: "Voltar"
                        anchors.left: homeBtn.right
                        anchors.leftMargin: 0

                        onClicked: {
                            canvas.back();
                        }

                    }

                    TabButton{
                        id: homeBtn
                        y: 0
                        width: toolBar.width/6
                        text: "Resetar"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 0

                        onClicked: {
                            canvas.home();
                        }

                    }

                    TabButton {
                        id: fowardBtn
                        y: 0
                        width: toolBar.width/6
                        text: "Avançar"
                        anchors.left: backBtn.right
                        anchors.leftMargin: 0

                        onClicked: {
                            canvas.forward();
                        }
                    }

                    TabButton {
                        id: panBtn
                        y: 0
                        width: toolBar.width/6
                        text: "Mover"
                        anchors.left: fowardBtn.right
                        anchors.leftMargin: 0
                        checkable: true
                        isActiveMenu: false

                        onClicked: {
                            if (zoomBtn.isActiveMenu) {
                                zoomBtn.isActiveMenu = false;
                            }
                            canvas.pan();
                            panBtn.isActiveMenu = true;
                        }

                    }

                    TabButton {
                        id: zoomBtn
                        y: 0
                        width: toolBar.width/6
                        text: "Zoom"
                        anchors.left: panBtn.right
                        anchors.leftMargin: 0
                        checkable: true
                        isActiveMenu: false

                        onClicked: {
                            if (panBtn.isActiveMenu) {
                                panBtn.isActiveMenu = false;
                            }
                            zoomBtn.isActiveMenu = true;
                            canvas.zoom();
                        }
                    }

                    TabButton {
                        id: saveBtn
                        y: 0
                        width: toolBar.width/6
                        text: "Salvar"
                        anchors.left: zoomBtn.right
                        anchors.leftMargin: 0
                        checkable: true
                        isActiveMenu: false

                        onClicked:{
                            fileSaver.open()
                        }

                        FileDialog{
                            id: fileSaver
                            title: "Escolha um local para salvar a figura"
                            folder: shortcuts.desktop
                            selectExisting: false
                            nameFilters: ["Arquivo de imagem .png (*.png)", "Arquivo de imagem .jpg (*.jpg)", "Arquivo de imagem .pdf (*.pdf)", "Arquivo de imagem .svg (*.svg)"]
                            onAccepted: {
                                canvas.save_plot(fileSaver.fileUrl, bgTransparent.checked)
                            }
                        }
                    }
                }

                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Rectangle {
                        id: bg_canvas
                        anchors.fill: parent

                        Item{
                            id: canvasPlaceholder
                            anchors.fill: parent
                        }
                    }
                }

                Rectangle {
                    id: footer
                    Layout.fillWidth: true
                    height: 25
                    color: Colors.color2
                    radius: 5

                    Rectangle{
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        color: parent.color
                        height: parent.height/2
                    }

                    TextInput {
                        id: location
                        readOnly: true
                        text: canvas.coordinates
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: Colors.fontColor
                    }

                    RowLayout{
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                        CheckBoxCustom{
                            id: bgTransparent
                            Layout.fillHeight: true
                            texto: 'Fundo transparente'
                            checked: false
                        }
                        IconTextButton{
                            id: canvasSettingsButton

                            PopupCanvasSettings{
                                id: canvasSettingsPopup
                            }

                            Layout.fillHeight: true
                            texto: 'Configurações'
                            textSize: 11
                            primaryColor: 'transparent'
                            hoverColor: 'transparent'
                            clickColor: 'transparent'
                            iconColor: enabled ? '#fff':'#707070'
                            textColor: enabled ? '#fff':'#707070'
                            iconUrl: '../../images/icons/settings_white_24dp.svg'
                            iconWidth: 17
                            enabled: !bgTransparent.checked

                            onClicked: {
                                canvasSettingsPopup.open()
                            }
                        }
                        IconTextButton{
                            id: copyClipboard
                            Layout.fillHeight: true
                            texto: 'Copiar'
                            textSize: 11
                            primaryColor: 'transparent'
                            hoverColor: 'transparent'
                            clickColor: 'transparent'
                            iconColor: enabled ? '#fff':'#707070'
                            textColor: enabled ? '#fff':'#707070'
                            iconUrl: '../../images/icons/content_copy_black_24dp.svg'
                            iconWidth: 17
                            enabled: !bgTransparent.checked
                            visible: {
                                if(mainWindow.os != 'Windows') false
                                else true
                            }

                            onClicked: {
                                canvas.copy_to_clipboard()
                            }
                        }
                    }
                }
            }
        }

    Component.onCompleted: {
        root.os = updater.getOS()
    }
}