pragma Singleton

import QtQuick
import FluentUI

QtObject{
    property int displayMode: FluNavigationViewType.Compact
    property url windowIcon: "qrc:/res/image/favicon.ico"
    property url logo: "qrc:/res/image/logo.ico"
    property string releases_latest_uri: "https://github.com/su_dd/MagicBook/releases/latest"
    property string releases_latest_api: "https://api.github.com/repos/su_dd/MagicBook/releases/latest"
}
