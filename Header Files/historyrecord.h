#ifndef HISTORYRECORD_H
#define HISTORYRECORD_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QDebug>
#include <QSqlQuery>

class HistoryRecord : public QObject{
    Q_OBJECT

public:
    explicit HistoryRecord(QObject *parent = nullptr);
    ~HistoryRecord();

    void addTrashTables(const QString &path,const QString &result);
    void addFaceTables(const QString &path,const QString &result);
    void openDb();
    void closeDb();

signals:
    void messageSent(const QString &msg);

private:
    void loadTables();
    QSqlDatabase m_db;
};

#endif // HISTORYRECORD_H
