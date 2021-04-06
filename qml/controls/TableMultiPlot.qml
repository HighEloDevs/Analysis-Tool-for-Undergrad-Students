import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
import "../controls"
import "../colors.js" as Colors

Item {
    id: root
    width: 600
    height: 400
     
    property variant headerArr: [
        {title: 'Projeto (.json)', width: 4.5/20},
        {title: 'Pontos', width: 1.5/20},
        {title: 'Função', width: 1.5/20},
        {title: 'Legenda', width: 5/20},
        {title: 'Cor', width: 2/20},
        {title: 'Curva', width: 4/20},
        {title: 'Excluir', width: 1.5/20}
    ]

    property variant dataSet: ListModel{
        ListElement{ projeto: 'TESTE' }
    }

    function addRow(data){
        dataSet.insert(dataSet.count, {
            
        })
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        // Header
        Rectangle{
            id: header
            Layout.fillWidth: true
            height: 30
            color: Colors.color1

            ListView{
                anchors.fill: parent
                orientation: ListView.Horizontal
                interactive: false
                model: headerArr
                delegate: Item{
                    width: modelData.width * header.width
                    height: header.height

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.title
                        color: 'white'
                        font.pixelSize: 12
                        font.bold: true
                    }
                }
            }
        }

        Rectangle{
            id: dataBg
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: Colors.color3
            border.color: Colors.color1
            border.width: 2

            ScrollView{
                anchors.fill: parent
                contentWidth: root.width
                contentHeight: listViewTable.height
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                
                ListView{
                    id: listViewTable
                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds
                    interactive: true
                    clip: true
                    model: dataSet

                    delegate: Rectangle{
                        width: root.width
                        height: header.height + 10

                        property int row: index

                        color: (row%2 == 0) ? Colors.color2 : Colors.color3

                        Row{
                            anchors.fill: parent
                            Item{
                                width: headerArr[0].width * root.width
                                height: parent.height
                                
                                Row{
                                    anchors.fill: parent
                                    anchors.leftMargin: 5
                                    anchors.rightMargin: 5
                                    spacing: 5
                                    IconButton{
                                        id: iconBtn
                                        clickColor: 'transparent'
                                        hoverColor: 'transparent'
                                        primaryColor: 'transparent'
                                        iconUrl: '../../images/icons/attach_file_white_36dp.svg'
                                        iconColor: 'white'
                                        r: 20
                                        y: (parent.height - iconBtn.height)/2
                                        width: parent.height - 15
                                        height: parent.height - 15

                                        FileDialog{
                                            id: chooseProject
                                            title: "Escolha o projeto"
                                            folder: shortcuts.desktop
                                            selectMultiple: false
                                            nameFilters: ["Arquivos JSON (*.json)"]
                                            onAccepted:{
                                                multiplot.loadData(fileUrl)
                                            }
                                        }

                                        onClicked: chooseProject.open()
                                    }
                                    Text{
                                        height: parent.height
                                        width: parent.width - iconBtn.width
                                        verticalAlignment: Text.AlignVCenter
                                        text: 'Escolha o projeto'
                                        color: 'white'
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                    }
                                }
                                
                            }
                            Item{
                                width: headerArr[1].width * root.width
                                height: parent.height
                                CheckBoxCustom{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    checked: false
                                }
                            }
                            Item{
                                width: headerArr[2].width * root.width
                                height: parent.height
                                CheckBoxCustom{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                            Item{
                                width: headerArr[3].width * root.width
                                height: parent.height
                                TextInput{
                                    id: textInput
                                    verticalAlignment: TextInput.AlignVCenter
                                    anchors.fill: parent
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    selectByMouse: true
                                    color: 'white'
                                    font.pixelSize: 14
                                    clip: true
                                }
                                Rectangle{
                                    anchors.top: textInput.bottom
                                    anchors.right: parent.right
                                    anchors.left: parent.left
                                    anchors.topMargin: -10
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    height: 2
                                    color: textInput.focus? Colors.mainColor2 : '#fff'
                                }
                            }
                            Item{
                                width: headerArr[4].width * root.width
                                height: parent.height
                                TextButton{
                                    id: colorBtn
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    primaryColor: '#fff'
                                    hoverColor: colorBtn.primaryColor
                                    clickColor: colorBtn.primaryColor
                                    textColor: '#000'
                                    texto: 'Cor'

                                    ColorDialog {
                                        id: colorDialog
                                        title: "Escolha uma cor para os pontos"
                                        onAccepted: {
                                            colorBtn.primaryColor = colorDialog.color
                                        }
                                    }

                                    onClicked: colorDialog.open()
                                }
                            }

                            Item{
                                width: headerArr[5].width * root.width
                                height: parent.height

                                ComboBoxCustom{
                                    anchors.fill: parent
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    anchors.topMargin: 8
                                    anchors.bottomMargin: 8
                                }
                            }

                            Item{
                                width: headerArr[6].width * root.width
                                height: parent.height
                                
                                TrashButton{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle{
            id: footer
            Layout.fillWidth: true
            height: 20
            color: Colors.color1
        }
    }
}
