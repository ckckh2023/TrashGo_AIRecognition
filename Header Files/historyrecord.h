#ifndef HISTORYRECORD_H
#define HISTORYRECORD_H

#include <QObject>
#include <QSqlDatabase>
#include <QString>

class HistoryRecord : public QObject{
    Q_OBJECT

public:
    explicit HistoryRecord(QObject *parent = nullptr);
    ~HistoryRecord();

    void generateThumbail(const QString &ImagePath, const QString &CurrentTime);
    void addTrashTables(const QString &path,const QString &result);
    void addFaceTables(const QString &path,const QString &result);
    void openDb();
    void closeDb();
    Q_INVOKABLE QVariantList getAllRecords();

signals:
    void messageSent(const QString &msg);

private:
    void loadTables();
    QSqlDatabase m_HistoryDb;
};

#endif // HISTORYRECORD_H
