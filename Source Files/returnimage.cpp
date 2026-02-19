#include "returnimage.h"
#include <QDebug>

ResultImageProvider::ResultImageProvider(ImageProcessor* processor, GarbageClassifier *classifier) : QQuickImageProvider(QQuickImageProvider::Image), m_Processor(processor), m_Classifier(classifier) {
    qDebug() << "ResultImageProvider 初始化";
}

QImage ResultImageProvider::requestImage (const QString &id, QSize *size, const QSize &requestedSize) {
    QImage result;

    if (id.startsWith("faces")) result = m_Processor ? m_Processor->resultImage() : QImage();
    else if (id.startsWith("trash")) result = m_Classifier ? m_Classifier->resultImage() : QImage();
    else result = m_Processor ? m_Processor->resultImage() : QImage();

    if (result.isNull()) {
        qDebug() << "警告: 请求的图像为空, id:" << id;
        result = QImage(100, 100, QImage::Format_RGB888);
        result.fill(Qt::gray);
    }

    if (size) *size = result.size();
    if (requestedSize.isValid() && requestedSize != result.size()) return result.scaled(requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);

    return result;
}
