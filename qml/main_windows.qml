import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import Canvas 1.0

import "."
import "controls"
import "colors.js" as Colors

Window {
    id: mainWindow

    minimumWidth: 1000
    minimumHeight: 600
    visibility: Window.AutomaticVisibility
    visible: true
    color: "#00000000"

    // Shortcuts for debug
    Shortcut {
        sequences: ["CTRL+SHIFT+I"]
        onActivated: {
            gdrive.listFiles()
        }
    }
    Shortcut {
        sequences: ["CTRL+SHIFT+O"]
        onActivated: {
            gdrive.uploadFile()
        }
    }

    // Removing Title Bar
    flags: {
        if(os != 'Darwin'){
            Qt.Window | Qt.FramelessWindowHint
        }else{
            Qt.Window
        }
    }

    // Properties
    property string os: ''
    property    int activeBtn: 0
    property   bool isGoogleConnected: false

    // Buttons on leftMenu
    property variant leftMenuBtns: ListModel{
        ListElement{
            page    : 0
            divider : false
            text    : 'Início'
            icon    : '../images/icons/home-36px.svg'
            enabled : true
            active  : true
            visible : true
            canvas  : false
        }
        ListElement{
            page    : 1
            divider : false
            text    : 'Ajuste Simples'
            icon    : '../images/icons/chart-18px.svg'
            enabled : true
            active  : false
            visible : true
            canvas  : true
        }
        ListElement{
            page    : 2
            divider : false
            text    : 'Múltiplos Ajustes'
            icon    : '../images/icons/multichart-18px.svg'
            enabled : true
            active  : false
            visible : true
            canvas  : true
        }
        ListElement{
            page    : 3
            divider : false
            text    : 'Intervalos de Confiança'
            icon    : '../images/icons/calculator-18px.svg'
            enabled : true
            active  : false
            visible : true
            canvas  : true
        }
        ListElement{
            page    : 4
            divider : false
            text    : 'Histogramas'
            icon    : '../images/icons/histogram-18px.svg'
            enabled : true
            active  : false
            visible : false
            canvas  : true
        }
        ListElement{
            page    : 5
            divider : false
            text    : 'Exemplos'
            icon    : '../images/icons/file-18px.svg'
            enabled : true
            active  : false
            visible : false
            canvas  : false
        }
        ListElement{
            page    : -1
            divider : true
            text    : ''
            icon    : ''
            enabled : true
            active  : true
            visible : true
            canvas  : true
        }
        ListElement{
            page    : 6
            divider : false
            text    : 'Informações'
            icon    : '../images/icons/info-18px.svg'
            enabled : true
            active  : false
            visible : true
            canvas  : false
        }
    }

    // MainWindow methods
    function maximizeRestoreWindow(){
        if(mainWindow.visibility == 4) mainWindow.showNormal()
        else mainWindow.showMaximized()
    }

    function switchPage(index, canvas){
        leftMenuBtns.setProperty(activeBtn, 'active', false)
        leftMenuBtns.setProperty(index, 'active', true)
        mainWindow.activeBtn = index

        pagePlots.visible = canvas
    }

    MessageSnackbar{
        id: messageSnackbar
    }

    PopupUpdate {
        id: updatePopup
        anchors.centerIn: parent
        width: mainWindow.width/3
        height: mainWindow.height/2
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Colors.bgColor
        border.color: Colors.bgBorderColor

        Rectangle {
            id: appContainer
            color: "#00000000"
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 1

            GridLayout {
                id: grid
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

                            // Rectangle {
                            //     id: logoContainer
                            //     width: 70
                            //     height: 60
                            //     color: "#00000000"
                            //     Layout.preferredHeight: 60
                            //     Layout.fillHeight: false
                            //     Layout.fillWidth: true

                            //     Image {
                            //         id: logo
                            //         anchors.fill: parent
                            //         cache: true
                            //         smooth: true
                            //         mipmap: true
                            //         autoTransform: true
                            //         asynchronous: false
                            //         source: "../images/main_icon/ATUS_logo_preto.svg"
                            //         sourceSize.height: 55
                            //         sourceSize.width: 55
                            //         fillMode: Image.Pad
                            //     }

                            //     ColorOverlay{
                            //         id: logoOverlay
                            //         source: logo
                            //         cached: false
                            //         color: "#fff"
                            //         anchors.fill: parent
                            //         antialiasing: true
                            //     }
                            // }

                            Rectangle{
                                implicitHeight: 60
                                Layout.fillWidth: true

                                clip: true

                                color: Colors.color1

                                GridLayout{
                                    anchors.fill : parent
                                    columns      : 3
                                    rows         : 2

                                    Rectangle{
                                        implicitWidth: 70
                                        Layout.alignment: Qt.AlignLeft
                                        Layout.fillHeight: true
                                        Layout.rowSpan: 2
                                        color: 'transparent'
                                        Image{
                                            id: avatar
                                            anchors.centerIn: parent
                                            width: 40
                                            height: 40
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                            mipmap: true
                                            source: 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'
                                            layer.enabled: true
                                            layer.effect: OpacityMask {
                                                maskSource: mask
                                            }

                                            Rectangle {
                                                id: mask
                                                anchors.fill: parent
                                                radius: 250
                                                visible: false
                                            }
                                        }
                                    }

                                    Text{
                                        id: nameLabel
                                        Layout.topMargin: 13
                                        Layout.fillWidth: true
                                        text: 'Desconectado'
                                        color: 'white'
                                        elide: Text.ElideRight

                                        font.pointSize: 9
                                        font.bold: true
                                    }

                                    TextButton{
                                        Layout.alignment: Qt.AlignRight
                                        Layout.rightMargin: 5
                                        Layout.rowSpan: 2

                                        texto: isGoogleConnected ? 'SAIR':'ENTRAR'
                                        primaryColor: 'transparent'
                                        hoverColor: 'transparent'
                                        clickColor: 'transparent'
                                        textColor: isGoogleConnected ? '#ba342b':'#48cf4d'
                                        textSize: 11

                                        onClicked: {
                                            if(isGoogleConnected){
                                                gdrive.logout()
                                                // Setting default values
                                                isGoogleConnected = false
                                                nameLabel.text = 'Desconectado'
                                                emailLabel.text = ''
                                                avatar.source = 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'

                                            } else {
                                                gdrive.login()
                                            }
                                        }

                                    }

                                    Text{
                                        id: emailLabel
                                        Layout.bottomMargin: 13
                                        Layout.fillWidth: true
                                        text: ''
                                        color: 'white'
                                        elide: Text.ElideRight

                                        font.pointSize: 8
                                    }
                                }
                            }

                            Repeater{
                                model: leftMenuBtns

                                Component{
                                    id: button
                                    LeftMenuButton {
                                        text            : rowModel.text
                                        btnIconSource   : rowModel.icon
                                        isActiveMenu    : rowModel.active
                                        visible         : rowModel.visible
                                        enabled         : rowModel.enabled
                                        onClicked       : switchPage(rowModel.page, rowModel.canvas)
                                    }
                                }

                                Component{
                                    id: divider
                                    Rectangle {
                                        color: "#00000000"
                                    }
                                }
                                
                                delegate: Loader{
                                    Layout.fillWidth: true
                                    Layout.fillHeight: model.divider ? true:false

                                    sourceComponent: model.divider ? leftMenuBtns.divider:button

                                    property var rowModel: model
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
                }

                ColumnLayout {
                    id: topBar
                    width: 100
                    height: {
                        if(rowBtns.visible) rowBtns.height + topBarDescription.height
                        else topBarDescription.height
                    }
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                    spacing: 0

                    Rectangle {
                        id: rowBtnsBg
                        width: 200
                        height: 35
                        color: Colors.color1
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        visible: os != 'Darwin' ? true:false

                        RowLayout {
                            id: rowBtns
                            anchors.fill: parent
                            Layout.preferredHeight: 35
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            layoutDirection: Qt.LeftToRight
                            transformOrigin: Item.Center
                            spacing: 0

                            Rectangle {
                                id: topBarHandler
                                color: "transparent"
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                DragHandler{
                                    onActiveChanged: if(active){
                                                        mainWindow.startSystemMove() 
                                                        mainWindow.showNormal()
                                                     }
                                }
                                MouseArea{
                                    visible: true
                                    anchors.fill: parent
                                    onDoubleClicked: mainWindow.maximizeRestoreWindow()
                                }
                            }

                            IconTextButton {
                                id: siteBtn
                                width: 150
                                Layout.fillHeight: true
                                Layout.fillWidth: false

                                flat: false
                                texto: "Documentação"
                                iconUrl: qsTr("../../images/icons/ios_share_white_24dp.svg")
                                textSize: 12

                                primaryColor: 'transparent'
                                clickColor: Colors.c_button_active
                                hoverColor: Colors.c_button_hover

                                onClicked: Qt.openUrlExternally("https://highelodevs.github.io/Analysis-Tool-for-Undergrad-Students/")
                            }

                            IconButton{
                                id: gitHubBtn
                                Layout.preferredWidth: 40
                                Layout.fillHeight: true
                                Layout.fillWidth: false
                                iconUrl: '../../images/icons/github-36px.svg'
                                iconWidth: 22
                                r: 0

                                primaryColor: 'transparent'
                                clickColor: Colors.c_button_active
                                hoverColor: Colors.c_button_hover
                                iconColor: '#fff'

                                onClicked: Qt.openUrlExternally("https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS")
                            }

                            IconButton{
                                id: minimizeBtn
                                Layout.preferredWidth: 40
                                Layout.fillHeight: true
                                Layout.fillWidth: false
                                iconUrl: '../../images/svg_images/minimize_icon.svg'
                                iconWidth: 15
                                r: 0

                                primaryColor: 'transparent'
                                clickColor: Colors.c_button_active
                                hoverColor: Colors.c_button_hover
                                iconColor: '#fff'

                                onClicked: mainWindow.showMinimized()
                            }

                            IconButton{
                                id: maximizeBtn
                                Layout.preferredWidth: 40
                                Layout.fillHeight: true
                                Layout.fillWidth: false

                                property string restoreIcon: '../../images/svg_images/restore_icon.svg'
                                property string maximizeIcon: '../../images/svg_images/maximize_icon.svg'

                                iconUrl: mainWindow.visibility == 4 ? restoreIcon:maximizeIcon
                                iconWidth: 15
                                r: 0

                                primaryColor: 'transparent'
                                clickColor: Colors.c_button_active
                                hoverColor: Colors.c_button_hover
                                iconColor: '#fff'

                                onClicked: maximizeRestoreWindow()
                            }

                            IconButton{
                                id: closeBtn
                                Layout.preferredWidth: 40
                                Layout.fillHeight: true
                                Layout.fillWidth: false
                                iconUrl: '../../images/svg_images/close_icon.svg'
                                iconWidth: 15
                                r: 0

                                primaryColor: 'transparent'
                                clickColor: '#ff0000'
                                hoverColor: '#aa0000'
                                iconColor: '#fff'

                                onClicked: mainWindow.close()
                            }
                        }
                    }

                    Rectangle {
                        id: topBarDescription
                        Layout.preferredHeight: 25
                        Layout.fillWidth: true
                        color: Colors.color2
                    }


                }

                Rectangle {
                    id: content
                    color: "#00000000"
                    clip: false
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: true

                    GridLayout {
                        id: layoutContent
                        anchors.fill: parent
                        columnSpacing: 0
                        rowSpacing: 0
                        rows: 2
                        columns: 1

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
                                    visible: mainWindow.activeBtn == 0 ? true:false
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    clip: true
                                    source: Qt.resolvedUrl("pages/homePage.qml")
                                }

                                Loader{
                                    id: pageExamples
                                    visible: mainWindow.activeBtn == 5 ? true:false
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    clip: true
                                    source: Qt.resolvedUrl("pages/examplesPage.qml")
                                }

                                Loader{
                                    id: pageInfos
                                    visible: mainWindow.activeBtn == 6 ? true:false
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    clip: true
                                    source: Qt.resolvedUrl("pages/infosPage.qml")
                                }

                                GridLayout {
                                    id: pagePlots
                                    Layout.margins: 10
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    property variant pages: [
                                                        pagePlot.visible,
                                                        pageMultiPlot.visible,
                                                        pageCalculadora.visible,
                                                        pageHistograma,
                                                    ]

                                    visible: false
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
                                            visible: mainWindow.activeBtn == 1 ? true:false
                                        }

                                        Loader{
                                            id: pageMultiPlot
                                            anchors.fill: parent
                                            source: Qt.resolvedUrl("pages/multiPlotPage.qml")
                                            visible: mainWindow.activeBtn == 2 ? true:false
                                        }

                                        Loader{
                                            id: pageCalculadora
                                            anchors.fill: parent
                                            source: Qt.resolvedUrl("pages/calculadoraPage.qml")
                                            visible: mainWindow.activeBtn == 3 ? true:false
                                        }

                                        Loader{
                                            id: pageHistograma
                                            anchors.fill: parent
                                            source: Qt.resolvedUrl("pages/histogramaPage.qml")
                                            visible: mainWindow.activeBtn == 4 ? true:false
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
                                                        canvas.back();
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
                                                        canvas.home();
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
                                                        canvas.forward();
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
                                                        canvas.pan();
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
                                                        canvas.zoom();
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
                                                    }

                                                    FileDialog{
                                                        id: fileSaver
                                                        title: "Escolha um local para salvar a figura"
                                                        folder: shortcuts.desktop
                                                        selectExisting: false
                                                        nameFilters: ["Arquivo de imagem .png (*.png)", "Arquivo de imagem .jpg (*.jpg)", "Arquivo de imagem .pdf (*.pdf)", "Arquivo de imagem .svg (*.svg)"]
                                                        onAccepted: {
                                                            canvas.savePlot(fileSaver.fileUrl, bgTransparent.checked)
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
                                                height: 25
                                                color: Colors.color2
                                                Layout.fillWidth: true

                                                TextInput {
                                                    id: location
                                                    readOnly: true
                                                    text: canvas.coordinates
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: 10
                                                    color: Colors.fontColor
                                                }

                                                RowLayout{
                                                    anchors.top: parent.top
                                                    anchors.bottom: parent.bottom
                                                    anchors.right: parent.right
                                                    anchors.rightMargin: 10
                                                    anchors.bottomMargin: 0
                                                    anchors.topMargin: 0
                                                    CheckBoxCustom{
                                                        id: bgTransparent
                                                        Layout.fillHeight: true
                                                        texto: 'Fundo transparente'
                                                        checked: false
                                                    }
                                                    IconTextButton{
                                                        id: copyClipboard
                                                        Layout.fillHeight: true
                                                        texto: 'Copiar'
                                                        textSize: 11
                                                        primaryColor: 'transparent'
                                                        hoverColor: 'transparent'
                                                        clickColor: 'transparent'
                                                        iconColor: enabled ? '#fff':'#707070'
                                                        textColor: enabled ? '#fff':'#707070'
                                                        iconUrl: '../../images/icons/content_copy_black_24dp.svg'
                                                        iconWidth: 17
                                                        enabled: !bgTransparent.checked
                                                        visible: {
                                                            if(mainWindow.os != 'Windows') false
                                                            else true
                                                        }

                                                        onClicked: {
                                                            canvas.copyToClipboard()
                                                        }
                                                    }
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
                            Layout.preferredHeight: 20
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
                                height: 20
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.rightMargin: 0
                                anchors.bottomMargin: 0
                                cursorShape: Qt.SizeFDiagCursor

                                Image {
                                    id: image
                                    width: 25
                                    height: 20
                                    source: "../images/svg_images/resize_icon.svg"
                                    autoTransform: false
                                    smooth: true
                                    mipmap: false
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

    Connections{
        target: messageHandler

        function onShowMessage(message, type){
            messageSnackbar.message = message
            messageSnackbar.type    = type
            if(type === 'error'){
                messageSnackbar.timer = 8000
            } else if(type === 'warn'){
                messageSnackbar.timer = 4000
            }
            messageSnackbar.open()
        }
    }

    Connections{
        target: gdrive
        
        function onInformationSignal(ownersInfo){
            emailLabel.text = ownersInfo['user']['emailAddress']
            nameLabel.text  = ownersInfo['user']['displayName']
            
            if (ownersInfo['user']['photoLink'] != undefined){
                avatar.source = ownersInfo['user']['photoLink']
            }

            isGoogleConnected = true
        }
    }

    Component.onCompleted: {
        updater.checkUpdate()
        labelVersion.text = updater.getVersion()
        os = updater.getOS()
        gdrive.tryLogin()
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
