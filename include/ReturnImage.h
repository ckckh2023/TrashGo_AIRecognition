#ifndef RETURNIMAGE_H
#define RETURNIMAGE_H

#include <QQuickImageProvider>
#include <QImage>
#include "GarbageClassifier.h"
#include "ImageProcessor.h"

class ResultImageProvider : public QQuickImageProvider {
public:
    ResultImageProvider(ImageProcessor* processor, GarbageClassifier *classifier);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    ImageProcessor* m_processor = nullptr;
    GarbageClassifier *m_classifier = nullptr;
};

#endif // RETURNIMAGE_H
