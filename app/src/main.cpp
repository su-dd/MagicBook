#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QQmlComponent>

#include "Version.h"
#include "AppInfo.h"

#include "src/component/CircularReveal.h"
#include "src/component/FileWatcher.h"
#include "src/component/FpsItem.h"
#include "src/component/OpenGLItem.h"

#include "src/helper/Log.h"
#include "src/helper/SettingsHelper.h"
#include "src/helper/TranslateHelper.h"
#include "src/helper/Network.h"
#ifdef WIN32
#include "app_dmp.h"
#endif


int main(int argc, char *argv[])
{
    const char *uri = "MagicBook";
    int major = 1;
    int minor = 0;
#ifdef WIN32
    // 崩溃后保存dump
    ::SetUnhandledExceptionFilter(MyUnhandledExceptionFilter);
    qputenv("QT_QPA_PLATFORM","windows:darkmode=2");
#endif

#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
#else
    qputenv("QT_QUICK_CONTROLS_STYLE","Default");
#endif


    QGuiApplication::setOrganizationName("SuLong");
    // QGuiApplication::setOrganizationDomain("https://zhuzichu520.github.io");
    QGuiApplication::setApplicationName("MagicBook");
    QGuiApplication::setApplicationDisplayName("MagicBook");
    QGuiApplication::setApplicationVersion(APPLICATION_VERSION);
    QGuiApplication::setQuitOnLastWindowClosed(false);
    SettingsHelper::getInstance()->init(argv);
    Log::setup(argv,uri);

#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
#endif
#if (QT_VERSION < QT_VERSION_CHECK(6, 0, 0))
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
#endif
#endif
    QGuiApplication app(argc, argv);

    //@uri MagicBook
    qmlRegisterType<CircularReveal>(uri, major, minor, "CircularReveal");
    qmlRegisterType<FileWatcher>(uri, major, minor, "FileWatcher");
    qmlRegisterType<FpsItem>(uri, major, minor, "FpsItem");
    qmlRegisterType<NetworkCallable>(uri,major,minor,"NetworkCallable");
    qmlRegisterType<NetworkParams>(uri,major,minor,"NetworkParams");
    qmlRegisterType<OpenGLItem>(uri,major,minor,"OpenGLItem");
    qmlRegisterUncreatableMetaObject(NetworkType::staticMetaObject, uri, major, minor, "NetworkType", "Access to enums & flags only");

    QQmlApplicationEngine engine;
    TranslateHelper::getInstance()->init(&engine);
    engine.rootContext()->setContextProperty("AppInfo",AppInfo::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper",SettingsHelper::getInstance());
    engine.rootContext()->setContextProperty("TranslateHelper",TranslateHelper::getInstance());
    engine.rootContext()->setContextProperty("Network",Network::getInstance());

    // const QUrl url(QStringLiteral("qrc:/qml/App.qml"));
    // QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
    //     &app, [url](QObject *obj, const QUrl &objUrl) {
    //         if (!obj && url == objUrl)
    //             QCoreApplication::exit(-1);
    //     }, Qt::QueuedConnection);
    // engine.load(url);


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MagicBook", "App");

    const int exec = QGuiApplication::exec();
    if (exec == 931) // 重新启动
    {
        QProcess::startDetached(qApp->applicationFilePath(), qApp->arguments());
    }
    return exec;
}
