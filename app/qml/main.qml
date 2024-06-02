import QtQuick
import QtQuick.Window
import FluentUI

FluWindow {
    width: 640
    height: 480
    minimumWidth: 320
    minimumHeight: 240
    title: qsTr("MagicBook")

    Column{
        anchors.centerIn: parent
        spacing: 15
        Image{
            width: 60
            height: 60
            source: "qrc:/res/image/logo.ico"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        FluText{
            text: qsTr("Welcome to FluentUI")
            anchors.horizontalCenter: parent.horizontalCenter
            font: FluTextStyle.Title
        }
        FluFilledButton{
            text: qsTr("Learn FluentUI")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                Qt.openUrlExternally("https://space.bilibili.com/275661059")
            }
        }
    }

    Row{
        anchors{
            bottom: parent.bottom
            bottomMargin: 14
            horizontalCenter: parent.horizontalCenter
        }
        FluText{
            text: qsTr("Author's WeChat ID: ")
        }
        FluText{
            text: "FluentUI"
            color: FluTheme.fontSecondaryColor
        }
    }

}
