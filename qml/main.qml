import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import "controls"
import "widgets"

Window {
    id: mainWindow
    width: 1500
    height: 800

    minimumWidth: 1300
    minimumHeight: 600

    visible: true
    color: "#00000000"
    property alias labelRightInfoText: labelRightInfo.text

    // Removing Title Bar
    flags: Qt.Window | Qt.FramelessWindowHint

    // Properties
    property int windowStatus: 0
    property int windowMargin: 10
    property int stackedPage: 0

    // Internal Functions
    QtObject{
        id: internal

        function resetResizeBorders(){
            resizeLeft.visible = true
            resizeBottom.visible = true
            resizeRight.visible = true
            resizeTop.visible = true
            resizeBottomRight.visible = true
        }

        function maximizeRestore(){
            if(windowStatus == 0)
            {
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                btnMaximizeRestore.btnIconSource = "../images/svg_images/restore_icon.svg"

                resizeLeft.visible = false
                resizeBottom.visible = false
                resizeRight.visible = false
                resizeTop.visible = false
                resizeBottomRight.visible = false
            }
            else
            {
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
                resetResizeBorders()
            }
        }

        function ifMaximizedWindowRestore(){
            if(windowStatus == 1){
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
                resetResizeBorders()
            }
        }

        function restoreMargins(){
            windowStatus = 0
            windowMargin = 10
            btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
            resetResizeBorders()
        }
    }

    Rectangle {        
        id: bg
        color: "#2c313c"
        border.color: "#353b48"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: windowMargin
        anchors.leftMargin: windowMargin
        anchors.bottomMargin: windowMargin
        anchors.topMargin: windowMargin
        z: 1

        Rectangle {
            id: appContainer
            color: "#00000000"
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 1

            Rectangle {
                id: topBar
                height: 60
                color: "#1c1d20"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                ToggleButton{
                    onClicked: animationMenu.running = true
                }

                Rectangle {
                    id: topBarDescription
                    y: 21
                    height: 25
                    color: "#282c34"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 70
                    anchors.bottomMargin: 0

                    Label {
                        id: labelLeftInfo
                        color: "#c3cbdd"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.rightMargin: 300
                        anchors.leftMargin: 10
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                    }

                    Label {
                        id: labelRightInfo
                        color: "#c3cbdd"
                        text: "| Início"
                        anchors.left: labelLeftInfo.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.rightMargin: 10
                        anchors.leftMargin: 0
                        anchors.topMargin: 0

                    }
                }

                Rectangle {
                    id: titleBar
                    height: 35
                    color: "#00000000"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 105
                    anchors.leftMargin: 70
                    anchors.topMargin: 0

                    DragHandler{
                        onActiveChanged: if(active){
                                             mainWindow.startSystemMove()
                                             internal.ifMaximizedWindowRestore()
                                         }
                    }

                    Image {
                        id: iconApp
                        width: 22
                        height: 22
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: ""
                        anchors.leftMargin: 5
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: appTitle
                        color: "#c3cbdd"
                        text: qsTr("Analysis Tool for Undergrad Students | ATUS")
                        anchors.left: iconApp.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 10
                        anchors.leftMargin: 5
                    }
                }

                Row {
                    id: rowBtns
                    x: 910
                    width: 105
                    height: 35
                    anchors.right: parent.right
                    anchors.top: parent.top
                    transformOrigin: Item.Center
                    anchors.rightMargin: 0
                    anchors.topMargin: 0

                    TopBarButton {
                        id: btnMinimize
                        onClicked: {
                            internal.restoreMargins()
                            mainWindow.showMinimized()
                        }
                    }

                    TopBarButton {
                        id: btnMaximizeRestore
                        btnIconSource: "../images/svg_images/maximize_icon.svg"
                        onClicked: internal.maximizeRestore()
                    }

                    TopBarButton {
                        id: btnClose
                        btnColorClicked: "#f824c3"
                        btnIconSource: "../images/svg_images/close_icon.svg"
                        onClicked: mainWindow.close()
                    }
                }
            }

            Rectangle {
                id: content
                height: 498
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: topBar.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 0

                Rectangle {
                    id: leftMenu
                    y: 70
                    width: 70
                    height: 70
                    color: "#1c1d20"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    focus: true
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0

                    PropertyAnimation{
                        id: animationMenu
                        target: leftMenu
                        property: "width"
                        to: if(leftMenu.width == 70) return 200;
                            else return 70
                        duration: 400
                        easing.type: Easing.InOutQuint
                    }

                    Column {
                        id: columnMenus
                        anchors.fill: parent
                        anchors.bottomMargin: 0
                        spacing: 0

                        LeftMenuButton {
                            id: btnHome
                            width: leftMenu.width
                            text: qsTr("Início")
                            clip: false
                            isActiveMenu: true

                            onClicked: {
                                if(stackedPage != 0){
                                    stackedPage = 0
                                    btnHome.isActiveMenu = true
                                    btnPlot.isActiveMenu = false
                                    btnMultiPlot.isActiveMenu = false
                                    btnInfos.isActiveMenu = false

                                    pageHome.visible = true
                                    pagePlot.visible = false
                                    pageMultiPlot.visible = false
                                    pageInfos.visible = false

                                    labelRightInfo.text = "| Início"
                                }
                            }
                        }

                        LeftMenuButton {
                            id: btnPlot
                            x: 0
                            y: 60
                            width: leftMenu.width
                            text: qsTr("Ajuste")
                            btnIconSource: "../images/svg_images/plot_icon.svg"
                            isActiveMenu: false
                            clip: false

                            onClicked: {
                                if(stackedPage != 1){
                                    stackedPage = 1
                                    btnHome.isActiveMenu = false
                                    btnPlot.isActiveMenu = true
                                    btnMultiPlot.isActiveMenu = false
                                    btnInfos.isActiveMenu = false

                                    pageHome.visible = false
                                    pagePlot.visible = true
                                    pageMultiPlot.visible = false
                                    pageInfos.visible = false

                                    labelRightInfo.text = "| Ajuste"
                                }
                            }
                        }

                        LeftMenuButton {
                            id: btnMultiPlot
                            x: 0
                            y: 120
                            width: leftMenu.width
                            text: qsTr("Vários Ajustes")
                            btnIconSource: "../images/svg_images/multiplot_icon.svg"
                            isActiveMenu: false
                            clip: false

                            onClicked: {
                                if(stackedPage != 2){
                                    stackedPage = 2
                                    btnHome.isActiveMenu = false
                                    btnPlot.isActiveMenu = false
                                    btnMultiPlot.isActiveMenu = true
                                    btnInfos.isActiveMenu = false

                                    pageHome.visible = false
                                    pagePlot.visible = false
                                    pageMultiPlot.visible = true
                                    pageInfos.visible = false

                                    labelRightInfo.text = "| Vários Ajustes"
                                }
                            }
                        }
                    }

                    LeftMenuButton {
                        id: btnInfos
                        x: 0
                        y: 658
                        width: leftMenu.width
                        text: qsTr("Informações")
                        anchors.bottom: parent.bottom
                        btnIconSource: "../images/svg_images/info_icon.svg"
                        anchors.bottomMargin: 0
                        isActiveMenu: false
                        clip: false

                        onClicked: {
                            if(stackedPage != 3){
                                stackedPage = 3
                                btnHome.isActiveMenu = false
                                btnPlot.isActiveMenu = false
                                btnMultiPlot.isActiveMenu = false
                                btnInfos.isActiveMenu = true

                                pageHome.visible = false
                                pagePlot.visible = false
                                pageMultiPlot.visible = false
                                pageInfos.visible = true

                                labelRightInfo.text = "| Informações"
                            }
                        }
                    }
                }

                Rectangle {
                    id: contentPages
                    color: "#40464c"
                    anchors.left: leftMenu.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    clip: true
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 25
                    anchors.topMargin: 0

                    Loader{
                        id: pageHome
                        anchors.fill: parent
                        source: Qt.resolvedUrl("pages/homePage.qml")
                        visible: true
                    }

                    Loader{
                        id: pagePlot
                        anchors.fill: parent
                        source: Qt.resolvedUrl("pages/plotPage.qml")
                        visible: false
                    }

                    Loader{
                        id: pageMultiPlot
                        anchors.fill: parent
                        source: Qt.resolvedUrl("pages/multiPlotPage.qml")
                        visible: false
                    }

                    Loader{
                        id: pageInfos
                        anchors.fill: parent
                        source: Qt.resolvedUrl("pages/infosPage.qml")
                        visible: false
                    }
                    }

                Rectangle {
                    id: rectangle
                    color: "#282c34"
                    anchors.left: leftMenu.right
                    anchors.right: parent.right
                    anchors.top: contentPages.bottom
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0

                    Label {
                        id: labelLeftInfo1
                        color: "#c3cbdd"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.rightMargin: 300
                        anchors.leftMargin: 10
                        anchors.topMargin: 0
                    }

                    MouseArea {
                        id: resizeBottomRight
                        x: 1183
                        y: 0
                        width: 25
                        height: 25
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        cursorShape: Qt.SizeFDiagCursor

                        Image {
                            id: image
                            width: 25
                            height: 25
                            source: "../images/svg_images/resize_icon.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        DragHandler{
                            target: null
                            onActiveChanged: if(active){
                                                 mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                                             }
                        }

                    }
                }
            }
        }
    }

    MouseArea {
        id: resizeLeft
        width: 10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor

        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.LeftEdge) }
        }
    }

    MouseArea {
        id: resizeRight
        width: 10
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor

        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.RightEdge) }
        }
    }

    MouseArea {
        id: resizeBottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: bg.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        cursorShape: Qt.SizeVerCursor

        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.BottomEdge) }
        }
    }

    MouseArea {
        id: resizeTop
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: bg.top
        anchors.bottomMargin: 0
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 0
        cursorShape: Qt.SizeVerCursor

        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.TopEdge) }
        }
    }

    DropShadow{
        anchors.fill: bg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10
        samples: 16
        color: "#80000000"
        source: bg
        z: 0
    }
}
/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
