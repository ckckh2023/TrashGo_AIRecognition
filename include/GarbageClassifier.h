#ifndef GARBAGECLASSIFIER_H
#define GARBAGECLASSIFIER_H

#include "include/HistoryRecord.h"
#include "include/IniFileHandler.h"

#include <QObject>
#include <QImage>
#include <QString>
#include <QStringList>
#include <QNetworkAccessManager>
#include <QMap>

#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

class GarbageClassifier : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString getTips READ getTips NOTIFY resultChanged)
    Q_PROPERTY(QString result READ result NOTIFY resultChanged)
    Q_PROPERTY(QString details READ details NOTIFY resultChanged)
    Q_PROPERTY(QString garbageType READ garbageType NOTIFY resultChanged)
    Q_PROPERTY(bool hasImage READ hasImage NOTIFY imageChanged)

public:
    explicit GarbageClassifier(QObject *parent = nullptr);
    void setHistoryRecord(HistoryRecord *record) { m_historyRecord = record; }
    void setIniFileHandler(IniFileHandler *handler) { m_iniHandler = handler; }

    Q_INVOKABLE void loadImage();
    Q_INVOKABLE void clearImage();
    Q_INVOKABLE void classify();
    Q_INVOKABLE QImage resultImage() const { return m_resultImage; }
    Q_INVOKABLE void loadPath(const QString &NewPath) { ImagePath = NewPath; }

    bool hasImage() const { return m_hasImage; }
    QString getTips() const { return m_tips; }
    QString result() const { return m_result; }
    QString garbageType() const { return m_garbageType; }

signals:
    void imageChanged();
    void resultChanged();
    void messageSentInfo(const QString &info);
    void messageSentError(const QString &error);
    void messageSentWarn(const QString &warn);

private slots:
    void onBaiduApiReplyFinished(QNetworkReply* reply);

private:
    void loadModel();

    bool m_hasImage = false;
    QString ImagePath = "";
    cv::Mat m_cvImage;
    QImage m_resultImage;

    bool m_modelLoaded = false;
    cv::dnn::Net m_Net;

    QString m_tips;
    QString m_result;
    QString m_garbageType;
    double m_confidence = 0.0;

    HistoryRecord *m_historyRecord = nullptr;
    IniFileHandler *m_iniHandler = nullptr;
    QNetworkAccessManager *m_networkManager;
};

#endif // GARBAGECLASSIFIER_H
