#ifndef INIFILEHANDLER_H
#define INIFILEHANDLER_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QSettings>

class IniFileHandler : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(QString provider READ provider WRITE setProvider NOTIFY providerChanged)
    Q_PROPERTY(QString currentApiKey READ currentApiKey WRITE setCurrentApiKey NOTIFY currentApiKeyChanged)

public:
    explicit IniFileHandler(QObject *parent = nullptr);
    ~IniFileHandler();

    QString theme() const;
    QString provider() const;
    QString currentApiKey() const;

    void setTheme(const QString &theme);
    void setProvider(const QString &provider);
    void setCurrentApiKey(const QString &key);

signals:
    void themeChanged();
    void providerChanged();
    void currentApiKeyChanged();

private:
    QSettings *m_settings;
};

#endif // INIFILEHANDLER_H
