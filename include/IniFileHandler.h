#ifndef INIFILEHANDLER_H
#define INIFILEHANDLER_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QSettings>

class IniFileHandler : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QString provider READ provider WRITE setProvider NOTIFY providerChanged)
    Q_PROPERTY(QString currentApiKey READ currentApiKey WRITE setCurrentApiKey NOTIFY currentApiKeyChanged)
    Q_PROPERTY(QString renderer READ renderer WRITE setRenderer NOTIFY rendererChanged)
    Q_PROPERTY(int timeLimit READ timeLimit WRITE setTimeLimit NOTIFY timeLimitChanged)

public:
    explicit IniFileHandler(QObject *parent = nullptr);
    ~IniFileHandler();

    QString theme() const;
    QString color() const;
    QString provider() const;
    QString currentApiKey() const;
    int timeLimit() const;
    QString renderer() const;

    void setTheme(const QString &theme);
    void setColor(const QString &color);
    void setProvider(const QString &provider);
    void setCurrentApiKey(const QString &key);
    void setTimeLimit(int interval);
    void setRenderer(const QString &renderer);

    Q_INVOKABLE void restartApp(int exitCode = 0);

signals:
    void themeChanged();
    void colorChanged();
    void providerChanged();
    void currentApiKeyChanged();
    void timeLimitChanged();
    void rendererChanged();

    void messageSentInfo(const QString &msg);

private:
    QSettings *m_settings;
};

#endif // INIFILEHANDLER_H
