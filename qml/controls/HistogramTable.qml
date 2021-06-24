import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import "../colors.js" as Colors
import "../controls"
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12



Item{
    id: root
    // Fixed header
    property variant headerArr: [
        {title: 'Dados (.txt)', width: 30/100},
        {title: 'Configurações', width: 20/100},
        {title: 'Legenda', width: 30/100},
        {title: 'Visível', width: 10/100},
        {title: 'Excluir', width: 10/100}
    ]
    property variant defaultDataRow: ({
        fileName: "Escolher",
        data    : "",
        kargs   : {
            alpha: "1.0",
            label: false,
            hatch: "/",
            fill: true,
            fc: "#006e00",
            lw: 3,
            ec: "#006e00",
        },
        legend: "",
        visible: true,
        __btn: true,
    })
    property variant dataDisplay: ListModel{
        dynamicRoles: true
    }
    property bool hasData    : dataDisplay.count !== 0 ? true:false
    property int headerHeight: 30

    function getDataShaped(){
        let dataShaped = []
        for (let i=0; i<=dataDisplay.count-1; i++){
            dataShaped.push(dataDisplay.get(i))
        }
        return dataShaped
    }

    function addRow(dataRow){
        dataDisplay.insert(dataDisplay.count, dataRow)
    }

    ColumnLayout{
        anchors.fill: parent     
        spacing: 0   

        // Header
        Rectangle{
            Layout.fillWidth: true
            height: root.headerHeight
            ListView{
                anchors.fill: parent
                orientation: ListView.Horizontal
                interactive: false
                model: root.headerArr
                delegate: Rectangle{
                    width: modelData.width * root.width
                    height: root.headerHeight
                    color: Colors.color1

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.title
                        color: 'white'
                        font.pointSize: 8
                        font.bold: true
                    }
                }
            }
        }

        // Data Display
        Rectangle{
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "transparent"
            ScrollView{
                anchors.fill: parent
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ListView{
                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    model: root.dataDisplay
                    delegate: Rectangle{
                        height: root.headerHeight + 5
                        width: root.width
                        color: "transparent"

                        // Popup for props
                        PopupHistogram{
                            id: popupProps
                            width: 400
                            height: 250

                            onClosed: dataDisplay.setProperty(index, "kargs", popupProps.kargs)
                        }

                        Row{
                            anchors.fill: parent

                            Item{
                                width: root.headerArr[0]["width"] * root.width
                                height: root.headerHeight + 5
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
                                        iconUrl: '../../images/icons/attach_file_white_24dp.svg'
                                        iconColor: 'white'
                                        iconWidth: 18
                                        r: 20
                                        y: (parent.height - iconBtn.height)/2
                                        width: parent.height - 15
                                        height: parent.height - 15

                                        property bool signalFromBtn: false

                                        FileDialog{
                                            id: chooseProject
                                            title: "Escolha o projeto"
                                            folder: shortcuts.desktop
                                            selectMultiple: false
                                            nameFilters: ["Arquivos de dados (*.txt *.tsv *.csv)"]

                                            onAccepted:{
                                                // Response from backend
                                                var res = hist.checkData(fileUrl)
                                                if (res["isValid"]){
                                                    var url = fileUrl.toString()
                                                    var fileName = url.split("/")[url.split("/").length - 1]
                                                    dataDisplay.setProperty(index, "fileName", fileName)
                                                    dataDisplay.setProperty(index, "data", res["data"])
                                                } else {
                                                    if(!iconBtn.signalFromBtn){
                                                        dataDisplay.remove(index)
                                                    }
                                                }
                                                iconBtn.signalFromBtn = false
                                            }
                                            onRejected:{
                                                if(!iconBtn.signalFromBtn){
                                                    dataDisplay.remove(index)
                                                }
                                            }
                                        }

                                        onClicked: {
                                            chooseProject.open()
                                            iconBtn.signalFromBtn = true
                                        }
                                        Component.onCompleted: {
                                            if(__btn){
                                                chooseProject.open()
                                            }
                                            dataDisplay.setProperty(index, "__btn", false)
                                        }
                                    }
                                    Text{
                                        height: parent.height
                                        width: parent.width - iconBtn.width
                                        verticalAlignment: Text.AlignVCenter
                                        text: fileName
                                        color: 'white'
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                            Item{
                                width: root.headerArr[1]["width"] * root.width
                                height: root.headerHeight + 5

                                IconButton{
                                    anchors.centerIn: parent
                                    primaryColor: "transparent"
                                    hoverColor: "transparent"
                                    clickColor: "transparent"
                                    iconUrl: "../../images/icons/settings_black_24dp.svg"

                                    onClicked: {
                                        popupProps.setData(kargs)
                                        popupProps.open()
                                    }
                                }
                            }
                            Item{
                                width: root.headerArr[2]["width"] * root.width
                                height: root.headerHeight + 5
                                TextInput{
                                    id: textInputLabel
                                    verticalAlignment: TextInput.AlignVCenter
                                    anchors.fill: parent
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    selectByMouse: true
                                    color: '#fff'
                                    font.pixelSize: 14
                                    clip: true
                                    
                                    onEditingFinished: dataDisplay.setProperty(index, "legend", textInputLabel.text)
                                }
                                Rectangle{
                                    anchors.top: textInputLabel.bottom
                                    anchors.right: parent.right
                                    anchors.left: parent.left
                                    anchors.topMargin: -5
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    height: 2
                                    color: textInputLabel.focus? Colors.mainColor2 : '#fff'
                                }
                            }
                            Item{
                                width: root.headerArr[3]["width"] * root.width
                                height: root.headerHeight + 5
                                CheckBoxCustom{
                                    anchors.centerIn: parent
                                    onCheckedChanged: dataDisplay.setProperty(index, "visible", Boolean(checkState))
                                }
                            }
                            Item{
                                width: root.headerArr[4]["width"] * root.width
                                height: root.headerHeight + 5
                                TrashButton{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    onClicked: {
                                        dataDisplay.remove(index)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Footer
        Rectangle{
            Layout.fillWidth: true
            height: root.headerHeight - 10
            color: Colors.color1

            IconButton{
                id: addRowBtn
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 5
                height: parent.height-5
                width: parent.height-5
                primaryColor: 'transparent'
                hoverColor: 'transparent'
                clickColor: 'transparent'
                iconColor: '#fff'
                iconUrl: '../../images/icons/add_white-24px.svg'
                r: 0
                
                onClicked: addRow(root.defaultDataRow)
            }
        }
    }
}