import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import MagicBook
import "../component"

FluWindow {

    id:window
    width: 800
    height: 600
    minimumWidth: 520
    minimumHeight: 200
    launchMode: FluWindowType.SingleInstance
    onInitArgument:
        (arg)=>{
            window.title = arg.title
            loader.setSource(arg.url,{animationEnabled:false})
        }
    FluLoader{
        id: loader
        anchors.fill: parent
    }
}
