import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import "../colors.js" as Colors
import "../controls"

Rectangle {
    id: root
    anchors.fill: parent
    color: "#40464c"
    border.width: 2
    border.color: Colors.color2

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 2
        spacing: 0

        GridLayout{
            id: projectBg
            Layout.fillWidth: true
            Layout.preferredHeight: 80

            columnSpacing: 0
            columns: 4
            rowSpacing: 5
            rows: 2

            TextButton{
                Layout.fillWidth: true
                radius: 0
                primaryColor: Colors.c_button
                clickColor: Colors.c_button_active
                hoverColor: Colors.c_button_hover
                texto: "Novo"
                textColor: "#fff"
            }
            TextButton{
                Layout.fillWidth: true
                radius: 0
                primaryColor: Colors.c_button
                clickColor: Colors.c_button_active
                hoverColor: Colors.c_button_hover
                texto: "Abrir"
                textColor: "#fff"
            }
            TextButton{
                Layout.fillWidth: true
                radius: 0
                primaryColor: Colors.c_button
                clickColor: Colors.c_button_active
                hoverColor: Colors.c_button_hover
                texto: "Salvar"
                textColor: "#fff"
            }
            TextButton{
                Layout.fillWidth: true
                radius: 0
                primaryColor: Colors.c_button
                clickColor: Colors.c_button_active
                hoverColor: Colors.c_button_hover
                texto: "Salvar como"
                textColor: "#fff"
            }
            TextInputCustom{
                id: id
                Layout.columnSpan: 4
                Layout.fillWidth: true
                focusColor: Colors.mainColor2
                title: 'Título do projeto'
                textHolder: ''
                defaultColor: '#fff'
                textColor: '#fff'
            }
        }

        Rectangle{
            id: dataBg
            color: "#0f0"
            Layout.fillWidth: true
            Layout.minimumHeight: 140
        }

        ScrollView{
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.margins: 5
            contentWidth: propsBg.width
            
            GridLayout{
                id: propsBg
                width: root.width*0.95
                columnSpacing: 5
                columns: 3
                rowSpacing: 5
                rows: 20

                TextInputCustom{
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Título do gráfico'
                    textHolder: ''
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
                CheckBoxCustom{
                    Layout.fillWidth: true
                    texto: "Grade"
                }
                TextInputCustom{
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Título do eixo x'
                    textHolder: ''
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
                TextInputCustom{
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Título do eixo x'
                    textHolder: ''
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
                TextInputCustom{
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Título do eixo x'
                    textHolder: ''
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
                TextInputCustom{
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Título do eixo x'
                    textHolder: ''
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
                TextInputCustom{
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Título do eixo x'
                    textHolder: ''
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
            }   
        }

        TextButton{
            Layout.fillWidth: true
            Layout.preferredHeight: 25
            radius: 0
            primaryColor: Colors.c_button
            hoverColor: Colors.c_button_hover
            clickColor: Colors.c_button_active
            texto: "PLOT / ATUALIZAR"
            textColor: "#fff"
        }
        
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/