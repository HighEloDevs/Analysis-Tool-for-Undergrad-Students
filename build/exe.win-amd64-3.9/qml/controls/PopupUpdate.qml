import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.11
import "../colors.js" as Colors

Popup {
        id: root
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        leftInset: 0
        rightInset: 0
        bottomInset: 0
        topInset: 0
        margins: 5

        property string updateLog: ''
        property string version: ''
        property string exeLink: ''
        property string tarLink: ''
        property string zipLink: ''

        background: Rectangle{
            anchors.fill: parent
            color: '#fff'
            radius: 5
            opacity: 0.95

            IconButton{
                id: closeUpdateLogBtn

                anchors.right: parent.right
                anchors.rightMargin: -closeUpdateLogBtn.width/3
                anchors.top: parent.top
                anchors.topMargin: -closeUpdateLogBtn.width/3

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

                onClicked: updatePopup.close()
            }

            ColumnLayout{
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                anchors.topMargin: 2
                anchors.bottomMargin: 2

                Rectangle{
                    id: titleBg
                    Layout.fillWidth: true
                    height: 60
                    radius: 5
                    color: Colors.color2

                    Label{
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'Atualização Disponível | v' + updatePopup.version
                        color: '#fff'
                        font.pixelSize: 20
                    }
                }

                ScrollView{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentWidth: logText.width
                    contentHeight: logText.height
                    clip: true

                    Text{
                        id: logText
                        width: updatePopup.width - 30
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        color: '#000'
                        font.pixelSize: 17
                        wrapMode: Text.WrapAnywhere
                        text: updatePopup.updateLog
                    }
                }

                RowLayout{
                    Layout.fillWidth: true
                    height: 40

                    IconTextButton{
                        id: downloadBtn
                        Layout.fillWidth: true
                        primaryColor: Colors.color2
                        hoverColor: Colors.c_button_hover
                        clickColor: Colors.c_button_active
                        r: 5
                        width: 120
                        height: 30
                        texto: 'Download (.exe)'
                        iconUrl: '../../images/icons/get_app_black_24dp.svg'

                        onClicked: Qt.openUrlExternally(updatePopup.exeLink)
                    }
                    IconTextButton{
                        Layout.fillWidth: true
                        primaryColor: Colors.color2
                        hoverColor: Colors.c_button_hover
                        clickColor: Colors.c_button_active
                        r: 5
                        width: 120
                        height: 30
                        texto: 'Download (.tar)'
                        iconUrl: '../../images/icons/get_app_black_24dp.svg'

                        onClicked: Qt.openUrlExternally(updatePopup.tarLink)
                    }
                    IconTextButton{
                        Layout.fillWidth: true
                        primaryColor: Colors.color2
                        hoverColor: Colors.c_button_hover
                        clickColor: Colors.c_button_active
                        r: 5
                        width: 120
                        height: 30
                        texto: 'Download (.zip)'
                        iconUrl: '../../images/icons/get_app_black_24dp.svg'

                        onClicked: Qt.openUrlExternally(updatePopup.zipLink)
                    }
                }
            }
        }
    }
/*##^##
Designer {
    D{i:0;autoSize:true;height:500;width:500}
}
##^##*/
