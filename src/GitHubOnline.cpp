#include "include/GitHubOnline.h"
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrl>
#include <QDebug>
#include <QHash>
#include <QDate>
#include <QDesktopServices>

GitHubOnline::GitHubOnline(QObject *parent) : QObject(parent) {
    connect(&m_networkManager, &QNetworkAccessManager::finished, this, &GitHubOnline::onNetworkReplyFinished);
    qDebug() << "GitHub网络组件加载完成(GitHubOnline-GitHubOnline)";
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

            m_releaseUrl = latestRelease["html_url"].toString();
            m_lastestVersion = extractVersion(tagName);

            if (m_lastestVersion.isEmpty()) {
                emit messageSentError("无法解析版本号: " + tagName);
                return;
            }

            QVersionNumber currentVer = QVersionNumber::fromString(m_currentVersion);
            QVersionNumber latestVer = QVersionNumber::fromString(m_lastestVersion);

            bool isNewer = !latestVer.isNull() && latestVer > currentVer;
            qDebug() << isNewer << " " << m_lastestVersion << " " << m_releaseUrl << "(GitHubOnline-onNetworkReplyFinished)";

            emit releaseChecked(isNewer);
        }
        else emit messageSentError("无效的JSON响应！");
    }
    else emit messageSentError("发生错误：" + m_currentReply->errorString());

    m_currentReply->deleteLater();
    m_currentReply = nullptr;
}

QString GitHubOnline::extractVersion(const QString &tag) {
    QRegularExpression re("(\\d+\\.\\d+\\.\\d+)");
    QRegularExpressionMatch match = re.match(tag);
    if (match.hasMatch()) return match.captured(1);
    return QString();
}

void GitHubOnline::openReleasePage() {
    if (m_releaseUrl.isEmpty()) {
        emit messageSentError("没有可用的发布页面，请先检查更新并确保检测到新版本。");
        return;
    }

    bool success = QDesktopServices::openUrl(QUrl(m_releaseUrl));
    if (success) emit messageSentInfo("已打开浏览器，请前往下载最新版本");
    else emit messageSentError("无法打开浏览器，请手动访问：" + m_releaseUrl);
}

QString GitHubOnline::getDayTips() {
    QDate today = QDate::currentDate();
    uint hashValue = qHash(today);

    return dayTips[hashValue % dayTips.size()];
}
