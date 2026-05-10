#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardPaths>
#include <QScreen>
#include <QIcon>
#include <QQuickWindow>
#include <QSGRendererInterface>
#include <QWindow>
#include "include/GarbageClassifier.h"
#include "include/ImageProcessor.h"
#include "include/HistoryRecord.h"
#include "include/ReturnImage.h"
#include "include/GitHubOnline.h"
#include "include/IniFileHandler.h"
#include "version.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    app.setApplicationName(APP_NAME);
    app.setApplicationVersion(APP_VERSION);

    ImageProcessor ProcessorClass;
    GarbageClassifier GarbageClass;
    HistoryRecord HistoryClass;
    IniFileHandler IniFileClass;
    GitHubOnline GitHubClass;

    QQmlApplicationEngine engine;

    static const QHash<QString, QSGRendererInterface::GraphicsApi> apiMap = {
        {"Direct3D", QSGRendererInterface::Direct3D11},
        {"OpenGL", QSGRendererInterface::OpenGL},
        {"Vulkan", QSGRendererInterface::Vulkan}
    };
    const QString renderer = IniFileClass.renderer();
    auto it = apiMap.constFind(renderer);
    if (it != apiMap.constEnd()) QQuickWindow::setGraphicsApi(it.value());

    QScreen *screen = QGuiApplication::primaryScreen();
    int screenWidth = screen->geometry().width();
    int screenHeight = screen->geometry().height();
    engine.rootContext()->setContextProperty("screenWidth", screenWidth);
    engine.rootContext()->setContextProperty("screenHeight", screenHeight);

    QString appDirPath = QCoreApplication::applicationDirPath();
    QString writablePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    engine.rootContext()->setContextProperty("appDirPath", appDirPath);
    engine.rootContext()->setContextProperty("writablePath", writablePath);
    engine.rootContext()->setContextProperty("initialRenderer", renderer);

    engine.rootContext()->setContextProperty("garbageClassifier", &GarbageClass);
    engine.rootContext()->setContextProperty("imageProcessor", &ProcessorClass);
    engine.rootContext()->setContextProperty("historyRecord", &HistoryClass);
    engine.rootContext()->setContextProperty("iniFileHandler", &IniFileClass);
    engine.rootContext()->setContextProperty("gitHubOnline", &GitHubClass);
    ProcessorClass.setHistoryRecord(&HistoryClass);
    GarbageClass.setHistoryRecord(&HistoryClass);
    engine.addImageProvider(QLatin1String("resultImage"), new ResultImageProvider(&ProcessorClass, &GarbageClass));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("TrashGo", "Main");

    app.setWindowIcon(QIcon(":/icons/assets/images/icon_64.png"));
    return app.exec();
}
