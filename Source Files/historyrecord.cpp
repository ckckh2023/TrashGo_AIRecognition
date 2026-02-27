#include "historyrecord.h"
#include <QDateTime>
#include <QCoreApplication>
#include <QDir>

HistoryRecord::HistoryRecord(QObject *parent) : QObject(parent) {
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    loadTables();
}

void HistoryRecord::loadTables() {
    openDb();
    QString createTable = "CREATE TABLE IF NOT EXISTS CV_Table("
                          "currentTime TEXT,"
                          "path TEXT NOT NULL,"
                          "result TEXT,"
                          "label TEXT NOT NULL)";

    QSqlQuery query;
    if (!query.exec(createTable)) {
        QString err = "CV_Table表格加载失败" + m_db.lastError().text();
        qDebug() << err;
        emit messageSent(err);
        return;
    }
}

HistoryRecord::~HistoryRecord(){
    closeDb();
}

void HistoryRecord::openDb(){
    QString DbPath = QCoreApplication::applicationDirPath() + "/data/TrashGO_History.db";

    QDir dir;
    if (!dir.exists(QCoreApplication::applicationDirPath() + "/data")) dir.mkpath(QCoreApplication::applicationDirPath() + "/data");

    m_db.setDatabaseName(DbPath);
    if (!m_db.open()) {
        QString err = "数据库连接失败" + m_db.lastError().text();
        qDebug() << err;
        emit messageSent(err);
        return;
    }
    qDebug() << "数据库已连接";
}

void HistoryRecord::closeDb(){

    if (m_db.isOpen()) {
        m_db.close();
        qDebug() << "数据库已关闭";
    }

}

void HistoryRecord::addTrashTables(const QString &path,const QString &result) {
    QSqlQuery query;
    QDateTime currentSystemTime = QDateTime::currentDateTime();
    QString currentTime = currentSystemTime.toString("yyyy.MM.dd hh:mm:ss");
    QString label = "TrashClassify";

    QString insertSql = "INSERT INTO CV_Table (currentTime, path, result, label) "
                        "VALUES (?, ?, ?, ?)";
    query.prepare(insertSql);
    query.addBindValue(currentTime);
    query.addBindValue(path);
    query.addBindValue(result);
    query.addBindValue(label);

    if (!query.exec()) {
        QString err = "数据插入失败: " + m_db.lastError().text();
        qDebug() << err;
        emit messageSent(err);
        return;
    }

    qDebug() << "数据插入成功";
}

void HistoryRecord::addFaceTables(const QString &path,const QString &result) {
    QSqlQuery query;
    QDateTime currentSystemTime = QDateTime::currentDateTime();
    QString currentTime = currentSystemTime.toString("yyyy.MM.dd hh:mm:ss");
    QString label = "FaceRecognize";

    QString insertSql = "INSERT INTO CV_Table (currentTime, path, result, label) "
                        "VALUES (?, ?, ?, ?)";
    query.prepare(insertSql);
    query.addBindValue(currentTime);
    query.addBindValue(path);
    query.addBindValue(result);
    query.addBindValue(label);

    if (!query.exec()) {
        QString err = "数据插入失败: " + m_db.lastError().text();
        qDebug() << err;
        emit messageSent(err);
        return;
    }

    qDebug() << "数据插入成功";
}
