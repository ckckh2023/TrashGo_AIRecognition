#ifndef IMAGEPROCESSOR_H
#define IMAGEPROCESSOR_H

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
    Q_INVOKABLE QImage resultImage() const { return m_ResultImage; }
    int faceCount() const { return m_FaceCount; }
    bool hasImage() const { return m_HasImage; }

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

    bool m_HasImage = false;
};

#endif // IMAGEPROCESSOR_H
