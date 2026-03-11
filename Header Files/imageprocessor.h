#ifndef IMAGEPROCESSOR_H
#define IMAGEPROCESSOR_H

#include "historyrecord.h"
#include <QObject>
#include <QImage>
#include <QString>

#include <opencv2/opencv.hpp>

class ImageProcessor : public QObject {
    Q_OBJECT

    Q_PROPERTY(int faceCount READ faceCount NOTIFY faceCountChanged)
    Q_PROPERTY(bool hasImage READ hasImage NOTIFY imageChanged)

public:
    explicit ImageProcessor(QObject *parent = nullptr);
    void setHistoryRecord(HistoryRecord *record) { m_historyRecord = record; }

    int faceCount() const { return m_FaceCount; }
    bool hasImage() const { return m_HasImage; }

    Q_INVOKABLE QImage resultImage() const { return m_ResultImage; }
    Q_INVOKABLE void loadImage();
    Q_INVOKABLE void clearImage();
    Q_INVOKABLE void detectFaces();
    Q_INVOKABLE void loadPath(const QString& FilePath) { ImagePath = FilePath; }

signals:
    void imageChanged();
    void faceCountChanged();

    void messageSent(const QString& msg);

private:
    QImage m_ResultImage;
    cv::Mat m_CvImage;
    int m_FaceCount = 0;
    cv::CascadeClassifier m_FaceCascade;

    bool m_HasImage = false;
    QString ImagePath;

    HistoryRecord *m_historyRecord = nullptr;
};

#endif // IMAGEPROCESSOR_H
