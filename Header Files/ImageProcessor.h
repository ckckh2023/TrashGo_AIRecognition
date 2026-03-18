#ifndef IMAGEPROCESSOR_H
#define IMAGEPROCESSOR_H

#include "HistoryRecord.h"

#include <QObject>
#include <QImage>
#include <QString>

#include <opencv2/opencv.hpp>

class ImageProcessor : public QObject {
    Q_OBJECT

    Q_PROPERTY(int faceCount READ faceCount NOTIFY resultChanged)
    Q_PROPERTY(bool hasImage READ hasImage NOTIFY imageChanged)

public:
    explicit ImageProcessor(QObject *parent = nullptr);
    void setHistoryRecord(HistoryRecord *record) { m_historyRecord = record; }

    int faceCount() const { return m_faceCount; }
    bool hasImage() const { return m_hasImage; }

    Q_INVOKABLE void loadImage();
    Q_INVOKABLE void clearImage();
    Q_INVOKABLE void detectFaces();
    Q_INVOKABLE QImage resultImage() const { return m_resultImage; }
    Q_INVOKABLE void loadPath(const QString& NewPath) { ImagePath = NewPath; }

signals:
    void imageChanged();
    void resultChanged();
    void messageSentInfo(const QString &info);
    void messageSentError(const QString &error);
    void messageSentWarn(const QString &warn);

private:
    bool m_hasImage = false;
    QString ImagePath = "";
    cv::Mat m_cvImage;
    QImage m_resultImage;

    bool m_modelLoaded = false;

    int m_faceCount = 0;
    cv::CascadeClassifier m_faceCascade;

    HistoryRecord *m_historyRecord = nullptr;
};


#endif // IMAGEPROCESSOR_H
