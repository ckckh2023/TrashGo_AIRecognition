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

    void generateThumbnail(const QString &ImagePath, const QString &CurrentTime);
    void addTrashTables(const QString &path,const QString &result);
    void addFaceTables(const QString &path,const QString &result);

    Q_INVOKABLE QVariantList getRecords(const QString &label);
    Q_INVOKABLE QVariantList getStars(const QString &label);
    Q_INVOKABLE void deleteRecord(const QString &currentTime);
    Q_INVOKABLE void setStar(const QString &currentTime, bool isStar);

    Q_INVOKABLE void openOriginFile(const QString &filePath);

signals:
    void messageSentInfo(const QString &info);
    void messageSentError(const QString &error);
    void messageSentWarn(const QString &warn);
private:
    void openDb();
    void closeDb();
    void loadTables();
    QSqlDatabase m_HistoryDb;

    static int s_refCount;
    static const QString ConnectionName;
};

#endif // HISTORYRECORD_H
