#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QWindow>
#include "imageprocessor.h"
#include "garbageclassifier.h"
#include "historyrecord.h"
#include "githubonline.h"
#include "returnimage.h"
#include "version.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName(APP_NAME);
    app.setApplicationVersion(APP_VERSION);

    ImageProcessor ProcessorClass;
    GarbageClassifier GarbageClass;
    HistoryRecord HistoryClass;
    GitHubOnline GitHubClass;

    QQmlApplicationEngine engine;

    QString appDirPath = QCoreApplication::applicationDirPath();
    engine.rootContext()->setContextProperty("appDirPath", appDirPath);

    ProcessorClass.setHistoryRecord(&HistoryClass);
    GarbageClass.setHistoryRecord(&HistoryClass);
    engine.addImageProvider(QLatin1String("result"), new ResultImageProvider(&ProcessorClass, &GarbageClass));
    engine.rootContext()->setContextProperty("historyRecord", &HistoryClass);
    engine.rootContext()->setContextProperty("imageProcessor", &ProcessorClass);
    engine.rootContext()->setContextProperty("garbageClassifier", &GarbageClass);
    engine.rootContext()->setContextProperty("githubOnline", &GitHubClass);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("TrashGo", "Main");

    const auto rootObjects = engine.rootObjects();
    if (!rootObjects.isEmpty()) {
        QObject *root = rootObjects.first();
        if (auto *window = qobject_cast<QWindow*>(root)) window->setTitle("TrashGo信息识别");
        else root->setProperty("title", "TrashGo信息识别");
        }

    app.setWindowIcon(QIcon(":/icons/images/icon_64.png"));

    return app.exec();
}
