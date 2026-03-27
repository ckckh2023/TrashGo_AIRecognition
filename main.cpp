#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>
#include <QIcon>
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

    QQmlApplicationEngine engine;

    QScreen *screen = QGuiApplication::primaryScreen();
    int screenWidth = screen->geometry().width();
    int screenHeight = screen->geometry().height();
    engine.rootContext()->setContextProperty("screenWidth", screenWidth);
    engine.rootContext()->setContextProperty("screenHeight", screenHeight);

    QString appDirPath = QCoreApplication::applicationDirPath();
    engine.rootContext()->setContextProperty("appDirPath", appDirPath);

    engine.rootContext()->setContextProperty("garbageClassifier", &GarbageClass);
    engine.rootContext()->setContextProperty("imageProcessor", &ProcessorClass);
    engine.rootContext()->setContextProperty("historyRecord", &HistoryClass);
    engine.rootContext()->setContextProperty("iniFileHandler", &IniFileClass);
    ProcessorClass.setHistoryRecord(&HistoryClass);
    GarbageClass.setHistoryRecord(&HistoryClass);
    engine.addImageProvider(QLatin1String("resultImage"), new ResultImageProvider(&ProcessorClass, &GarbageClass));

    qmlRegisterType<GitHubOnline>("GitHubModule", 1, 0, "GitHubOnline");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("TrashGo", "Main");

    app.setWindowIcon(QIcon(":/icons/images/icon_64.png"));
    return app.exec();
}
