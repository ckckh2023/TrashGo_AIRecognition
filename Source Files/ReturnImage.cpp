#include "ReturnImage.h"
#include <QDebug>

ResultImageProvider::ResultImageProvider(ImageProcessor* processor, GarbageClassifier *classifier) : QQuickImageProvider(QQuickImageProvider::Image), m_processor(processor), m_classifier(classifier) {
    qDebug() << "图像返回器初始化成功(ResultImageProvider-ResultImageProvider)";
}

QImage ResultImageProvider::requestImage (const QString &id, QSize *size, const QSize &requestedSize) {
    QImage resultImage;

    if (id.startsWith("faces")) resultImage = m_processor ? m_processor->resultImage() : QImage();
    else if (id.startsWith("trash")) resultImage = m_classifier ? m_classifier->resultImage() : QImage();

    if (resultImage.isNull()) {
        qDebug() << "请求的图像为空, id:" << id << "(ResultImageProvider-requestImage)";
        resultImage = QImage(100, 100, QImage::Format_RGB888);
        resultImage.fill(Qt::gray);
    }

    if (size) *size = resultImage.size();
    if (requestedSize.isValid() && requestedSize != resultImage.size()) return resultImage.scaled(requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);

    return resultImage;
}
