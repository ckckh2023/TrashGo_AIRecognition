#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "imageprocessor.h"
#include "garbageclassifier.h"
#include "returnimage.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ImageProcessor ProcessorClass;
    GarbageClassifier GarbageClass;

    QQmlApplicationEngine engine;

    engine.addImageProvider(QLatin1String("result"), new ResultImageProvider(&ProcessorClass, &GarbageClass));
    engine.rootContext()->setContextProperty("imageProcessor", &ProcessorClass);
    engine.rootContext()->setContextProperty("garbageClassifier", &GarbageClass);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("OpenCV_attempt", "Main");

    return app.exec();
}
