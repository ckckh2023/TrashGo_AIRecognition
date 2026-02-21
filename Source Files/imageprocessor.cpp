#include "imageprocessor.h"
#include <QCoreApplication>
#include <QDebug>
#include <QFile>
#include <QDir>

ImageProcessor::ImageProcessor(QObject *parent) : QObject(parent) {
    qDebug() << "人脸分类器创建成功！";

    QString xmlPath = QCoreApplication::applicationDirPath() + "/haarcascade_frontalface_default.xml";
    if (!m_FaceCascade.load(xmlPath.toStdString())) {
        qDebug() << "错误: 无法加载人脸分类器!";
        emit messageSent("请将 haarcascade_frontalface_default.xml 放在程序目录");
        return;
    }
}

void ImageProcessor::loadImage(const QString& FilePath) {
    qDebug() << "加载图片：" + FilePath;
    if (!QFile::exists(FilePath)) {
        emit messageSent("文件不存在：" + FilePath);
        return;
    }

    m_CvImage = cv::imread(FilePath.toStdString());
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

void ImageProcessor::detectFaces() {
    if (m_CvImage.empty()) {
        emit messageSent("请先加载图片");
        return;
    }

    cv::Mat Image = m_CvImage.clone();
    cv::Mat Gray;
    cv::cvtColor(Image, Gray, cv::COLOR_BGR2GRAY);

    std::vector<cv::Rect> Faces;
    m_FaceCascade.detectMultiScale(Gray, Faces, 1.1, 3, 0, cv::Size(30, 30));

    for (size_t i = 0; i < Faces.size(); ++i) {
        cv::rectangle(Image, Faces[i], cv::Scalar(0, 255, 0), 2);
        cv::putText(Image, "Face" + std::to_string(i + 1), cv::Point(Faces[i].x, Faces[i].y - 10), cv::FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0, 255, 0), 1);
    }

    m_FaceCount = Faces.size();
    cv::Mat RgbImage;
    cv::cvtColor(Image, RgbImage, cv::COLOR_BGR2RGB);
    m_ResultImage = QImage(RgbImage.data, RgbImage.cols, RgbImage.rows, RgbImage.step, QImage::Format_RGB888).copy();

    emit imageChanged();
    emit faceCountChanged();
    emit messageSent(QString("检测到 %1 张人脸").arg(m_FaceCount));
}
