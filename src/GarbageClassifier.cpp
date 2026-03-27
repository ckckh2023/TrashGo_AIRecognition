#include "include/GarbageClassifier.h"
#include <QCoreApplication>
#include <QDebug>
#include <QFile>
#include <QUrl>
#include <QUrlQuery>
#include <QByteArray>
#include <QNetworkReply>
#include <QTimer>
#include <QJsonObject>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QNetworkRequest>

GarbageClassifier::GarbageClassifier(QObject *parent) : QObject(parent) {
    loadModel();
    m_handler = new IniFileHandler(this);
    m_networkManager = new QNetworkAccessManager(this);
    connect(m_networkManager, &QNetworkAccessManager::finished, this, &GarbageClassifier::onBaiduApiReplyFinished);

    qDebug() << "垃圾分类网络引擎初始化成功(GarbageClassifier-GarbageClassifier)";
}

void GarbageClassifier::loadModel() {
    QString ModelPath = QCoreApplication::applicationDirPath() + "/model/ResNet.onnx";

    if (!QFile::exists(ModelPath)) {
        qDebug() << "ResNet.onnx模型组件缺失(GarbageClassifier-loadModel)";
        emit messageSentError("ResNet.onnx模型组件缺失！");
        m_modelLoaded = false;
        return;
    }

    try {
        m_Net = cv::dnn::readNetFromONNX(QFile::encodeName(ModelPath).toStdString());
        m_Net.setPreferableBackend(cv::dnn::DNN_BACKEND_OPENCV);
        m_Net.setPreferableTarget(cv::dnn::DNN_TARGET_CPU);
        m_modelLoaded = true;
        qDebug() << "垃圾分类模型加载成功(GarbageClassifier-loadModel)";
    }
    catch (const cv::Exception &error) {
        qDebug() << "模型加载失败:" << error.what() << "(GarbageClassifier-loadModel)";
        m_modelLoaded = false;
    }
}

void GarbageClassifier::loadImage() {
    qDebug() << "加载图片：" + ImagePath << "(GarbageClassifier-loadImage)";

    if (!QFile::exists(ImagePath)) {
        qDebug() << "图片不存在：" << ImagePath << "(GarbageClassifier-loadImage)";
        emit messageSentError("图片不存在！");
        return;
    }
    m_cvImage = cv::imread(QFile::encodeName(ImagePath).toStdString());

    if (m_cvImage.empty()) {
        qDebug() << "图片读取失败：" << ImagePath << "(GarbageClassifier-loadImage)";
        emit messageSentError("图片读取失败！");
        return;
    }
    m_hasImage = true;

    cv::Mat RgbImage;
    cv::cvtColor(m_cvImage, RgbImage, cv::COLOR_BGR2RGB);
    m_resultImage = QImage(RgbImage.data,
                           RgbImage.cols,
                           RgbImage.rows,
                           RgbImage.step,
                           QImage::Format_RGB888).copy();

    emit imageChanged();
    emit messageSentInfo("图片加载成功!");
}

void GarbageClassifier::clearImage() {
    ImagePath = "";
    m_hasImage = false;
    m_cvImage.release();
    m_resultImage = QImage();
    m_result.clear();
    m_tips.clear();
    m_garbageType.clear();
    emit resultChanged();
    emit imageChanged();
    emit messageSentInfo("图片清除成功");
}

QString GarbageClassifier::mapToChineseType(int classId) {
    if (MapToChinese.find(classId) != MapToChinese.end()) return MapToChinese[classId];
    else return "未知结果";
}

QString GarbageClassifier::mapToSuggestion(int classId) {
    if (MapToSuggestion.find(classId) != MapToSuggestion.end()) return MapToSuggestion[classId];
    else return "暂无投放建议";
}

