#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "imageprocessor.h"
#include "garbageclassifier.h"
#include "historyrecord.h"
#include "returnimage.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ImageProcessor ProcessorClass;
    GarbageClassifier GarbageClass;
    HistoryRecord HistoryClass;

    QQmlApplicationEngine engine;

    QString appDirPath = QCoreApplication::applicationDirPath();
    engine.rootContext()->setContextProperty("appDirPath", appDirPath);

    ProcessorClass.setHistoryRecord(&HistoryClass);
    GarbageClass.setHistoryRecord(&HistoryClass);
    engine.addImageProvider(QLatin1String("result"), new ResultImageProvider(&ProcessorClass, &GarbageClass));
    engine.rootContext()->setContextProperty("historyRecord", &HistoryClass);
    engine.rootContext()->setContextProperty("imageProcessor", &ProcessorClass);
    engine.rootContext()->setContextProperty("garbageClassifier", &GarbageClass);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("TrashGo", "Main");

    return app.exec();
}
