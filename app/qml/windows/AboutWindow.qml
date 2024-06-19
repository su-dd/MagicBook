import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import "../component"

FluWindow {
    id: window
    title: "关于"
    width: 600
    height: 580
    fixSize: true
    launchMode: FluWindowType.SingleTask

    ColumnLayout{
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        spacing: 5

        RowLayout{
            Layout.topMargin: 10
            Layout.leftMargin: 15
            spacing: 14
            FluText{
                text: "MagicBook"
                font: FluTextStyle.Title
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        FluRouter.navigate("/")
                    }
                }
            }
            FluText{
                text:"v%1".arg(AppInfo.version)
                font: FluTextStyle.Body
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                text: "作者："
            }
            FluText{
                text: "呆呆"
                Layout.alignment: Qt.AlignBottom
            }
        }

    }
}
