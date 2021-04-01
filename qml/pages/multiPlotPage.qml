import QtQuick 2.15
import QtQuick.Controls 2.15
import "../colors.js" as Colors
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import "../controls"

Item {
    TableData{
        id: table
        width: 300
        height: 500

        dataModel: ListModel{
            id: dataSet
            ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
            ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
        }   
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.33;height:500;width:500}
}
##^##*/
