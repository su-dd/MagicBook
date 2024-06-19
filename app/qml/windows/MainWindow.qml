import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import Qt.labs.platform
import FluentUI
import MagicBook
import "../component"
import "../global"

FluWindow {
    id:window
    title: qsTr("MagicBook")
    width: 1000
    height: 680
    minimumWidth: 680
    minimumHeight: 200
    launchMode: FluWindowType.SingleTask
    fitsAppBarWindows: true

    appBar: FluAppBar {
        width: window.width
        height: 30
        showDark: true
        darkClickListener:(button)=>handleDarkChanged(button)
        closeClickListener: ()=>{dialog_close.open()}
        z:7
    }

    FluEvent{
        name: "checkUpdate"
        onTriggered: {
            checkUpdate(false)
        }
    }

    Component.onCompleted: {
        checkUpdate(true)
    }

    Component.onDestruction: {
        FluRouter.exit()
    }

    Component{
        id: nav_item_right_menu
        FluMenu{
            width: 186
            FluMenuItem{
                text: qsTr("Open in Separate Window")
                font: FluTextStyle.Caption
                onClicked: {
                    FluRouter.navigate("/pageWindow",{title:modelData.title,url:modelData.url})
                }
            }
        }
    }

    NavigationView{
        id:nav_view
        width: parent.width
        height: parent.height
        z:999
        // Stack模式，每次切换都会将页面压入栈中，随着栈的页面增多，消耗的内存也越多，内存消耗多就会卡顿，这时候就需要按返回将页面pop掉，释放内存。该模式可以配合FluPage中的launchMode属性，设置页面的启动模式
        // pageMode: FluNavigationViewType.Stack
        // NoStack模式，每次切换都会销毁之前的页面然后创建一个新的页面，只需消耗少量内存
        // pageMode: FluNavigationViewType.NoStack
        topPadding:{
            if(window.useSystemAppBar){
                return 0
            }
            return FluTools.isMacos() ? 20 : 0
        }
        displayMode: GlobalModel.displayMode
        logo: GlobalModel.logo
        title:qsTr("MagicBook")
        onLogoClicked:{
            showSuccess(qsTr("Click Time"))
        }
        items: ItemsOriginal
        footerItems:ItemsFooter
        Component.onCompleted: {
            ItemsOriginal.navigationView = nav_view
            ItemsOriginal.paneItemMenu = nav_item_right_menu
            ItemsFooter.navigationView = nav_view
            ItemsFooter.paneItemMenu = nav_item_right_menu
            window.setHitTestVisible(nav_view.buttonMenu)
            window.setHitTestVisible(nav_view.buttonBack)
            window.setHitTestVisible(nav_view.imageLogo)
            setCurrentIndex(0)
        }
    }

    Component{
        id: com_reveal
        CircularReveal{
            id: reveal
            target: window.contentItem
            anchors.fill: parent
            onAnimationFinished:{
                //动画结束后释放资源
                loader_reveal.sourceComponent = undefined
            }
            onImageChanged: {
                changeDark()
            }
        }
    }

    SystemTrayIcon {
        id:system_tray
        visible: true
        icon.source: GlobalModel.windowIcon
        tooltip: qsTr("MagicBook")
        menu: Menu {
            MenuItem {
                text: qsTr("Quit")
                onTriggered: {
                    FluRouter.exit()
                }
            }
        }
        onActivated:
            (reason)=>{
                if(reason === SystemTrayIcon.Trigger){
                    window.show()
                    window.raise()
                    window.requestActivate()
                }
            }
    }

    Timer{
        id: timer_window_hide_delay
        interval: 150
        onTriggered: {
            window.hide()
        }
    }

    FluContentDialog{
        id: dialog_close
        title: qsTr("Quit")
        message: qsTr("Are you sure you want to exit the program?")
        negativeText: qsTr("Minimize")
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.NeutralButton | FluContentDialogType.PositiveButton
        onNegativeClicked: {
            system_tray.showMessage(qsTr("Friendly Reminder"),
                                    qsTr("MagicBook is hidden from the tray, click on the tray to activate the window again"));
            timer_window_hide_delay.restart()
        }
        positiveText: qsTr("Quit")
        neutralText: qsTr("Cancel")
        onPositiveClicked:{
            FluRouter.exit(0)
        }
    }

    FluLoader{
        id:loader_reveal
        anchors.fill: parent
    }

    function distance(x1,y1,x2,y2) {
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }

    function handleDarkChanged(button){
        if(!FluTheme.animationEnabled || window.fitsAppBarWindows === false) {
            changeDark()
        }else{
            if(loader_reveal.sourceComponent){
                return
            }
            loader_reveal.sourceComponent = com_reveal
            var target = window.contentItem
            var pos = button.mapToItem(target,0,0)
            var mouseX = pos.x
            var mouseY = pos.y
            var radius = Math.max(
                        distance(mouseX,mouseY,0,0),
                        distance(mouseX,mouseY,target.width,0),
                        distance(mouseX,mouseY,0,target.height),
                        distance(mouseX,mouseY,target.width,target.height)
                        )
            var reveal = loader_reveal.item
            reveal.start(
                        reveal.width*Screen.devicePixelRatio,
                        reveal.height*Screen.devicePixelRatio,
                        Qt.point(mouseX,mouseY),
                        radius
                        )
        }
    }

    function changeDark(){
        if(FluTheme.dark){
            FluTheme.darkMode = FluThemeType.Light
        }else{
            FluTheme.darkMode = FluThemeType.Dark
        }
    }

    NetworkCallable{
        id:callable
        property bool silent: true
        onStart: {
            console.debug("start check update...")
        }
        onFinish: {
            console.debug("check update finish")
            FluEventBus.post("checkUpdateFinish");
        }
        onSuccess:
            (result)=>{
                var data = JSON.parse(result)
                console.debug("current version "+AppInfo.version)
                console.debug("new version "+data.tag_name)
                if(data.tag_name !== AppInfo.version){
                    dialog_update.newVerson =  data.tag_name
                    dialog_update.body = data.body
                    dialog_update.open()
                }else{
                    if(!silent){
                        showInfo(qsTr("The current version is already the latest"))
                    }
                }
            }
        onError:
            (status,errorString)=>{
                if(!silent){
                    showError(qsTr("The network is abnormal"))
                }
                console.debug(status+";"+errorString)
            }
    }

    function checkUpdate(silent) {
        callable.silent = silent
        Network.get(GlobalModel.releases_latest_api)
        .go(callable)
    }
}
