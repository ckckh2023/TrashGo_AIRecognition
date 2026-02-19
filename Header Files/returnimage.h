#ifndef RETURNIMAGE_H
#define RETURNIMAGE_H

#include <QQuickImageProvider>
#include <QImage>
#include "garbageclassifier.h"
#include "imageprocessor.h"

class ResultImageProvider : public QQuickImageProvider {
public:
    ResultImageProvider(ImageProcessor* processor, GarbageClassifier *classifier);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    ImageProcessor* m_Processor = nullptr;
    GarbageClassifier *m_Classifier = nullptr;
};

#endif // RETURNIMAGE_H
