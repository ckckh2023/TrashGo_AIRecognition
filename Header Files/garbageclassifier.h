#ifndef GARBAGECLASSIFIER_H
#define GARBAGECLASSIFIER_H

#include <QObject>
#include <QImage>
#include <QString>
#include <QStringList>

#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

class GarbageClassifier : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString result READ result NOTIFY resultChanged)
    Q_PROPERTY(QString garbageType READ garbageType NOTIFY resultChanged)
    Q_PROPERTY(double confidence READ confidence NOTIFY resultChanged)

public:
    explicit GarbageClassifier(QObject *parent = nullptr);

    Q_INVOKABLE void loadImage(const QString& FilePath);
    Q_INVOKABLE void classify();
    Q_INVOKABLE bool isModelLoader() const { return m_ModelLoaded; }
    Q_INVOKABLE QImage resultImage() const { return m_ResultImage; }

    QString result() const { return m_Result; }
    QString garbageType() const { return m_GarbageType; }
    double confidence() const { return m_Confidence; }

signals:
    void resultChanged();
    void imageChanged();
    void messageSent(const QString &msg);

private:
    void loadModel();
    QString mapToChineseType(int classId);

    cv::Mat m_CvImage;
    QImage m_ResultImage;
    cv::dnn::Net m_Net;
    bool m_ModelLoaded = false;

    QString m_Result;
    QString m_GarbageType;
    double m_Confidence = 0.0;

    QStringList m_Categories = {"cardboard", "glass", "metal", "paper", "plastic", "trash"};
};

#endif // GARBAGECLASSIFIER_H
