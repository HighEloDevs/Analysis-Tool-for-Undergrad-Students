import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.11
import "../colors.js" as Colors

Popup {
        id: root
        anchors.centerIn: Overlay.overlay
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        leftInset: 0
        rightInset: 0
        bottomInset: 0
        topInset: 0
        margins: 5

        property variant infos: ({published_at: ""})
        property string updateLog: ''
        property string version: ''
        property string exeLink: ''
        property string tarLink: ''
        property string zipLink: ''
        property string platform: ''
        property bool fromPip: false
        property real total: 0

        Popup{
            id: permissionPopup
            anchors.centerIn: Overlay.overlay
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape
            leftInset: 0
            rightInset: 0
            bottomInset: 10
            topInset: 10
            width: 400
            height: 100

            background: Rectangle{
                anchors.fill: parent
                color: "#1e1e1e"
                radius: 5
                opacity: 0.95

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 10
                    spread: 0.1
                    samples: 17
                    color: "#252525"
                }


                ColumnLayout{
                    anchors.fill: parent
                    spacing: 10
                    Rectangle{
                        Layout.fillWidth: parent
                        Layout.fillHeight: parent
                        color: "transparent"
                        Label{
                            anchors.centerIn: parent
                            text: "Tem certeza que deseja atualizar?"
                            font.weight: Font.ExtraLight
                            font.pixelSize: 18
                            color: "#ffffff"
                        }
                    }

                    Row{
                        Layout.bottomMargin: 10
                        Layout.alignment: Qt.AlignCenter
                        spacing: 10
                        TextButton{
                            primaryColor: "transparent"
                            width: 120
                            height: 30
                            textColor: "#009900"
                            texto: 'Atualizar'

                            onClicked: {
                                permissionPopup.close()
                                updater.updateOnWindows()
                            }
                        }

                        TextButton{
                            primaryColor: "transparent"
                            width: 120
                            height: 30
                            textColor: "#ff5757"
                            texto: 'Cancelar'

                            onClicked: permissionPopup.close()
                        }
                    }
                }
            }
        }

        background: Rectangle{
            anchors.fill: parent
            color: '#1e1e1e'
            radius: 5
            opacity: 0.95

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 1
                verticalOffset: 1
                radius: 10
                spread: 0.1
                samples: 17
                color: "#252525"
            }

            ColumnLayout{
                anchors.fill: parent
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                spacing: 0

                Rectangle{
                    id: titleBg
                    Layout.fillWidth: true
                    height: 50
                    color: '#009688'

                    GridLayout{
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        rows: 2
                        columns: 1
                        rowSpacing: 0
                        columnSpacing: 20

                        Label{
                            text: "Atualização"
                            font.pixelSize: 18
                            font.bold: true
                            color: '#ffffff'
                        }
                        Label{
                            text: "Publicado em " + infos["published_at"]
                            font.pixelSize: 14
                            font.weight: Font.Light
                            color: '#fafafa'
                        }
                    }

                    IconButton{
                        id: closeUpdateLogBtn

                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter

                        width: 30
                        height: 30
                        r: 20

                        primaryColor: "transparent"
                        hoverColor: "transparent"
                        clickColor: "transparent"
                        iconColor: '#fff'
                        iconUrl: '../../images/icons/close-24px.svg'
                        iconWidth: 24

                        onClicked: updatePopup.close()
                    }
                }

                // Update content
                ScrollView{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    topPadding: 30
                    bottomPadding: 30
                    contentWidth: logText.width
                    contentHeight: logText.height
                    clip: true

                    Text{
                        id: logText
                        width: updatePopup.width - 80
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        color: '#eee'
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignJustify
                        lineHeight: 1.2
                        antialiasing: true
                        wrapMode: Text.Wrap
                        text: updatePopup.updateLog
                        textFormat: TextEdit.MarkdownText
                    }
                }

                Rectangle{
                    height: 50
                    Layout.fillWidth: true
                    color: '#1e1e1e'
                    Rectangle{
                        visible: platform != "Windows" || fromPip
                        anchors.fill: parent
                        color: "transparent"
                        TextEdit{
                            anchors.centerIn: parent
                            text: "pip install atus --upgrade"
                            font.pixelSize: 16
                            font.weight: Font.ExtraLight
                            color: '#ffffff'
                            readOnly: true
                            selectByMouse: true
                        }
                    }
                    RowLayout{
                        visible: platform == "Windows" && !fromPip
                        anchors.fill: parent
                        anchors.leftMargin: 50
                        anchors.rightMargin: 50
                        TextButton{
                            id: downloadBtn
                            primaryColor: '#009688'
                            hoverColor: Colors.c_button_hover
                            clickColor: Colors.c_button_active
                            width: 120
                            height: 40
                            texto: 'Atualizar'

                            onClicked: permissionPopup.open()
                        }

                        Rectangle{
                            id: loadingBar
                            width: 400
                            color: "transparent"
                            height: 20
                            radius: 2
                            border.width: 1
                            border.color: "#fff"

                            Rectangle{
                                id: progress
                                anchors.top: parent.top
                                anchors.topMargin: 2
                                anchors.left: parent.left
                                anchors.leftMargin: 2
                                color: '#009688'
                                radius: 2
                                height: 16
                                width: 396 * total
                            }
                        }

                        Label{
                            id: loadingLabel
                            text: (total * 100).toFixed(0) + '%'
                            font.pixelSize: 12
                            font.weight: Font.Light
                            color: '#fff'
                        }
                    }
                }
            }
        }

        Connections{
            target: updater
            function onUpdateProgress(progress) {
                total = progress
            }
        }
    }
/*##^##
Designer {
    D{i:0;autoSize:true;height:500;width:500}
}
##^##*/
