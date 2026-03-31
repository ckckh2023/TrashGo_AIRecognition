#ifndef GITHUBONLINE_H
#define GITHUBONLINE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVersionNumber>
#include <QStringList>

class GitHubOnline : public QObject {
    Q_OBJECT

public:
    explicit GitHubOnline(QObject *parent = nullptr);
    Q_INVOKABLE void checkNewVersion();
    Q_INVOKABLE QString getDayTips();

signals:
    void releaseChecked(bool hasNewVersion, const QString &lastestVersion, const QString &releaseUrl);
    void errorOccurred(const QString &msg);

private slots:
    void onNetworkReplyFinished();

private:
    QString extractVersion(const QString &tag);

    QNetworkAccessManager m_networkManager;
    QNetworkReply *m_currentReply = nullptr;

    QStringList dayTips = {
        "火锅汤底是厨余垃圾，但凝固的牛油块要先捞出来扔其他垃圾",
        "榴莲壳太硬太扎，属于其他垃圾，它自己都知道不好消化",
        "茶叶渣是厨余，但泡过的茶包（带塑料网）得拆开来扔",
        "过期化妆品是有害垃圾，因为它们比你更怕过期",
        "大棒骨是其他垃圾，因为它太硬，厨余处理厂啃不动",
        "普通干电池（5号7号）现在无汞了，是其他垃圾；但充电电池、纽扣电池、手机电池都是有害垃圾",
        "电动车电瓶是有害垃圾，但千万别自己拆，找专门的回收点",
        "充电宝坏了是有害垃圾，因为它肚子里全是锂电池",
        "过期药品是有害垃圾，连带着药片包装板（铝塑板）一起扔有害",
        "中药渣是厨余垃圾，但装中药的塑料袋记得撕下来扔其他",
        "创可贴、棉签、医用纱布是其他垃圾，不是有害也不是厨余（除非带血污染严重）",
        "旧衣服、床单、毛绒玩具是可回收物，但臭袜子、内衣裤、严重油污的抹布请自觉去其他垃圾",
        "破洞的丝袜是其他垃圾，因为机器会缠住，工人会崩溃",
        "羽绒服是可回收物，但羽绒枕头剪开的话，填充物归其他，外套归可回收",
        "奶茶杯里的液体倒掉，珍珠归厨余，纸杯归其他垃圾（因为有塑料膜），吸管归其他，盖子看材质",
        "快递箱是可回收物，但胶带、面单、填充泡沫都要撕下来扔其他垃圾",
        "牛奶盒、果汁盒是可回收物，但必须洗干净、压扁",
        "气泡膜、泡沫填充物是其他垃圾，捏着解压可以，回收不行",
        "废旧手机、电脑是可回收物（或找专门回收），但碎了的手机屏幕是有害垃圾",
        "U盘、内存卡、硬盘是可回收物，但建议先物理销毁再扔，防数据泄露",
        "电蚊拍的塑料部分可回收，电池部分有害，拆开扔",
        "牙膏皮挤干净是可回收物，没挤干净是其他垃圾",
        "碎镜子、碎玻璃是可回收物，但必须包好、标注",
        "陶瓷碗、花盆碎了是其他垃圾，不是玻璃，熔点不一样，别混",
        "湿巾、面膜、化妆棉都是其他垃圾，哪怕写着纯棉",
        "春联、福字是其他垃圾，因为油墨和胶水污染，回收价值低",
        "红包是可回收物（纸），但如果有塑料、胶水装饰就是其他",
        "月饼盒（铁盒、纸盒）是可回收，但里面的塑料托、干燥剂要拿出来扔其他",
        "圣诞树（塑料）是其他垃圾，（真树）是厨余垃圾",
        "猫砂膨润土、豆腐砂是其他垃圾，水晶砂（硅胶）也是其他",
        "宠物粪便扔马桶冲走，不要扔任何垃圾桶",
        "用过的尿垫、宠物湿巾是其他垃圾",
        "猫抓板、狗咬胶（瓦楞纸、橡胶）是其他垃圾，别扔可回收",
        "烟蒂是其他垃圾，而且必须掐灭，这是消防安全不是分类问题！",
        "水银温度计碎了，水银是有害垃圾，但玻璃外壳也是有害！",
        "油漆桶、杀虫剂罐是有害垃圾，哪怕用空了！"
    };
};

#endif // GITHUBONLINE_H
