import QtQuick
import QtQuick.Controls
import FluentUI
import MagicBook

FluStatusLayout {
    property url source: ""
    property bool lazy: false
    property var argument
    color:"transparent"
    id:control
    onErrorClicked: {
        reload()
    }
    Component.onCompleted: {
        if(!lazy){
            loader.source = control.source
        }
    }
    FileWatcher{
        id:watcher
        onFileChanged: {
            control.reload()
        }
    }

    FluLoader{
        id:loader
        anchors.fill: parent
        onStatusChanged: {
            control.statusMode = FluStatusLayoutType.Success
        }
    }

    function setSource(url, argument={}) {
        console.log("hotloader setSource: ", url)
        watcher.path = url;
        control.source = url;
        control.argument = argument;
        reload();
    }

    function reload(){
        var timestamp = Date.now();
        loader.setSource(control.source+"?"+timestamp, control.argument)
        // loader.source = control.source+"?"+timestamp
    }
    function itemLodaer(){
        return loader
    }
}
