#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "imageprocessor.h"
#include "returnimage.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ImageProcessor ProcessorClass;

    QQmlApplicationEngine engine;

    engine.addImageProvider(QLatin1String("result"), new ResultImageProvider(&ProcessorClass));
    engine.rootContext()->setContextProperty("imageProcessor", &ProcessorClass);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("OpenCV_attempt", "Main");

    return app.exec();
}
