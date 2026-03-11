#include "historyrecord.h"
#include <QDateTime>
#include <QCoreApplication>
#include <QSqlError>
#include <QSqlQuery>
#include <QPixmap>
#include <QDebug>
#include <QDir>

const QString HistoryRecord::ConnectionName = "history_connection";

HistoryRecord::HistoryRecord(QObject *parent) : QObject(parent) {
    if (QSqlDatabase::contains(ConnectionName)) m_HistoryDb = QSqlDatabase::addDatabase(ConnectionName);
    else m_HistoryDb = QSqlDatabase::addDatabase("QSQLITE");

    QDir dir;
    QString DataPath = QCoreApplication::applicationDirPath() + "/data";
    QString ThumbPath = DataPath + "/thumbnails";
    if (!dir.exists(DataPath)) dir.mkpath(DataPath);
    if (!dir.exists(ThumbPath)) dir.mkpath(ThumbPath);

    openDb();
    loadTables();
}

void HistoryRecord::loadTables() {
    if (!m_HistoryDb.isOpen()) openDb();

    QString createTable = "CREATE TABLE IF NOT EXISTS CV_Table(currentTime TEXT, path TEXT NOT NULL, result TEXT, label TEXT NOT NULL)";

    QSqlQuery query(m_HistoryDb);
    if (!query.exec(createTable)) {
        qDebug() << "CV_Table表格加载失败" << m_HistoryDb.lastError().text() << "(HistoryRecord-loadTables)";
        return;
    }
}

HistoryRecord::~HistoryRecord(){
    closeDb();
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

void HistoryRecord::generateThumbail(const QString &ImagePath, const QString &CurrentTime) {
    QPixmap originalPixmap(ImagePath);
    if (originalPixmap.isNull()) {
        qDebug() << "无法加载缩略图(HistoryRecord-generateThumbail)";
        return;
    }

    QSize fixedSize(80, 80);
    QPixmap thumbnail = originalPixmap.scaled(fixedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);
    QString saveDir = QCoreApplication::applicationDirPath() + "/data/thumbnails";

    QFileInfo fileInfo(ImagePath);
    QString suffix = fileInfo.suffix();
    QString thumbFileName = CurrentTime + "_thumb.jpg";
    QString thumbPath = saveDir + "/" + thumbFileName;

    if (!thumbnail.save(thumbPath, "JPG")) qDebug() << "保存缩略图失败：" << thumbPath << "(HistoryRecord-generateThumbail)";
}

void HistoryRecord::addTrashTables(const QString &path, const QString &result) {
    if (!m_HistoryDb.isOpen()) openDb();

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
        qDebug() << "数据插入失败: " << m_HistoryDb.lastError().text() << "(HistoryRecord-addTrashTables)";
        return;
    }
    generateThumbail(path, currentTime);
    qDebug() << "数据插入成功(HistoryRecord-addTrashTables)";
}

void HistoryRecord::addFaceTables(const QString &path, const QString &result) {
    if (!m_HistoryDb.isOpen()) openDb();

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
        qDebug() << "数据插入失败: " + m_HistoryDb.lastError().text() << "(HistoryRecord-addFaceTables)";
        return;
    }
    generateThumbail(path, currentTime);
    qDebug() << "数据插入成功(HistoryRecord-addFaceTables)";
}

QVariantList HistoryRecord::getAllRecords() {
    QVariantList resultList;

    if (!m_HistoryDb.isOpen()) {
        openDb();
        if (!m_HistoryDb.isOpen()) {
            qDebug() << "无法读取数据库(HistoryRecord-getAllRecords)";
            return resultList;
        }
    }

    QSqlQuery getQuery("SELECT currentTime, path , result, label FROM CV_Table");
    if (!getQuery.isActive()) {
        qDebug() << "数据查询失败:" << getQuery.lastError().text() << "(HistoryRecord-getAllRecords)";
        return resultList;
    }

    while (getQuery.next()) {
        QStringList rowStrings;
        rowStrings << getQuery.value(0).toString() << getQuery.value(1).toString() << getQuery.value(2).toString() << getQuery.value(3).toString();
        resultList.append(rowStrings);
    }
    return resultList;
}
