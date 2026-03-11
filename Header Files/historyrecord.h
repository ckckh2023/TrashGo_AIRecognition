#ifndef HISTORYRECORD_H
#define HISTORYRECORD_H

#include <QObject>
#include <QSqlDatabase>
#include <QString>
#include <QVariant>

class HistoryRecord : public QObject{
    Q_OBJECT

public:
    explicit HistoryRecord(QObject *parent = nullptr);
    ~HistoryRecord();

    void generateThumbail(const QString &ImagePath, const QString &CurrentTime);
    void addTrashTables(const QString &path,const QString &result);
    void addFaceTables(const QString &path,const QString &result);
    Q_INVOKABLE QVariantList getAllRecords();

signals:
    void messageSent(const QString &msg);

private:
    void openDb();
    void closeDb();
    void loadTables();
    QSqlDatabase m_HistoryDb;

    static const QString ConnectionName;
};

#endif // HISTORYRECORD_H
