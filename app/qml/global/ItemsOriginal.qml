pragma Singleton

import QtQuick
import FluentUI

FluObject{

    property var navigationView
    property var paneItemMenu

    function rename(item, newName){
        if(newName && newName.trim().length>0){
            item.title = newName;
        }
    }

    FluPaneItem{
        id:item_home
        count: 9
        title: qsTr("Home")
        menuDelegate: paneItemMenu
        infoBadge: FluBadge{
            count: item_home.count
        }
        icon: FluentIcons.Home
        url: "qrc:/qml/page/Home.qml"
        onTap: {
            if(navigationView.getCurrentUrl()){
                item_home.count = 0
            }
            navigationView.push(url)
        }
    }

    FluPaneItemExpander{
        title: qsTr("Other")
        icon: FluentIcons.Shop
        FluPaneItem{
            title: qsTr("OpenGL")
            menuDelegate: paneItemMenu
            url: "qrc:/qml/page/Other/OpenGL.qml"
            onTap: { navigationView.push(url) }
        }
        FluPaneItem{
            title: qsTr("QRCode")
            menuDelegate: paneItemMenu
            url: "qrc:/qml/page/Other/QRCode.qml"
            onTap: { navigationView.push(url) }
        }
        FluPaneItem{
            title: qsTr("Tour")
            menuDelegate: paneItemMenu
            url: "qrc:/qml/page/Other/Tour.qml"
            onTap: { navigationView.push(url) }
        }
        FluPaneItem{
            title: qsTr("Timeline")
            menuDelegate: paneItemMenu
            url: "qrc:/qml/page/Other/Timeline.qml"
            onTap: { navigationView.push(url) }
        }
        FluPaneItem{
            title: qsTr("Captcha")
            menuDelegate: paneItemMenu
            url: "qrc:/qml/page/Other/Captcha.qml"
            onTap: { navigationView.push(url) }
        }
        FluPaneItem{
            title: qsTr("Network")
            menuDelegate: paneItemMenu
            url: "qrc:/qml/page/Other/Network.qml"
            onTap: { navigationView.push(url) }
        }
        FluPaneItem{
            id: item_other
            title: qsTr("Remote Loader")
            menuDelegate: paneItemMenu
            count: 99
            infoBadge:FluBadge{
                count: item_other.count
                color: Qt.rgba(82/255,196/255,26/255,1)
            }
            url: "qrc:/qml/page/Other/RemoteLoader.qml"
            onTap: {
                item_other.count = 0
                navigationView.push("qrc:/qml/page/Other/RemoteLoader.qml")
            }
        }
        FluPaneItem{
            title: qsTr("Hot Loader")
            onTapListener: function(){
                FluRouter.navigate("/hotload")
            }
        }
        FluPaneItem{
            title: qsTr("Test Crash")
            onTapListener: function(){
                AppInfo.testCrash()
            }
            Component.onCompleted: {
                visible = FluTools.isWin()
            }
        }
    }

    function getRecentlyAddedData(){
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem && item.extra && item.extra.recentlyAdded){
                arr.push(item)
            }
        }
        arr.sort(function(o1,o2){ return o2.extra.order-o1.extra.order })
        return arr
    }

    function getRecentlyUpdatedData(){
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem && item.extra && item.extra.recentlyUpdated){
                arr.push(item)
            }
        }
        return arr
    }

    function getSearchData(){
        if(!navigationView){
            return
        }
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem){
                if (item.parent instanceof FluPaneItemExpander)
                {
                    arr.push({title:`${item.parent.title} -> ${item.title}`,key:item.key})
                }
                else
                    arr.push({title:item.title,key:item.key})
            }
        }
        return arr
    }

    function startPageByItem(data){
        navigationView.startPageByItem(data)
    }

}
