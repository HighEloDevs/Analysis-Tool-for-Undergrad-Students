import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import "../controls"
import "../colors.js" as Colors

Item {
    // TableData{
    //     id: table
    //     width: 300
    //     height: 500
    //     // anchors.fill: parent

    //     dataModel: ListModel{
    //         id: dataSet
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //         ListElement {x_v: 3; y_v: 3; sy: 3; sx: 3}
    //     }   
    // }

    // TextButton{
    //     texto: 'TEESTEE'
    //     primaryColor: Colors.c_button
    //     clickColor: Colors.c_button_active
    //     hoverColor: Colors.c_button_hover
    //     width: 100
    //     onClicked: print('PINTO')
    // }

    // IconButton{
    //     primaryColor: Colors.c_button
    //     clickColor: Colors.c_button_active
    //     hoverColor: Colors.c_button_hover
    //     width: 30
    //     height: 30
    //     r: 4
    //     iconUrl: '../../images/icons/chart-18px.svg'
    //     iconColor: 'green'
    // }

    // Table{
    //     id: table
    //     headerModel: [
    //         {text: 'Parâmetro', width: 1/2},
    //         {text: 'Valor', width: 1/2},
    //     ]
    //     dataModel: ListModel{
    //         id: dataSet
    //         ListElement{parametro: 3; valor: 3}
    //     } 
    // }
    // Button{
    //     text: 'oi'
    //     onClicked: {
    //         table.clear()
    //         // print(table.dataModel.get(0))
    //         }
    // }
    Row{
        TextButton{
            onClicked: print(teste.text)
        }
        TextInputCustom{
            id: teste
            width: 400
            focusColor: Colors.mainColor1
            title: 'Título'
            textHolder: 'Título do gráfico'
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.33;height:500;width:500}
}
##^##*/
