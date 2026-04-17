#include "include/HistoryRecord.h"
#include <QDateTime>
#include <QCoreApplication>
#include <QSqlError>
#include <QSqlQuery>
#include <QPixmap>
#include <QDebug>
#include <QDir>
#include <QImageReader>
#include <QPainter>
#include <QFile>
#include <QDesktopServices>
#include <QUrl>

const QString HistoryRecord::ConnectionName = "history_connection";
int HistoryRecord::s_refCount = 0;

HistoryRecord::HistoryRecord(QObject *parent) : QObject(parent) {
    if (s_refCount == 0) {
        if (QSqlDatabase::contains(ConnectionName)) m_HistoryDb = QSqlDatabase::database(ConnectionName);
        else m_HistoryDb = QSqlDatabase::addDatabase("QSQLITE", ConnectionName);

        QDir dir;
        QString DataPath = QCoreApplication::applicationDirPath() + "/data";
        QString ThumbPath = DataPath + "/thumbnails";
        if (!dir.exists(DataPath)) dir.mkpath(DataPath);
        if (!dir.exists(ThumbPath)) dir.mkpath(ThumbPath);

        openDb();
        loadTables();
    }
    else m_HistoryDb = QSqlDatabase::database(ConnectionName);

    s_refCount++;
}

void HistoryRecord::loadTables() {
    if (!m_HistoryDb.isOpen()) openDb();

    QString createTable = "CREATE TABLE IF NOT EXISTS History_Table("
                          "currentTime TEXT NOT NULL, "
                          "path TEXT NOT NULL, "
                          "result TEXT, "
                          "label TEXT NOT NULL, "
                          "star INTEGER DEFAULT 0)";

    QSqlQuery query(m_HistoryDb);
    if (!query.exec(createTable)) {
        qDebug() << "History_Table表格加载失败" << m_HistoryDb.lastError().text() << "(HistoryRecord-loadTables)";
        return;
    }

    QSqlQuery indexQuery(m_HistoryDb);
    indexQuery.exec("CREATE INDEX IF NOT EXISTS idx_time ON History_Table(currentTime)");
}

HistoryRecord::~HistoryRecord(){
    s_refCount--;
    if (s_refCount == 0) closeDb();
}

void HistoryRecord::openDb() {
    if (m_HistoryDb.isOpen()) return;

    QString DbPath = QCoreApplication::applicationDirPath() + "/data/TrashGo_History.db";

    m_HistoryDb.setDatabaseName(DbPath);
    if (!m_HistoryDb.open()) {
        qDebug() << "数据库连接失败" << m_HistoryDb.lastError().text() << "(HistoryRecord-openDb)";
        return;
    }
    qDebug() << "数据库已连接(HistoryRecord-openDb)";;
}

void HistoryRecord::closeDb() {
    if (m_HistoryDb.isOpen()) {
        QString connectionName = m_HistoryDb.connectionName();
        m_HistoryDb.close();
        qDebug() << "数据库已关闭(HistoryRecord-closeDb)";
    }

}

void HistoryRecord::generateThumbnail(const QString &ImagePath, const QString &CurrentTime) {
    QImageReader reader(ImagePath);
    if (!reader.canRead()) {
        qDebug() << "无法读取图片：" << reader.errorString() << "(HistoryRecord-generateThumbnail)";
        return;
    }

    QImage originalImage = reader.read();
    if (originalImage.isNull()) {
        qDebug() << "无法加载缩略图" << reader.errorString() << "(HistoryRecord-generateThumbnail)";
        return;
    }

    QImage thumbnail = originalImage.scaled(80, 80, Qt::KeepAspectRatio, Qt::SmoothTransformation);
    QString saveDir = QCoreApplication::applicationDirPath() + "/data/thumbnails";
    QDir().mkpath(saveDir);

    QFileInfo fileInfo(ImagePath);
    QString thumbFileName = CurrentTime + "_thumb.jpg";
    QString thumbPath = saveDir + "/" + thumbFileName;

    if (thumbnail.hasAlphaChannel()) {
        QImage rgbImage(thumbnail.size(), QImage::Format_RGB32);
        rgbImage.fill(Qt::white);
        QPainter painter(&rgbImage);
        painter.drawImage(0, 0, thumbnail);
        thumbnail = rgbImage;
    }

    if (!thumbnail.save(thumbPath, "JPG")) qDebug() << "保存缩略图失败：" << thumbPath << "(HistoryRecord-generateThumbnail)";
}

void HistoryRecord::openOriginFile(const QString &filePath) {
    bool success = QDesktopServices::openUrl(QUrl::fromLocalFile(filePath));
    if (!success) {
        emit messageSentError("源图片文件不存在！");
        qDebug() << "源图片文件不存在(HistoryRecord-openOriginFile)";
    }
}

void HistoryRecord::addTrashTables(const QString &path, const QString &result) {
    if (!m_HistoryDb.isOpen()) openDb();

    QSqlQuery query(m_HistoryDb);
    QDateTime currentSystemTime = QDateTime::currentDateTime();
    QString currentTime = currentSystemTime.toString("yyyy_MM_dd_hh_mm_ss_zzz");
    QString label = "TrashClassify";

    QString insertSql = "INSERT INTO History_Table (currentTime, path, result, label, star) VALUES (?, ?, ?, ?, 0)";
    query.prepare(insertSql);
    query.addBindValue(currentTime);
    query.addBindValue(path);
    query.addBindValue(result);
    query.addBindValue(label);

    if (!query.exec()) {
        qDebug() << "数据插入失败: " << m_HistoryDb.lastError().text() << "(HistoryRecord-addTrashTables)";
        return;
    }
    generateThumbnail(path, currentTime);
    qDebug() << "数据插入成功(HistoryRecord-addTrashTables)";
}

