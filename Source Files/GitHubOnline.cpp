#include "GitHubOnline.h"
#include <QNetworkRequest>
#include <QCoreApplication>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrl>
#include <QDebug>

GitHubOnline::GitHubOnline(QObject *parent) : QObject(parent) {
    connect(&m_networkManager, &QNetworkAccessManager::finished, this, &GitHubOnline::onNetworkReplyFinished);
    qDebug() << "GitHub网络组件加载完成(GitHubOnline::GitHubOnline)";
}

void GitHubOnline::checkNewVersion() {
    QString apiUrl = QString("https://api.github.com/repos/ckckh2023/TrashGo_AIRecognition/releases");

    QNetworkRequest request{QUrl(apiUrl)};
    QString userAgent = QCoreApplication::applicationName() + "/" + QCoreApplication::applicationVersion();
    request.setHeader(QNetworkRequest::UserAgentHeader, userAgent);

    if (m_currentReply) {
        m_currentReply->abort();
        m_currentReply->deleteLater();
    }
    else m_currentReply = m_networkManager.get(request);
}

void GitHubOnline::onNetworkReplyFinished() {
    if (!m_currentReply) return;

    if (m_currentReply->error() == QNetworkReply::NoError) {
        QByteArray data = m_currentReply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (doc.isArray()) {
            QJsonArray releases = doc.array();
            QJsonObject latestRelease = releases.first().toObject();
            QString tagName = latestRelease["tag_name"].toString();
            QString releaseUrl = latestRelease["html_url"].toString();

            QString versionStr = extractVersion(tagName);
            if (versionStr.isEmpty()) {
                emit errorOccurred("无法解析版本号: " + tagName);
                return;
            }
            QString currentVersion = QCoreApplication::applicationVersion();

            QVersionNumber currentVer = QVersionNumber::fromString(currentVersion);
            QVersionNumber latestVer = QVersionNumber::fromString(versionStr);

            bool isNewer = !latestVer.isNull() && latestVer > currentVer;
            qDebug() << isNewer << " " << versionStr << " " << releaseUrl;
            emit releaseChecked(isNewer, versionStr, releaseUrl);
        }
        else emit errorOccurred("无效的JSON 响应");
    }
    else emit errorOccurred(m_currentReply->errorString());

    m_currentReply->deleteLater();
    m_currentReply = nullptr;
}

QString GitHubOnline::extractVersion(const QString &tag) {
    QRegularExpression re("(\\d+\\.\\d+\\.\\d+)");
    QRegularExpressionMatch match = re.match(tag);
    if (match.hasMatch()) return match.captured(1);
    return QString();
}
