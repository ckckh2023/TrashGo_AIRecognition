#include "ImageProcessor.h"
#include <QCoreApplication>
#include <QDebug>
#include <QFile>
#include <QDir>

ImageProcessor::ImageProcessor(QObject *parent) : QObject(parent) {
    QString xmlPath = QCoreApplication::applicationDirPath() + "/model/haarcascade_frontalface_default.xml";

    if (!m_faceCascade.load(QFile::encodeName(xmlPath).toStdString())) {
        qDebug() << "haarcascade_frontalface_default.xml模型组件缺失(ImageProcessor-ImageProcessor)";
        emit messageSentError("haarcascade_frontalface_default.xml模型组件缺失！");
        return;
    }
    else {
        m_modelLoaded = true;
        qDebug() << "人脸分类器创建成功(ImageProcessor-ImageProcessor)";
    }
}

void ImageProcessor::loadImage() {
    qDebug() << "加载图片：" + ImagePath << "(ImageProcessor-loadImage)";

    if (!QFile::exists(ImagePath)) {
        qDebug() << "图片不存在：" << ImagePath << "(ImageProcessor-loadImage)";
        emit messageSentError("图片不存在！");
        return;
    }
    else m_cvImage = cv::imread(QFile::encodeName(ImagePath).toStdString());

    if (m_cvImage.empty()) {
        qDebug() << "图片读取失败：" << ImagePath << "(ImageProcessor-loadImage)";
        emit messageSentError("图片读取失败！");
        return;
    }
    else m_hasImage = true;

    cv::Mat RgbImage;
    cv::cvtColor(m_cvImage,
                 RgbImage,
                 cv::COLOR_BGR2RGB);

    m_resultImage = QImage(RgbImage.data,
                           RgbImage.cols,
                           RgbImage.rows,
                           RgbImage.step,
                           QImage::Format_RGB888).copy();

    emit imageChanged();
    emit messageSentInfo("图片加载成功！");
}

void ImageProcessor::clearImage() {
    ImagePath = "";
    m_hasImage = false;
    m_cvImage.release();
    m_resultImage = QImage();
    m_faceCount = 0;
    emit resultChanged();
    emit imageChanged();
    emit messageSentInfo("图片清除成功");
}

void ImageProcessor::detectFaces() {
    if (!m_hasImage || m_cvImage.empty()) {
        emit messageSentError("请先选择图片！");
        return;
    }

    if (!m_modelLoaded) {
        qDebug() << "模型未加载(ImageProcessor-detectFaces)";
        emit messageSentError("模型未加载!");
        return;
    }

    cv::Mat Image = m_cvImage.clone();
    cv::Mat Gray;
    cv::cvtColor(Image, Gray, cv::COLOR_BGR2GRAY);

    std::vector<cv::Rect> Faces;
    m_faceCascade.detectMultiScale(Gray, Faces, 1.1, 3, 0, cv::Size(30, 30));

    for (size_t i = 0; i < Faces.size(); ++i) {
        cv::rectangle(Image, Faces[i],
                      cv::Scalar(0, 255, 0), 2);

        cv::putText(Image,
                    "Face" + std::to_string(i + 1),
                    cv::Point(Faces[i].x, Faces[i].y - 10),
                    cv::FONT_HERSHEY_SIMPLEX,
                    0.5, cv::Scalar(0, 255, 0), 1);
    }

    m_faceCount = Faces.size();
    cv::Mat RgbImage;
    cv::cvtColor(Image, RgbImage, cv::COLOR_BGR2RGB);
    m_resultImage = QImage(RgbImage.data, RgbImage.cols, RgbImage.rows, RgbImage.step, QImage::Format_RGB888).copy();

    if (m_historyRecord) m_historyRecord->addFaceTables(ImagePath, QString::number(m_faceCount));

    emit imageChanged();
    emit resultChanged();
    emit messageSentInfo(QString("检测到 %1 张人脸").arg(m_faceCount));
}
