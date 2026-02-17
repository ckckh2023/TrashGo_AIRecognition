#include "returnimage.h"

ResultImageProvider::ResultImageProvider(ImageProcessor* processor) : QQuickImageProvider(QQuickImageProvider::Image), m_processor(processor) {}

QImage ResultImageProvider::requestImage (const QString &id, QSize *size, const QSize &requestedSize) {
    Q_UNUSED(id)
    Q_UNUSED(requestedSize)
    if (m_processor) {
        QImage img = m_processor->getResultImage();
        if (size) *size = img.size();
        return img;
    }
    return QImage();
}
