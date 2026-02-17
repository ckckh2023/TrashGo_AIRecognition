#ifndef RETURNIMAGE_H
#define RETURNIMAGE_H

#include <QQuickImageProvider>
#include "imageprocessor.h"

class ResultImageProvider : public QQuickImageProvider {
public:
    explicit ResultImageProvider(ImageProcessor* processor);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    ImageProcessor* m_processor = nullptr;
};

#endif // RETURNIMAGE_H
