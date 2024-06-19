import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import "global"

FluLauncher {
    id: app
    Connections{
        target: FluTheme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(FluTheme.darkMode)
        }
    }
    Connections{
        target: FluApp
        function onUseSystemAppBarChanged(){
            SettingsHelper.saveUseSystemAppBar(FluApp.useSystemAppBar)
        }
    }
    Connections{
        target: TranslateHelper
        function onCurrentChanged(){
            SettingsHelper.saveLanguage(TranslateHelper.current)
        }
    }
    Component.onCompleted: {
        Network.openLog = false
        Network.setInterceptor(function(param){
            param.addHeader("Token","000000000000000000000")
        })
        FluApp.init(app, Qt.locale(TranslateHelper.current))
        // FluApp.windowIcon = GlobalModel.windowIcon
        FluApp.useSystemAppBar = SettingsHelper.getUseSystemAppBar()
        FluTheme.darkMode = SettingsHelper.getDarkMode()
        FluTheme.animationEnabled = true
        FluRouter.routes = {
            "/"             :"MainWindow",
            "/about"        :"qrc:/qml/windows/AboutWindow.qml",
            "/crash"        :"qrc:/qml/windows/CrashWindow.qml",
            "/hotload"      :"qrc:/qml/windows/HotloadWindow.qml",
            "/pageWindow"   :"qrc:/qml/windows/PageWindow.qml"
        }
        var args = Qt.application.arguments
        if(args.length>=2 && args[1].startsWith("-crashed=")) {
            FluRouter.navigate("/crash",{crashFilePath:args[1].replace("-crashed=","")})
        }else{
            FluRouter.navigate("/")
        }
    }
}
