import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import "../colors.js" as Colors
import "../controls"

Item{
    id: root
    width: 200
    height: 50

    // Some properties
    property color focusColor: '#f0f'
    property color defaultColor: '#000'
    property color textColor: '#000'
    property string title: 'Título do TextInput'
    property string textHolder: 'Placeholder'
    property alias text: textInput.text 
    property alias validator: textInput.validator

    Rectangle{
        id: bg
        height: 53
        anchors.fill: parent
        color: 'transparent'

        RowLayout{
            id: row
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: 0
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 5
            anchors.leftMargin: 5

            TextInput{
                id: textInput
                verticalAlignment: TextInput.AlignVCenter
                Layout.fillWidth: true
                font.pixelSize: 14
                selectByMouse: true
                clip: true
                color: textColor
            }

            IconButton{
                id: deleteBtn
                width: 30
                height: 30
                Layout.preferredHeight: 30
                Layout.preferredWidth: 30
                primaryColor: 'transparent'
                hoverColor: 'transparent'
                clickColor: 'transparent'
                iconColor: textInput.focus ? focusColor:defaultColor
                iconUrl: '../../images/icons/close_black_24dp.svg'
                visible: textInput.text != ''

                onClicked: textInput.text = ""
            }
        }
        
        Label{
            id: titleLabel
            anchors.top: parent.top
            anchors.topMargin: parent.height/2 - titleLabel.height/2
            anchors.left: parent.left
            anchors.leftMargin: 5
            font.pixelSize: 14
            text: title
            color: defaultColor

            states: [
                State{
                    name: "Written"
                    PropertyChanges{
                        target: titleLabel
                        scale: 0.7
                        anchors.topMargin: parent.height/2 - titleLabel.height*1.5
                        anchors.leftMargin: -(titleLabel.width - 0.7*titleLabel.width)/2 + 5
                        color: textInput.focus? focusColor:defaultColor
                    }
                    PropertyChanges{
                        target: footer
                        color: textInput.focus? focusColor:defaultColor
                    }
                    when: textInput.focus || textInput.text != ''
                }
            ]

            transitions: Transition {
                ColorAnimation { duration: 100 }
                NumberAnimation { properties: "scale, anchors.topMargin, anchors.leftMargin"; duration: 100 }
            }
        }

        Rectangle{
            id: footer
            width: root.width
            height: 2
            anchors.top: row.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.topMargin: -12
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            color: defaultColor
        }

        Label{
            id: placeHolder
            width: root.width
            anchors.top: footer.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.topMargin: 0
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            font.pixelSize: 10
            visible: textInput.focus
            color: focusColor
            text: textHolder
        }
    }
}
/*##^##
Designer {
    D{i:0;formeditorZoom:3}
}
##^##*/
