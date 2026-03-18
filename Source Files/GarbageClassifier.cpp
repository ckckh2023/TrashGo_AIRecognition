#include "GarbageClassifier.h"
#include <QCoreApplication>
#include <QDebug>
#include <QFile>

GarbageClassifier::GarbageClassifier(QObject *parent) : QObject(parent) { loadModel(); }

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
    else m_cvImage = cv::imread(QFile::encodeName(ImagePath).toStdString());

    if (m_cvImage.empty()) {
        qDebug() << "图片读取失败：" << ImagePath << "(GarbageClassifier-loadImage)";
        emit messageSentError("图片读取失败！");
        return;
    }
    else m_hasImage = true;

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
    m_garbageType.clear();
    emit resultChanged();
    emit imageChanged();
    emit messageSentInfo("图片清除成功");
}

QString GarbageClassifier::mapToChineseType(int classId) {
    if (MapToChinese.find(classId) != MapToChinese.end()) return MapToChinese[classId];
    else return "其他垃圾";
}

void GarbageClassifier::classify() {
    if (!m_hasImage || m_cvImage.empty()) {
        emit messageSentError("请先选择图片!");
        return;
    }

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
