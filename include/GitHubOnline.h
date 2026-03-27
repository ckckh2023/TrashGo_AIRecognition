#ifndef GITHUBONLINE_H
#define GITHUBONLINE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVersionNumber>

class GitHubOnline : public QObject {
    Q_OBJECT

public:
    explicit GitHubOnline(QObject *parent = nullptr);
    Q_INVOKABLE void checkNewVersion();

signals:
    void releaseChecked(bool hasNewVersion, const QString &lastestVersion, const QString &releaseUrl);
    void errorOccurred(const QString &msg);

private slots:
    void onNetworkReplyFinished();

private:
    QString extractVersion(const QString &tag);

    QNetworkAccessManager m_networkManager;
    QNetworkReply *m_currentReply = nullptr;
};

#endif // GITHUBONLINE_H
