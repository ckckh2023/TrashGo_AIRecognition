#include "garbageclassifier.h"
#include "historyrecord.h"
#include <QCoreApplication>
#include <QDebug>
#include <QFile>

GarbageClassifier::GarbageClassifier(QObject *parent) : QObject(parent) {
    qDebug() << "垃圾分类器初始化...";
    loadModel();
}

void GarbageClassifier::loadModel() {
    QString ModelPath = QCoreApplication::applicationDirPath() + "/mobilenet.onnx";

    if (!QFile::exists(ModelPath)) {
        qDebug() << "模型文件不存在:" << ModelPath;
        emit messageSent("请将 mobilenet.onnx 放到程序目录");
        m_ModelLoaded = false;
        return;
    }

    try {
        m_Net = cv::dnn::readNetFromONNX(ModelPath.toStdString());
        m_Net.setPreferableBackend(cv::dnn::DNN_BACKEND_OPENCV);
        m_Net.setPreferableTarget(cv::dnn::DNN_TARGET_CPU);
        m_ModelLoaded = true;
        qDebug() << "垃圾分类模型加载成功!";
    }
    catch (const cv::Exception &e) {
        qDebug() << "模型加载失败:" << e.what();
        m_ModelLoaded = false;
    }
}

void GarbageClassifier::loadImage() {
    qDebug() << "加载图片：" + ImagePath;

    if (!QFile::exists(ImagePath)) {
        emit messageSent("文件不存在：" + ImagePath);
        return;
    }

    m_CvImage = cv::imread(QFile::encodeName(ImagePath).toStdString());
    if (m_CvImage.empty()) {
        emit messageSent("无法读取图片");
        return;
    }

    cv::Mat RgbImage;
    cv::cvtColor(m_CvImage, RgbImage, cv::COLOR_BGR2RGB);
    m_ResultImage = QImage(RgbImage.data, RgbImage.cols, RgbImage.rows, RgbImage.step, QImage::Format_RGB888).copy();

    m_HasImage = true;

    emit imageChanged();
    emit messageSent("图片加载成功");
}

void GarbageClassifier::classify() {
    if (!m_HasImage || m_CvImage.empty()) {
        emit messageSent("请先选择图片");
        return;
    }

    if (!m_ModelLoaded) {
        emit messageSent("模型未加载");
        return;
    }
    try {
        cv::Mat blob = cv::dnn::blobFromImage(m_CvImage, 1.0/255.0, cv::Size(224, 224), cv::Scalar(0,0,0), true, false);

        m_Net.setInput(blob);
        cv::Mat output = m_Net.forward();

        cv::Point maxLoc;
        double maxVal;
        cv::minMaxLoc(output.reshape(1,1), nullptr, &maxVal, nullptr, &maxLoc);

        qDebug() << "分类ID:" << maxLoc.x << ", 置信度:" << maxVal;
        qDebug() << "分类数量:" << m_Categories.size();

        int classId = maxLoc.x;
        if (classId < 0 || classId >= m_Categories.size()) {
            emit messageSent("分类结果无效");
            return;
        }

        m_Confidence = maxVal;
        m_GarbageType = mapToChineseType(classId);
        m_Result = QString("识别成功！种类：%1").arg(m_GarbageType)/*.arg(m_Confidence * 10, 0, 'f', 2)*/;

        cv::Mat resultImg = m_CvImage.clone();
        cv::rectangle(resultImg, cv::Point(0,0), cv::Point(250,60), cv::Scalar(0,0,0), cv::FILLED);
        cv::putText(resultImg, m_Categories[classId].toStdString(), cv::Point(10,40), cv::FONT_HERSHEY_SIMPLEX, 1.0, cv::Scalar(0,255,0), 2);

        cv::Mat rgbImage;
        cv::cvtColor(resultImg, rgbImage, cv::COLOR_BGR2RGB);
        m_ResultImage = QImage(rgbImage.data, rgbImage.cols, rgbImage.rows, static_cast<int>(rgbImage.step), QImage::Format_RGB888).copy();

        HistoryRecord TrashHistory;
        TrashHistory.addTrashTables(ImagePath, m_GarbageType);

        emit imageChanged();
        emit resultChanged();
        emit messageSent(m_Result);
    }
    catch (const cv::Exception& e) { emit messageSent(QString("分类失败: %1").arg(e.what())); }
}

QString GarbageClassifier::mapToChineseType(int classId) {
    if (m_MapToChinese.find(classId) != m_MapToChinese.end()) return m_MapToChinese[classId];
    else return "其他垃圾";
}

void GarbageClassifier::clearImage() {
    m_HasImage = false;

    emit imageChanged();
    emit messageSent("图片清除成功");
}
