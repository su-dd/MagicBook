import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import MagicBook
import "../../component"

FluContentPage{

    title: qsTr("OpenGL")

    FluFrame{
        anchors.fill: parent
        OpenGLItem{
            anchors.fill: parent
            SequentialAnimation on t {
                NumberAnimation { to: 1; duration: 2500; easing.type: Easing.InQuad }
                NumberAnimation { to: 0; duration: 2500; easing.type: Easing.OutQuad }
                loops: Animation.Infinite
                running: true
            }
        }
    }

}
