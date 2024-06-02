pragma Singleton

import QtQuick
import FluentUI

FluObject{

    property var navigationView
    property var paneItemMenu

    id:footer_items

    FluPaneItemSeparator{}

    FluPaneItem{
        title:qsTr("About")
        icon:FluentIcons.Contact
        onTapListener:function(){
            FluRouter.navigate("/about")
        }
    }

    FluPaneItem{
        title:qsTr("Settings")
        menuDelegate: paneItemMenu
        icon:FluentIcons.Settings
        url:"qrc:/qml/page/Settings.qml"
        onTap:{
            navigationView.push(url)
        }
    }

}
