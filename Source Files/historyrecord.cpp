#include "historyrecord.h"
#include <QDateTime>
#include <QCoreApplication>
#include <QSqlError>
#include <QSqlQuery>
#include <QPixmap>
#include <QDebug>
#include <QDir>

HistoryRecord::HistoryRecord(QObject *parent) : QObject(parent) {
    m_HistoryDb = QSqlDatabase::addDatabase("QSQLITE");

    QDir dir;
    QString DataPath = QCoreApplication::applicationDirPath() + "/data";
    QString ThumbPath = DataPath + "/thumbnails";
    if (!dir.exists(DataPath)) dir.mkpath(DataPath);
    if (!dir.exists(ThumbPath)) dir.mkpath(ThumbPath);

    loadTables();
}

void HistoryRecord::loadTables() {
    openDb();
    QString createTable = "CREATE TABLE IF NOT EXISTS CV_Table(currentTime TEXT, path TEXT NOT NULL, result TEXT, label TEXT NOT NULL)";

    QSqlQuery query(m_HistoryDb);
    if (!query.exec(createTable)) {
        QString err = "CV_Table表格加载失败" + m_HistoryDb.lastError().text();
        qDebug() << err;
        emit messageSent(err);
        return;
    }
}

HistoryRecord::~HistoryRecord(){
    closeDb();
}

void HistoryRecord::openDb() {
    QString DbPath = QCoreApplication::applicationDirPath() + "/data/TrashGo_History.db";

    m_HistoryDb.setDatabaseName(DbPath);
    if (!m_HistoryDb.open()) {
        QString err = "数据库连接失败" + m_HistoryDb.lastError().text();
        qDebug() << err;
        emit messageSent(err);
        return;
    }
    qDebug() << "数据库已连接";
}

void HistoryRecord::closeDb() {

    if (m_HistoryDb.isOpen()) {
        m_HistoryDb.close();
        qDebug() << "数据库已关闭";
    }

}

void HistoryRecord::generateThumbail(const QString &ImagePath, const QString &CurrentTime) {
    QPixmap originalPixmap(ImagePath);
    if (originalPixmap.isNull()) {
        qDebug() << "无法加载缩略图";
        return;
    }

    QSize fixedSize(80, 80);
    QPixmap thumbnail = originalPixmap.scaled(fixedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);
    QString saveDir = QCoreApplication::applicationDirPath() + "/data/thumbnails";

    QFileInfo fileInfo(ImagePath);
    QString suffix = fileInfo.suffix();
    QString thumbFileName = CurrentTime + "_thumb.jpg";
    QString thumbPath = saveDir + "/" + thumbFileName;

    if (thumbnail.save(thumbPath, "JPG")) qDebug() << "缩略图已保存到：" << thumbPath;
    else qDebug() << "保存缩略图失败：" << thumbPath;
}

void HistoryRecord::addTrashTables(const QString &path, const QString &result) {
    QSqlQuery query(m_HistoryDb);
    QDateTime currentSystemTime = QDateTime::currentDateTime();
    QString currentTime = currentSystemTime.toString("yyyy_MM_dd_hh_mm_ss");
    QString label = "TrashClassify";

    QString insertSql = "INSERT INTO CV_Table (currentTime, path, result, label) VALUES (?, ?, ?, ?)";
    query.prepare(insertSql);
    query.addBindValue(currentTime);
    query.addBindValue(path);
    query.addBindValue(result);
    query.addBindValue(label);

    if (!query.exec()) {
        QString err = "数据插入失败: " + m_HistoryDb.lastError().text();
        qDebug() << err;
        emit messageSent(err);
        return;
    }
    generateThumbail(path, currentTime);
    qDebug() << "数据插入成功";
}

void HistoryRecord::addFaceTables(const QString &path, const QString &result) {
    QSqlQuery query(m_HistoryDb);
    QDateTime currentSystemTime = QDateTime::currentDateTime();
    QString currentTime = currentSystemTime.toString("yyyy_MM_dd_hh_mm_ss");
    QString label = "FaceRecognize";

    QString insertSql = "INSERT INTO CV_Table (currentTime, path, result, label) VALUES (?, ?, ?, ?)";
    query.prepare(insertSql);
    query.addBindValue(currentTime);
    query.addBindValue(path);
    query.addBindValue(result);
    query.addBindValue(label);

    if (!query.exec()) {
        QString err = "数据插入失败: " + m_HistoryDb.lastError().text();
        qDebug() << err;
        emit messageSent(err);
        return;
    }
    generateThumbail(path, currentTime);
    qDebug() << "数据插入成功";
}

QVariantList HistoryRecord::getAllRecords() {
    QVariantList resultList;

    if (!m_HistoryDb.isOpen()) {
        openDb();
        if (!m_HistoryDb.isOpen()) {
            qDebug() << "无法读取数据库";
            return resultList;
        }
    }

    QSqlQuery getQuery("SELECT currentTime, path , result, label FROM CV_Table");
    if (!getQuery.isActive()) {
        qDebug() << "数据查询失败:" << getQuery.lastError().text();
        return resultList;
    }

    while (getQuery.next()) {
        QStringList rowStrings;
        rowStrings << getQuery.value(0).toString() << getQuery.value(1).toString() << getQuery.value(2).toString() << getQuery.value(3).toString();
        resultList.append(rowStrings);
    }
    return resultList;
}