void GarbageClassifier::classify() {
    if (!m_hasImage || m_cvImage.empty()) {
        emit messageSentError("请先选择图片!");
        return;
    }

    if (m_handler->provider() == "baidu") {
        QUrlQuery postData;
        QFile ImageFile(ImagePath);
        if (!ImageFile.open(QIODevice::ReadOnly)) {
            emit messageSentError("无法打开图片文件: " + ImageFile.errorString());
            return;
        }
        QByteArray ImageData = ImageFile.readAll();
        ImageFile.close();

        QByteArray Base64Data = ImageData.toBase64();
        //postData.addQueryItem("image", QString::fromLatin1(Base64Data));

        QUrl url("https://znsb2ljfl.api.bdymkt.com/image/waste-sorting/execute");
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded; charset=utf-8");

        QString signature = "AppCode/" + m_handler->currentApiKey();
        request.setRawHeader("X-Bce-Signature", signature.toUtf8());

        QByteArray requestBody = "image=" + QUrl::toPercentEncoding(Base64Data);
        QNetworkReply *baiduReply = m_networkManager->post(request, requestBody);

        baiduReply->setProperty("timeout", 30000);
        QTimer::singleShot(30000, [baiduReply]() { if (baiduReply && baiduReply->isRunning()) baiduReply->abort(); });
        emit messageSentInfo("正在调用百度云API...");
    }
    else if (m_handler->provider() == "local") {
        if (!m_modelLoaded) {
            qDebug() << "模型未加载(GarbageClassifier-classify)";
            emit messageSentError("模型未加载!");
            return;
        }

        try {
            cv::Mat blob = cv::dnn::blobFromImage(m_cvImage,
                                                1.0/255.0,
                                                cv::Size(224, 224),
                                                cv::Scalar(0,0,0),
                                                true, false);

            m_Net.setInput(blob);
            cv::Mat output = m_Net.forward();

            cv::Point maxLoc;
            double maxVal;
            cv::minMaxLoc(output.reshape(1,1), nullptr, &maxVal, nullptr, &maxLoc);

            qDebug() << "分类ID:" << maxLoc.x << ", 置信度:" << maxVal << ", 分类数量:" << Categories.size() << "(GarbageClassifier-classify)";

            int classId = maxLoc.x;
            if (classId < 0 || classId >= Categories.size()) {
                qDebug() << "分类结果无效(GarbageClassifier-classify)";
                emit messageSentError("分类结果无效！");
                return;
            }

            m_confidence = maxVal;
            m_garbageType = mapToChineseType(classId);
            m_result = QString("识别成功！种类：%1").arg(m_garbageType);
            m_tips = mapToSuggestion(classId);

            cv::Mat resultImg = m_cvImage.clone();
            cv::rectangle(resultImg,
                        cv::Point(0,0),
                        cv::Point(250,60),
                        cv::Scalar(0,0,0),
                        cv::FILLED);
            cv::putText(resultImg,
                        Categories[classId].toStdString(),
                        cv::Point(10,40),
                        cv::FONT_HERSHEY_SIMPLEX,
                        1.0, cv::Scalar(0,255,0), 2);

            cv::Mat rgbImage;
            cv::cvtColor(resultImg, rgbImage, cv::COLOR_BGR2RGB);
            m_resultImage = QImage(rgbImage.data,
                                rgbImage.cols,
                                rgbImage.rows,
                                static_cast<int>(rgbImage.step),
                                QImage::Format_RGB888).copy();

            if (m_historyRecord) m_historyRecord->addTrashTables(ImagePath, m_garbageType);

            emit imageChanged();
            emit resultChanged();
            emit messageSentInfo(m_result);
        }
        catch (const cv::Exception& error) {
            qDebug() << "分类失败: " << error.what() << "(GarbageClassifier-classify)";
            emit messageSentError("分类失败!");
        }
    }
    else {
        emit messageSentError("未指定识别方式!");
        return;
    }
}

void GarbageClassifier::onBaiduApiReplyFinished(QNetworkReply* reply) {
    if (!reply) {
        emit messageSentError("百度云没有返回信息！");
        return;
    }

    if (reply->error() != QNetworkReply::NoError) {
        emit messageSentError("网络请求失败: " + reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray responseData = reply->readAll();
    reply->deleteLater();

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(responseData, &parseError);
    if (parseError.error != QJsonParseError::NoError) {
        emit messageSentError("JSON解析失败: " + parseError.errorString());
        return;
    }

    if (!doc.isObject()) {
        emit messageSentError("返回数据不是JSON对象！");
        return;
    }

    QJsonObject obj = doc.object();

    int code = obj["code"].toInt();
    QString msg = obj["msg"].toString();

    if (code != 200) {
        emit messageSentError(QString("API错误 (%1): %2").arg(code).arg(msg));
        return;
    }

    if (!obj.contains("data") || !obj["data"].isObject()) {
        emit messageSentError("返回数据缺少 data 字段");
        return;
    }

    QJsonObject data = obj["data"].toObject();
    if (!data.contains("list") || !data["list"].isArray()) {
        emit messageSentError("返回数据缺少 list 数组");
        return;
    }

    QJsonArray list = data["list"].toArray();
    if (list.isEmpty()) {
        emit messageSentError("识别结果列表为空");
        return;
    }

    QJsonObject firstItem = list[0].toObject();
    m_confidence = firstItem["trust"].toDouble();
    int lajitype = firstItem["lajitype"].toInt();
    QString name = firstItem["name"].toString();
    m_tips = firstItem["lajitip"].toString();

    switch (lajitype) {
        case 0: { m_garbageType = "可回收垃圾"; break; }
        case 1: { m_garbageType = "有害垃圾"; break; }
        case 2: { m_garbageType = "厨余垃圾"; break; }
        case 3: { m_garbageType = "其他垃圾"; break; }
        default: { m_garbageType = "未知结果"; break; }
    }
    m_garbageType += "-" + name;
    m_result = QString("识别成功！种类：%1").arg(m_garbageType);

    if (m_historyRecord) m_historyRecord->addTrashTables(ImagePath, m_garbageType);

    emit resultChanged();
    emit messageSentInfo(m_result);
}