void HistoryRecord::addFaceTables(const QString &path, const QString &result) {
    if (!m_HistoryDb.isOpen()) openDb();

    QSqlQuery query(m_HistoryDb);
    QDateTime currentSystemTime = QDateTime::currentDateTime();
    QString currentTime = currentSystemTime.toString("yyyy_MM_dd_hh_mm_ss_zzz");
    QString label = "FaceRecognize";

    QString insertSql = "INSERT INTO History_Table (currentTime, path, result, label, star) VALUES (?, ?, ?, ?, 0)";
    query.prepare(insertSql);
    query.addBindValue(currentTime);
    query.addBindValue(path);
    query.addBindValue(result);
    query.addBindValue(label);

    if (!query.exec()) {
        qDebug() << "数据插入失败: " << m_HistoryDb.lastError().text() << "(HistoryRecord-addFaceTables)";
        return;
    }
    generateThumbnail(path, currentTime);
    qDebug() << "数据插入成功(HistoryRecord-addFaceTables)";
}

void HistoryRecord::deleteRecord(const QString &currentTime) {
    if (!m_HistoryDb.isOpen()) openDb();
    QString thumbPath = QCoreApplication::applicationDirPath() + "/data/thumbnails/" + currentTime + "_thumb.jpg";

    QSqlQuery query(m_HistoryDb);
    query.prepare("DELETE FROM History_Table WHERE currentTime = :time");
    query.bindValue(":time", currentTime);

    if (!query.exec()) {
        qDebug() << "删除记录失败:" << query.lastError().text() << "(HistoryRecord-deleteRecord)";
        emit messageSentError("删除失败！");
        return;
    }
    else emit messageSentInfo(currentTime + "：记录删除成功！");

    if (query.numRowsAffected() > 0) {
        if (QFile::exists(thumbPath)) {
            if (!QFile::remove(thumbPath)) qDebug() << "缩略图删除失败：" << thumbPath << "(HistoryRecord-deleteRecord)";
            return;
        }
    }

}

void HistoryRecord::setStar(const QString &currentTime, bool isStar) {
    if (!m_HistoryDb.isOpen()) openDb();
    QSqlQuery query(m_HistoryDb);
    query.prepare("UPDATE History_Table SET star = :star WHERE currentTime = :time");
    query.bindValue(":star", isStar ? 1 : 0);
    query.bindValue(":time", currentTime);

    if (!query.exec()) {
        qDebug() << "更新星标失败:" << query.lastError().text() << "(HistoryRecord-setStar)";
        return;
    }
}

QVariantList HistoryRecord::getRecords(const QString &label) {
    QVariantList resultList;

    if (!m_HistoryDb.isOpen()) {
        openDb();
        if (!m_HistoryDb.isOpen()) {
            qDebug() << "无法读取数据库(HistoryRecord-getAllRecords)";
            return resultList;
        }
    }

    QSqlQuery getQuery(m_HistoryDb);
    QString getSql = "SELECT currentTime, path, result, label, star FROM History_Table";

    if (label != "all") {
        getSql += " WHERE LOWER(label) = LOWER(:label)";
        getQuery.prepare(getSql);
        getQuery.bindValue(":label", label);
    }
    else getQuery.prepare(getSql);

    if (!getQuery.exec()) {
        qDebug() << "数据查询失败:" << getQuery.lastError().text() << "(HistoryRecord-getAllRecords)";
        return resultList;
    }

    while (getQuery.next()) {
        QStringList rowStrings;
        rowStrings << getQuery.value(0).toString()
                   << getQuery.value(1).toString()
                   << getQuery.value(2).toString()
                   << getQuery.value(3).toString()
                   << getQuery.value(4).toString();
        resultList.append(rowStrings);
    }
    return resultList;
}

QVariantList HistoryRecord::getStars(const QString &label) {
    QVariantList starsList;

    if (!m_HistoryDb.isOpen()) {
        openDb();
        if (!m_HistoryDb.isOpen()) {
            qDebug() << "无法读取数据库(HistoryRecord-getStars)";
            return starsList;
        }
    }

    QSqlQuery getQuery(m_HistoryDb);
    QString getSql = "SELECT currentTime, path, result, label, star FROM History_Table WHERE star = 1";

    if (label != "all") {
        getSql += " AND LOWER(label) = LOWER(:label)";
        getQuery.prepare(getSql);
        getQuery.bindValue(":label", label);
    }
    else getQuery.prepare(getSql);

    if (!getQuery.exec()) {
        qDebug() << "数据查询失败:" << getQuery.lastError().text() << "(HistoryRecord-getStars)";
        return starsList;
    }

    while (getQuery.next()) {
        QStringList rowStrings;
        rowStrings << getQuery.value(0).toString()
                   << getQuery.value(1).toString()
                   << getQuery.value(2).toString()
                   << getQuery.value(3).toString()
                   << getQuery.value(4).toString();
        starsList.append(rowStrings);
    }
    return starsList;
}
