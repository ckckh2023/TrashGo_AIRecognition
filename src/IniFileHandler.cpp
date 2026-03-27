#include "include/IniFileHandler.h"
#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>

IniFileHandler::IniFileHandler(QObject *parent) : QObject(parent) {
    QString IniPath = QCoreApplication::applicationDirPath() + "/config/config.ini";
    QDir dir;
    if (!dir.exists(QFileInfo(IniPath).path())) dir.mkpath(QFileInfo(IniPath).path());

    m_settings = new QSettings(IniPath, QSettings::IniFormat, this);

    if (!QFile::exists(IniPath)) {
        m_settings->setValue("Appearance/Theme", "system");
        m_settings->setValue("Model/Provider", "local");
        m_settings->setValue("Model/Baidu", "");
        m_settings->setValue("Model/Aliyun", "");
        m_settings->sync();
    }
}

IniFileHandler::~IniFileHandler() { }

QString IniFileHandler::theme() const { return m_settings->value("Appearance/Theme", "system").toString(); }

QString IniFileHandler::provider() const { return m_settings->value("Model/Provider", "local").toString(); }

QString IniFileHandler::currentApiKey() const {
    QString currentProvider = provider();
    if (currentProvider == "local") return "";
    else if (currentProvider == "baidu") return m_settings->value("Model/Baidu", "").toString();
    else if (currentProvider == "aliyun") return m_settings->value("Model/Aliyun", "").toString();
    else return "";
}

void IniFileHandler::setTheme(const QString &theme) {
    if (theme == this->theme()) return;
    else {
        m_settings->setValue("Appearance/Theme", theme);
        m_settings->sync();

        emit themeChanged();
    }
}

void IniFileHandler::setProvider(const QString &provider) {
    if (provider == this->provider()) return;
    else {
        m_settings->setValue("Model/Provider", provider);
        m_settings->sync();

        emit providerChanged();
        emit currentApiKeyChanged();
    }
}

void IniFileHandler::setCurrentApiKey(const QString &key) {
    if (key == this->currentApiKey()) return;

    QString currentProvider = provider();
    if (currentProvider == "local") return;
    else if (currentProvider == "baidu") m_settings->setValue("Model/Baidu", key);
    else if (currentProvider == "aliyun") m_settings->setValue("Model/Aliyun", key);
    else return;
    m_settings->sync();

    emit currentApiKeyChanged();
}
