import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    anchors.fill: parent
    Rectangle {
        id: rectangle
        color: "#40464c"
        anchors.fill: parent

        TextArea {
            id: textEdit1
            color: "#ffffff"
            text: "<html lang=\"en\">\n  <head>\n    <meta charset=\"utf-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n    <script src=\"https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js\" referrerpolicy=\"origin\"></script>\n    <script>\n      tinymce.init({\n        selector: '#mytextarea'\n      });\n    </script>\n  </head>\n  <body>\n  <h1>TinyMCE Quick Start Guide</h1>\n    <form method=\"post\">\n      <textarea id=\"mytextarea\">Hello, World!</textarea>\n    </form>\n  </body>\n</html>"
            anchors.fill: parent
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            selectByMouse: true
            mouseSelectionMode: TextInput.SelectWords
            selectByKeyboard: true
            renderType: Text.NativeRendering
            cursorVisible: true
            readOnly: true
            activeFocusOnPress: false
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally('https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS')
        }
    }

}


