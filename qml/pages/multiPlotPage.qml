import QtQuick 2.15
import QtQuick.Controls 2.15
import "../colors.js" as Colors
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import "../controls"

Item {
    // Rectangle {
    //     id: bg
    //     color: Colors.color3
    //     anchors.fill: parent

    //     TableView {
    //         anchors.fill: parent
    //         interactive: false
    //         pixelAligned: false
    //         clip: false
    //         anchors.rightMargin: 0
    //         anchors.bottomMargin: 0
    //         anchors.leftMargin: 0
    //         anchors.topMargin: 0
    //         columnSpacing: 1
    //         rowSpacing: 1
    //         boundsBehavior: Flickable.StopAtBounds

    //         model: TableModel {
    //             TableModelColumn { display: "checked" }
    //             TableModelColumn { display: "amount" }
    //             TableModelColumn { display: "fruitType" }
    //             TableModelColumn { display: "fruitPrice" }

    //             // Each row is one type of fruit that can be ordered
    //             rows: [
    //                 {
    //                     checked: true,
    //                     amount: 1,
    //                     fruitType: "Arquivos",
    //                     fruitPrice: 1.50
    //                 },
    //             ]
    //         }

    //         delegate: DelegateChooser {
    //             DelegateChoice {
    //                 column: 0
    //                 delegate: CheckBox {
    //                     checked: model.display
    //                     onToggled: model.display = checked
    //                 }
    //             }
    //             DelegateChoice {
    //                 column: 1
    //                 delegate: SpinBox {
    //                     value: model.display
    //                     onValueModified: model.display = value
    //                 }
    //             }
    //             DelegateChoice {
    //                 delegate: TextField {
    //                     text: model.display
    //                     readOnly: true
    //                     selectByMouse: true
    //                     implicitWidth: 140
    //                     onAccepted: model.display = text
    //                 }
    //             }
    //         }
    //     }
    // }

    Table{
        id: table
        width: 300
        height: parent.height/3

        headerModel: [
            {text: '<b>X</b>', width: 0.25},
            {text: '<b>Y</b>', width: 0.25},
            {text: '<b>Sigma Y</b>', width: 0.25},
            {text: '<b>Sigma X</b>', width: 0.25},
        ]

        onClicked: {
            print(row)
            print(dataModel)
            dataModel.push([2, 2, 2, 2])
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.33;height:500;width:500}
}
##^##*/
