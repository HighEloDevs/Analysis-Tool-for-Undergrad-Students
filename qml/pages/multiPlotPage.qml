import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import "../controls"
import "../colors.js" as Colors

Item {
    id: root
    
    TableMultiPlot{
        width: parent.width
        height: 400
    }

    Connections{
        target: multiplot
        function onSetData(data){
            print(data['projectName'])
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.33;height:500;width:500}
}
##^##*/
