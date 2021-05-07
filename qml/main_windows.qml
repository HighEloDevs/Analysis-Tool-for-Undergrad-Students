import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import Canvas 1.0

import "controls"
import "."
import "colors.js" as Colors

Window {
    id: mainWindow
    width: 1500
    height: 800

    minimumWidth: 1000
    minimumHeight: 600

    visible: true
    color: "#00000000"
    property alias btnCalcWidth: btnCalc.width
    property alias labelRightInfoText: labelRightInfo.text

    // Removing Title Bar
    flags: Qt.Window | Qt.FramelessWindowHint

    // Properties
    property int windowStatus: 0
    property int windowMargin: 0
    property int stackedPage: 0

    PopupSaveFig{
        width: 300
        height: 400
        id: poputSaveFig
    }

    PopupUpdate {
        id: updatePopup
        anchors.centerIn: parent
        width: mainWindow.width/3
        height: mainWindow.height/2
    }

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
        color: Colors.bgColor
        border.color: Colors.bgBorderColor
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
                color: Colors.color1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Rectangle {
                    id: topBarDescription
                    y: 21
                    height: 25
                    color: Colors.color2
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 70
                    anchors.bottomMargin: 0

                    Label {
                        id: labelLeftInfo
                        color: Colors.fontColor
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
                        color: Colors.fontColor
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
                    id: logoContainer
                    color: "#00000000"
                    anchors.left: parent.left
                    anchors.right: topBarDescription.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0

                    Image {
                        id: logo
                        anchors.fill: parent
                        cache: true
                        smooth: true
                        mipmap: true
                        autoTransform: true
                        asynchronous: false
                        source: "../images/main_icon/ATUS_logo_preto.svg"
                        sourceSize.height: 55
                        sourceSize.width: 55
                        fillMode: Image.Pad
                    }

                    ColorOverlay{
                        id: logoOverlay
                        source: logo
                        cached: false
                        color: "#fff"
                        anchors.fill: parent
                        antialiasing: true
                    }
                }

                Rectangle {
                    id: titleBar
                    height: 35
                    color: "#00000000"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 285
                    anchors.leftMargin: 70
                    anchors.topMargin: 0

                    DragHandler{
                        onActiveChanged: if(active){
                                             mainWindow.startSystemMove()
                                             internal.ifMaximizedWindowRestore()
                                         }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onDoubleClicked: internal.maximizeRestore()
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
                        color: Colors.fontColor
                        text: qsTr("Analysis Tool for Undergrad Students")
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
                    height: 35
                    anchors.left: titleBar.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 0
                    transformOrigin: Item.Center
                    anchors.rightMargin: 0
                    anchors.topMargin: 0

                    IconTextButton {
                        id: siteBtn

                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0

                        flat: false
                        texto: "Documentação"
                        iconUrl: qsTr("../../images/icons/ios_share_white_24dp.svg")

                        primaryColor: 'transparent'
                        clickColor: Colors.c_button_active
                        hoverColor: Colors.c_button_hover

                        onClicked: Qt.openUrlExternally("https://highelodevs.github.io/Analysis-Tool-for-Undergrad-Students/")
                    }

                    IconButton{
                        width: 35
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                        r: 0
                        iconUrl: '../../images/icons/github-36px.svg'
                        iconWidth: 22

                        primaryColor: 'transparent'
                        clickColor: Colors.c_button_active
                        hoverColor: Colors.c_button_hover
                        iconColor: '#fff'

                        onClicked: Qt.openUrlExternally("https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS")
                    }

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
                        btnColorClicked: "#f00"
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

                GridLayout {
                    id: layoutContent
                    anchors.fill: parent
                    columnSpacing: 0
                    rowSpacing: 0
                    rows: 2
                    columns: 2

                    Rectangle {
                        id: leftMenu
                        width: 70
                        height: 70
                        color: Colors.color1
                        z: 1
                        focus: true
                        Layout.fillWidth: false
                        Layout.preferredWidth: 70
                        Layout.fillHeight: true
                        Layout.rowSpan: 2

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            z: 1

                            onEntered:{
                                animationMenu.running = true
                            }

                            onExited:{
                                animationMenu.running = true
                            }

                            ColumnLayout {
                                id: layout_menu
                                anchors.fill: parent
                                spacing: 0
                                z: 1
                                clip: true

                                LeftMenuButton {
                                    id: btnHome
                                    width: leftMenu.width
                                    text: qsTr("Início")
                                    Layout.fillWidth: true
                                    clip: true
                                    isActiveMenu: true

                                    onClicked: {
                                        if(stackedPage != 0){
                                            stackedPage = 0
                                            btnHome.isActiveMenu = true
                                            btnPlot.isActiveMenu = false
                                            btnMultiPlot.isActiveMenu = false
                                            btnCalc.isActiveMenu = false
                                            btnHist.isActiveMenu = false
                                            // btnExamples.isActiveMenu = false
                                            btnInfos.isActiveMenu = false

                                            pageHome.visible = true
                                            pagePlots.visible = false
                                            // pageExamples.visible = false
                                            pageInfos.visible = false

                                            labelRightInfo.text = "| Início"
                                        }
                                    }
                                }

                                LeftMenuButton {
                                    id: btnPlot
                                    width: leftMenu.width
                                    text: qsTr("Ajuste")
                                    Layout.fillWidth: false
                                    btnIconSource: "../images/icons/chart-18px.svg"
                                    isActiveMenu: false
                                    clip: false

                                    onClicked: {
                                        if(stackedPage != 1){
                                            stackedPage = 1
                                            btnHome.isActiveMenu = false
                                            btnPlot.isActiveMenu = true
                                            btnMultiPlot.isActiveMenu = false
                                            btnCalc.isActiveMenu = false
                                            btnHist.isActiveMenu = false
                                            // btnExamples.isActiveMenu = false
                                            btnInfos.isActiveMenu = false

                                            pageHome.visible = false
                                            pagePlots.visible = true
                                            // pageExamples.visible = false
                                            pageInfos.visible = false

                                            pagePlot.visible = true
                                            pageMultiPlot.visible = false
                                            pageCalculadora.visible = false
                                            pageHistograma.visible = false

                                            labelRightInfo.text = "| Ajuste"
                                        }
                                    }
                                }

                                LeftMenuButton {
                                    id: btnMultiPlot
                                    width: leftMenu.width
                                    text: qsTr("Vários Ajustes")
                                    Layout.fillWidth: false
                                    btnIconSource: "../images/icons/multichart-18px.svg"
                                    isActiveMenu: false
                                    clip: false

                                    onClicked: {
                                        if(stackedPage != 2){
                                            stackedPage = 2
                                            btnHome.isActiveMenu = false
                                            btnPlot.isActiveMenu = false
                                            btnMultiPlot.isActiveMenu = true
                                            btnCalc.isActiveMenu = false
                                            btnHist.isActiveMenu = false
                                            // btnExamples.isActiveMenu = false
                                            btnInfos.isActiveMenu = false

                                            pageHome.visible = false
                                            pagePlots.visible = true
                                            // pageExamples.visible = false
                                            pageInfos.visible = false
                                            pagePlot.visible = false
                                            pageMultiPlot.visible = true
                                            pageCalculadora.visible = false
                                            pageHistograma.visible = false

                                            labelRightInfo.text = "| Vários Ajustes"
                                        }
                                    }
                                }

                                LeftMenuButton {
                                    id: btnCalc
                                    width: leftMenu.width
                                    text: qsTr("Intervalos de confiança")
                                    clip: false
                                    btnIconSource: "../images/icons/calculator-18px.svg"
                                    isActiveMenu: false

                                    onClicked: {
                                        if(stackedPage != 3){
                                            stackedPage = 3
                                            btnHome.isActiveMenu = false
                                            btnPlot.isActiveMenu = false
                                            btnMultiPlot.isActiveMenu = false
                                            btnCalc.isActiveMenu = true
                                            btnHist.isActiveMenu = false
                                            // btnExamples.isActiveMenu = false
                                            btnInfos.isActiveMenu = false

                                            pageHome.visible = false
                                            pagePlots.visible = true
                                            // pageExamples.visible = false
                                            pageInfos.visible = false

                                            pagePlot.visible = false
                                            pageMultiPlot.visible = false
                                            pageCalculadora.visible = true
                                            pageHistograma.visible = false

                                            labelRightInfo.text = "| Calculadora de Intervalos de Confiança"
                                        }
                                    }
                                }

                                LeftMenuButton {
                                    id: btnHist
                                    width: leftMenu.width
                                    text: qsTr("Histogramas")
                                    Layout.fillWidth: true
                                    clip: false
                                    btnIconSource: "../images/icons/histogram-18px.svg"
                                    isActiveMenu: false

                                    onClicked: {
                                        if(stackedPage != 4){
                                            stackedPage = 4
                                            btnHome.isActiveMenu = false
                                            btnPlot.isActiveMenu = false
                                            btnMultiPlot.isActiveMenu = false
                                            btnCalc.isActiveMenu = false
                                            btnHist.isActiveMenu = true
                                            // btnExamples.isActiveMenu = false
                                            btnInfos.isActiveMenu = false

                                            pageHome.visible = false
                                            pagePlots.visible = true
                                            // pageExamples.visible = false
                                            pageInfos.visible = false
                                            pagePlot.visible = false
                                            pageMultiPlot.visible = false
                                            pageCalculadora.visible = false
                                            pageHistograma.visible = true

                                            labelRightInfo.text = "| Histogramas"
                                        }
                                    }
                                }

                                // LeftMenuButton {
                                //     id: btnExamples
                                //     btnIconSource: "../images/icons/file-18px.svg"
                                //     width: leftMenu.width
                                //     text: qsTr("Exemplos")
                                //     Layout.fillWidth: true
                                //     isActiveMenu: false
                                //     clip: false

                                //     onClicked: {
                                //         if(stackedPage != 5){
                                //             stackedPage = 5
                                //             btnHome.isActiveMenu = false
                                //             btnPlot.isActiveMenu = false
                                //             btnMultiPlot.isActiveMenu = false
                                //             btnCalc.isActiveMenu = false
                                //             btnHist.isActiveMenu = false
                                //             btnExamples.isActiveMenu = true
                                //             btnInfos.isActiveMenu = false

                                //             pageHome.visible = false
                                //             pagePlots.visible = false
                                //             pageExamples.visible = true
                                //             pageInfos.visible = false

                                //             labelRightInfo.text = "| Exemplos"
                                //         }
                                //     }
                                // }

                                Rectangle {
                                    id: rectangle1
                                    width: leftMenu.width
                                    height: 200
                                    color: "#00000000"
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                }

                                LeftMenuButton {
                                    id: btnInfos
                                    width: leftMenu.width
                                    text: qsTr("Informações")
                                    Layout.fillWidth: true
                                    btnIconSource: "../images/icons/info-18px.svg"
                                    isActiveMenu: false
                                    clip: false

                                    onClicked: {
                                        if(stackedPage != 6){
                                            stackedPage = 6
                                            btnHome.isActiveMenu = false
                                            btnPlot.isActiveMenu = false
                                            btnMultiPlot.isActiveMenu = false
                                            btnCalc.isActiveMenu = false
                                            btnHist.isActiveMenu = false
                                            // btnExamples.isActiveMenu = false
                                            btnInfos.isActiveMenu = true

                                            pageHome.visible = false
                                            pagePlots.visible = false
                                            // pageExamples.visible = false
                                            pageInfos.visible = true

                                            labelRightInfo.text = "| Informações"
                                        }
                                    }
                                }
                            }
                        }

                        PropertyAnimation{
                            id: animationMenu
                            target: leftMenu
                            property: "width"
                            to: if(leftMenu.width == 70) return 300;
                                else return 70
                            duration: 300
                            easing.type: Easing.OutQuint
                        }

                        Column {
                            id: columnMenus
                            anchors.fill: parent
                            clip: true
                            anchors.bottomMargin: 0
                            spacing: 0
                        }

                    }

                    Rectangle {
                        id: contentPages
                        color: Colors.color3
                        z: 0
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        GridLayout {
                            id: pagesLayout
                            anchors.fill: parent
                            columns: 2
                            rows: 1
                            columnSpacing: 0
                            rowSpacing: 0

                            Loader{
                                id: pageHome
                                source: Qt.resolvedUrl("pages/homePage.qml")
                                clip: true
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                visible: true
                            }

                            Loader{
                                id: pageExamples
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                source: Qt.resolvedUrl("pages/examplesPage.qml")
                                visible: false
                            }

                            Loader{
                                id: pageInfos
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                source: Qt.resolvedUrl("pages/infosPage.qml")
                                clip: false
                                visible: false
                            }

                            GridLayout {
                                id: pagePlots
                                width: 100
                                height: 100
                                visible: false
                                Layout.margins: 10
                                Layout.preferredWidth: -1
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                rows: 1
                                columns: 2
                                columnSpacing: 10
                                rowSpacing: 0

                                Rectangle {
                                    id: optionsLayout
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

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
                                        visible: true
                                    }
                                    
                                    Loader{
                                        id: pageCalculadora
                                        anchors.fill: parent
                                        source: Qt.resolvedUrl("pages/calculadoraPage.qml")
                                        visible: false
                                    }

                                    Loader{
                                        id: pageHistograma
                                        anchors.fill: parent
                                        source: Qt.resolvedUrl("pages/histogramaPage.qml")
                                        visible: false
                                    }
                                }

                                Rectangle {
                                    id: canvasLayout
                                    visible: true
                                    radius: 0
                                    Layout.preferredWidth: -1
                                    Layout.leftMargin: 0
                                    Layout.rightMargin: 0
                                    Layout.bottomMargin: 0
                                    Layout.topMargin: 0
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    ColumnLayout {
                                        id: rightPanel_layout
                                        x: 0
                                        y: -692
                                        anchors.fill: parent
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: 0

                                        Rectangle {
                                            id: toolBar
                                            height: 60
                                            color: Colors.color1
                                            Layout.fillWidth: true

                                            TabButton{
                                                id: backBtn
                                                y: 0
                                                width: toolBar.width/6
                                                text: "Voltar"
                                                anchors.left: homeBtn.right
                                                anchors.leftMargin: 0

                                                onClicked: {
                                                    displayBridge.back();
                                                }

                                            }

                                            TabButton{
                                                id: homeBtn
                                                y: 0
                                                width: toolBar.width/6
                                                text: "Resetar"
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.left: parent.left
                                                anchors.leftMargin: 0

                                                onClicked: {
                                                    displayBridge.home();
                                                }

                                            }

                                            TabButton {
                                                id: fowardBtn
                                                y: 0
                                                width: toolBar.width/6
                                                text: "Avançar"
                                                anchors.left: backBtn.right
                                                anchors.leftMargin: 0

                                                onClicked: {
                                                    displayBridge.forward();
                                                }
                                            }

                                            TabButton {
                                                id: panBtn
                                                y: 0
                                                width: toolBar.width/6
                                                text: "Mover"
                                                anchors.left: fowardBtn.right
                                                anchors.leftMargin: 0
                                                checkable: true
                                                isActiveMenu: false

                                                onClicked: {
                                                    if (zoomBtn.checked) {
                                                        zoomBtn.checked = false;
                                                        zoomBtn.isActiveMenu = false;
                                                    }
                                                    displayBridge.pan();
                                                    panBtn.isActiveMenu = true;
                                                }

                                            }

                                            TabButton {
                                                id: zoomBtn
                                                y: 0
                                                width: toolBar.width/6
                                                text: "Zoom"
                                                anchors.left: panBtn.right
                                                anchors.leftMargin: 0
                                                checkable: true
                                                isActiveMenu: false

                                                onClicked: {
                                                    if (panBtn.checked) {
                                                        // toggle pan off
                                                        panBtn.checked = false;
                                                        panBtn.isActiveMenu = false;
                                                    }
                                                    zoomBtn.isActiveMenu = true;
                                                    displayBridge.zoom();
                                                }
                                            }

                                            TabButton {
                                                id: saveBtn
                                                y: 0
                                                width: toolBar.width/6
                                                text: "Salvar"
                                                anchors.left: zoomBtn.right
                                                anchors.leftMargin: 0
                                                checkable: true
                                                isActiveMenu: false

                                                onClicked:{
                                                    fileSaver.open()
                                                    // poputSaveFig.open()
                                                }

                                                FileDialog{
                                                    id: fileSaver
                                                    title: "Escolha um local para salvar a figura"
                                                    folder: shortcuts.desktop
                                                    selectExisting: false
                                                    nameFilters: ["Arquivo de imagem .png (*.png)", "Arquivo de imagem .jpg (*.jpg)", "Arquivo de imagem .pdf (*.pdf)", "Arquivo de imagem .svg (*.svg)"]
                                                    onAccepted: {
                                                        plot.savePlot(fileSaver.fileUrl)
                                                    }
                                                }
                                            }
                                        }

                                        Rectangle {
                                            id: bg_canvas
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                           FigureCanvas {
                                                   id: mplView
                                                   objectName : "canvasPlot"
                                                   dpi_ratio: Screen.devicePixelRatio
                                                   anchors.fill: parent
                                           }
                                        }

                                        Rectangle {
                                            id: footer
                                            height: 20
                                            color: Colors.color2
                                            Layout.fillWidth: true

                                            TextInput {
                                                id: location
                                                readOnly: true
                                                text: displayBridge.coordinates
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.left: parent.left
                                                anchors.leftMargin: 10
                                                color: Colors.fontColor
                                            }
                                        }

                                    }
                                }


                            }
                        }
                    }

                    Rectangle {
                        id: footer1
                        color: Colors.color2
                        Layout.preferredHeight: 25
                        Layout.fillWidth: true

                        Label {
                            id: labelVersion
                            color: Colors.fontColor
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
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
        color: Colors.bgBorderColor
        source: bg
        z: 0
    }

    Connections{
        target: updater
        function onShowUpdate(infos){
            updatePopup.updateLog = infos['body']
            updatePopup.version = infos['tag_name']
            updatePopup.exeLink = infos['assets'][0]['browser_download_url']
            updatePopup.tarLink = infos['tarball_url']
            updatePopup.zipLink = infos['zipball_url']
            updatePopup.open()
        }
    }

    Component.onCompleted: {
        updater.checkUpdate()
        labelVersion.text = updater.getVersion()
        mainWindow.showMaximized()
    }
}


