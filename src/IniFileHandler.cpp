#include "include/IniFileHandler.h"
#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>
#include <QProcess>
#include <QStandardPaths>

IniFileHandler::IniFileHandler(QObject *parent) : QObject(parent) {
    QString IniPath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/config/config.ini";
    QDir dir;
    if (!dir.exists(QFileInfo(IniPath).path())) dir.mkpath(QFileInfo(IniPath).path());

    m_settings = new QSettings(IniPath, QSettings::IniFormat, this);

    if (!QFile::exists(IniPath)) {
        ensureSettingExists("Appearance/Theme", "跟随系统");
        ensureSettingExists("Appearance/Color", "蓝色");
        ensureSettingExists("Model/Provider", "本地模型");
        ensureSettingExists("Model/Baidu", "");
        ensureSettingExists("Model/Aliyun", "");
        ensureSettingExists("Limit/Interval", "500");
        ensureSettingExists("LocalModel/Provider", "ResNet");
        ensureSettingExists("Graphics/Renderer", "自动选择");
        m_settings->sync();
    }

    qDebug() << "Ini配置项引擎初始化成功(IniFileHandler-IniFileHandler)";
}

IniFileHandler::~IniFileHandler() { }

QString IniFileHandler::theme() const { return m_settings->value("Appearance/Theme", "跟随系统").toString(); }

QString IniFileHandler::color() const { return m_settings->value("Appearance/Color", "蓝色").toString(); }

QString IniFileHandler::provider() const { return m_settings->value("Model/Provider", "本地模型").toString(); }

QString IniFileHandler::currentApiKey() const {
    QString currentProvider = provider();
    if (currentProvider == "本地模型") return "";
    else if (currentProvider == "百度云") return m_settings->value("Model/Baidu", "").toString();
    else if (currentProvider == "阿里云") return m_settings->value("Model/Aliyun", "").toString();
    else return "";
}

int IniFileHandler::timeLimit() const { return m_settings->value("Limit/Interval", "500").toInt(); }

QString IniFileHandler::localProvider() const { return m_settings->value("LocalModel/Provider", "ResNet").toString(); }

QString IniFileHandler::renderer() const {
    #ifdef Q_OS_WIN
        return m_settings->value("Graphics/Renderer", "自动选择").toString();
    #else
        return m_settings->value("Graphics/Renderer", "自动选择").toString();
    #endif
}

void IniFileHandler::setTheme(const QString &theme) {
    if (theme == this->theme()) return;
    else {
        m_settings->setValue("Appearance/Theme", theme);
        m_settings->sync();

        emit themeChanged();
        emit messageSentInfo("主题已变更为：" + theme);
    }
}

void IniFileHandler::setColor(const QString &color) {
    if (color == this->color()) return;
    else {
        m_settings->setValue("Appearance/Color", color);
        m_settings->sync();

        emit colorChanged();
        emit messageSentInfo("颜色已变更为：" + color);
    }
}

void IniFileHandler::setProvider(const QString &provider) {
    if (provider == this->provider()) return;
    else {
        m_settings->setValue("Model/Provider", provider);
        m_settings->sync();

        emit providerChanged();
        emit currentApiKeyChanged();
        emit messageSentInfo("模型已变更为：" + provider);
    }
}

void IniFileHandler::setCurrentApiKey(const QString &key) {
    if (key == this->currentApiKey()) return;

    QString currentProvider = provider();
    if (currentProvider == "本地模型") return;
    else if (currentProvider == "百度云") m_settings->setValue("Model/Baidu", key);
    else if (currentProvider == "阿里云") m_settings->setValue("Model/Aliyun", key);
    else return;
    m_settings->sync();

    emit currentApiKeyChanged();
    emit messageSentInfo("模型密钥已变更!");
}

void IniFileHandler::setTimeLimit(int interval) {
    if (interval == this->timeLimit()) return;
    else {
        m_settings->setValue("Limit/Interval", interval);
        m_settings->sync();

        emit timeLimitChanged();
        emit messageSentInfo("重复点击时间限制已变更为" + QString::number(interval));
    }
}

void IniFileHandler::setLocalProvider(const QString &localProvider) {
    if (localProvider == this->localProvider()) return;
    else {
        m_settings->setValue("LocalModel/Provider", localProvider);
        m_settings->sync();

        emit localProviderChanged();
        emit messageSentInfo("本地模型已变更为：" + localProvider);
        emit messageSentInfo("此操作需要重启软件！点击设置项的右侧按钮重启");
    }
}

void IniFileHandler::setRenderer(const QString &renderer) {
    if (renderer == this->renderer()) return;
    else {
        m_settings->setValue("Graphics/Renderer", renderer);
        m_settings->sync();

        emit rendererChanged();
        emit messageSentInfo("渲染器已变更为：" + renderer);
        emit messageSentInfo("此操作需要重启软件！点击设置项的右侧按钮重启");
    }
}

void IniFileHandler::ensureSettingExists(const QString &key, const QVariant &defaultValue) {
    if (!m_settings->contains(key)) m_settings->setValue(key, defaultValue);
    else return;
}

void IniFileHandler::restartApp(int exitCode) {
    QString program = QCoreApplication::applicationFilePath();
    QStringList arguments = QCoreApplication::arguments();
    arguments.removeFirst();

    qDebug() << "正在重启:" << program << arguments << "(IniFileHandler-restartApp)";

    if (QProcess::startDetached(program, arguments)) qApp->exit(exitCode);
    else qDebug() << "重启失败(IniFileHandler-restartApp)";
}
