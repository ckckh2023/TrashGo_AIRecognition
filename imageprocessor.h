#ifndef IMAGEPROCESSOR_H
#define IMAGEPROCESSOR_H

#include <QObject>
#include <QImage>
#include <QString>
#include <opencv2/opencv.hpp>

class ImageProcessor : public QObject {
    Q_OBJECT

    Q_PROPERTY(int faceCount READ faceCount NOTIFY faceCountChanged)

public:
    explicit ImageProcessor(QObject *parent = nullptr);

    QImage getResultImage() const { return m_ResultImage; }
    int faceCount() const { return m_FaceCount; }

public slots:
    void loadImage(const QString& FilePath);
    void detectFaces();

signals:
    void imageChanged();
    void faceCountChanged();
    void messageSent(const QString& msg);

private:
    QImage m_ResultImage;
    cv::Mat m_CvImage;
    int m_FaceCount = 0;
    cv::CascadeClassifier m_FaceCascade;
};

#endif // IMAGEPROCESSOR_H
