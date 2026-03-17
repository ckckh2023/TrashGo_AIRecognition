#ifndef GARBAGECLASSIFIER_H
#define GARBAGECLASSIFIER_H

#include "HistoryRecord.h"

#include <QObject>
#include <QImage>
#include <QString>
#include <QStringList>
#include <QMap>

#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>

class GarbageClassifier : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString result READ result NOTIFY resultChanged)
    Q_PROPERTY(QString garbageType READ garbageType NOTIFY resultChanged)
    Q_PROPERTY(bool hasImage READ hasImage NOTIFY imageChanged)

public:
    explicit GarbageClassifier(QObject *parent = nullptr);
    void setHistoryRecord(HistoryRecord *record) { m_historyRecord = record; }

    Q_INVOKABLE void loadImage();
    Q_INVOKABLE void clearImage();
    Q_INVOKABLE void classify();
    Q_INVOKABLE QImage resultImage() const { return m_resultImage; }
    Q_INVOKABLE void loadPath(const QString &NewPath) { ImagePath = NewPath; }

    bool hasImage() const { return m_hasImage; }
    QString result() const { return m_result; }
    QString garbageType() const { return m_garbageType; }

signals:
    void imageChanged();
    void resultChanged();
    void messageSentInfo(const QString &info);
    void messageSentError(const QString &error);
    void messageSentWarn(const QString &warn);

private:
    void loadModel();
    QString mapToChineseType(int classId);

    bool m_hasImage = false;
    QString ImagePath = "";
    cv::Mat m_cvImage;
    QImage m_resultImage;

    bool m_modelLoaded = false;
    cv::dnn::Net m_Net;

    QString m_result;
    QString m_garbageType;
    double m_confidence = 0.0;

    HistoryRecord *m_historyRecord = nullptr;

    QStringList Categories = {
        "Hazardous_waste_adhesive",
        "Hazardous_waste_batteries",
        "Hazardous_waste_button_batteries",
        "Hazardous_waste_lamps",
        "Hazardous_waste_solar_cells",
        "Hazardous_waste_storage_battery",
        "Kitchen_waste_apples",
        "Kitchen_waste_banana_peels",
        "Kitchen_waste_beans",
        "Kitchen_waste_bread",
        "Kitchen_waste_cabbage_leaves",
        "Kitchen_waste_cake",
        "Kitchen_waste_chili_peppers",
        "Kitchen_waste_cookies",
        "Kitchen_waste_dragon_fruit",
        "Kitchen_waste_egg_tarts",
        "Kitchen_waste_eggs",
        "Kitchen_waste_garlic",
        "Kitchen_waste_holy_fruit",
        "Kitchen_waste_jackfruit",
        "Kitchen_waste_melon_seed_shells",
        "Kitchen_waste_mushrooms",
        "Kitchen_waste_oranges",
        "Kitchen_waste_pear",
        "Kitchen_waste_pineapple",
        "Kitchen_waste_strawberry",
        "Kitchen_waste_sweet_potatoes",
        "Kitchen_waste_tofu",
        "Kitchen_waste_tomato",
        "Kitchen_waste_watermelon_rind",
        "Other_disposable_cotton_swabs",
        "Other_disposable_garbage_cups",
        "Other_garbage_PE_plastic_bags",
        "Other_garbage_chicken_feather_dusters",
        "Other_garbage_cigarettes_lit",
        "Other_garbage_desiccants",
        "Other_garbage_drum_paper",
        "Other_garbage_lighters",
        "Other_garbage_masks",
        "Other_garbage_pens",
        "Other_garbage_pregnancy_test_sticks",
        "Other_garbage_scrubbing_towels",
        "Other_garbage_tape",
        "Other_junk_glasses",
        "Other_junk_records",
        "Packaging_of_hazardous_waste_drugs",
        "Recyclable_A4_paper",
        "Recyclable_Stapler",
        "Recyclable_alarm_clock",
        "Recyclable_bowl",
        "Recyclable_cans",
        "Recyclable_cardboard",
        "Recyclable_charging_head",
        "Recyclable_charging_wires",
        "Recyclable_circuit_boards",
        "Recyclable_clothes_hanger",
        "Recyclable_desk_lamp",
        "Recyclable_disposable_chopsticks",
        "Recyclable_electric_fan",
        "Recyclable_electric_iron",
        "Recyclable_electric_shaver",
        "Recyclable_electromagnetic_stove",
        "Recyclable_electronic_scale",
        "Recyclable_envelope",
        "Recyclable_fabric_products",
        "Recyclable_fire_extinguishers",
        "Recyclable_flashlight",
        "Recyclable_foam_board",
        "Recyclable_hair_dryer",
        "Recyclable_hats",
        "Recyclable_headphones",
        "Recyclable_hot_water_bottles",
        "Recyclable_hula_hoop",
        "Recyclable_keyboard",
        "Recyclable_keys",
        "Recyclable_knives",
        "Recyclable_magnifying_glass",
        "Recyclable_material_box",
        "Recyclable_material_calculator",
        "Recyclable_material_card",
        "Recyclable_material_pump",
        "Recyclable_materials_book",
        "Recyclable_microphone",
        "Recyclable_mobile_phones",
        "Recyclable_mouse",
        "Recyclable_packaging",
        "Recyclable_pants",
        "Recyclable_patch_cords",
        "Recyclable_pillows",
        "Recyclable_plastic_basin",
        "Recyclable_plastic_bottles",
        "Recyclable_plates",
        "Recyclable_power_bank",
        "Recyclable_radio",
        "Recyclable_remote_control",
        "Recyclable_rice_cooker",
        "Recyclable_routers",
        "Recyclable_ruler",
        "Recyclable_scissors",
        "Recyclable_shoes",
        "Recyclable_skirts",
        "Recyclable_socks",
        "Recyclable_spoons_and_forks",
        "Recyclable_stainless_steel_pipes",
        "Recyclable_stool",
        "Recyclable_suitcase",
        "Recyclable_table",
        "Recyclable_table_tennis_rackets",
        "Recyclable_telescope",
        "Recyclable_thermos_cup",
        "Recyclable_tires",
        "Recyclable_tweezers",
        "Recyclable_umbrellas",
        "Recyclable_watches",
        "Recyclable_water_bottle",
        "Recyclable_water_cup",
        "Recyclable_wire_balls",
        "Recyclable_wooden_comb",
        "Recyclable_wooden_cutting_board",
        "Recyclable_wooden_spatula"
    };

    QMap<int, QString> MapToChinese = {
        {0, "有害垃圾-胶水"},
        {1, "有害垃圾-电池"},
        {2, "有害垃圾-纽扣电池"},
        {3, "有害垃圾-灯"},
        {4, "有害垃圾-太阳能电池"},
        {5, "有害垃圾-蓄电池"},
        {6, "厨余垃圾-苹果"},
        {7, "厨余垃圾-香蕉皮"},
        {8, "厨余垃圾-豆类"},
        {9, "厨余垃圾-面包"},
        {10, "厨余垃圾-白菜叶"},
        {11, "厨余垃圾-蛋糕"},
        {12, "厨余垃圾-辣椒"},
        {13, "厨余垃圾-饼干"},
        {14, "厨余垃圾-火龙果"},
        {15, "厨余垃圾-蛋挞"},
        {16, "厨余垃圾-鸡蛋"},
        {17, "厨余垃圾-大蒜"},
        {18, "厨余垃圾-圣女果"},
        {19, "厨余垃圾-菠萝蜜"},
        {20, "厨余垃圾-瓜子壳"},
        {21, "厨余垃圾-蘑菇"},
        {22, "厨余垃圾-橙子"},
        {23, "厨余垃圾-梨"},
        {24, "厨余垃圾-菠萝"},
        {25, "厨余垃圾-草莓"},
        {26, "厨余垃圾-红薯"},
        {27, "厨余垃圾-豆腐"},
        {28, "厨余垃圾-西红柿"},
        {29, "厨余垃圾-西瓜皮"},
        {30, "其他垃圾-一次性棉签"},
        {31, "其他垃圾-一次性垃圾杯"},
        {32, "其他垃圾-PE塑料袋"},
        {33, "其他垃圾-鸡毛掸子"},
        {34, "其他垃圾-烟蒂"},
        {35, "其他垃圾-干燥剂"},
        {36, "其他垃圾-鼓纸"},
        {37, "其他垃圾-打火机"},
        {38, "其他垃圾-口罩"},
        {39, "其他垃圾-笔"},
        {40, "其他垃圾-验孕棒"},
        {41, "其他垃圾-搓澡巾"},
        {42, "其他垃圾-胶带"},
        {43, "其他垃圾-眼镜"},
        {44, "其他垃圾-唱片"},
        {45, "有害垃圾-药品包装"},
        {46, "可回收物-A4纸"},
        {47, "可回收物-订书机"},
        {48, "可回收物-闹钟"},
        {49, "可回收物-碗"},
        {50, "可回收物-易拉罐"},
        {51, "可回收物-纸板"},
        {52, "可回收物-充电头"},
        {53, "可回收物-充电线"},
        {54, "可回收物-电路板"},
        {55, "可回收物-衣架"},
        {56, "可回收物-台灯"},
        {57, "可回收物-一次性筷子"},
        {58, "可回收物-电风扇"},
        {59, "可回收物-电熨斗"},
        {60, "可回收物-电动剃须刀"},
        {61, "可回收物-电磁炉"},
        {62, "可回收物-电子秤"},
        {63, "可回收物-信封"},
        {64, "可回收物-布艺品"},
        {65, "可回收物-灭火器"},
        {66, "可回收物-手电筒"},
        {67, "可回收物-泡沫板"},
        {68, "可回收物-吹风机"},
        {69, "可回收物-帽子"},
        {70, "可回收物-耳机"},
        {71, "可回收物-热水瓶"},
        {72, "可回收物-呼啦圈"},
        {73, "可回收物-键盘"},
        {74, "可回收物-钥匙"},
        {75, "可回收物-刀具"},
        {76, "可回收物-放大镜"},
        {77, "可回收物-纸箱"},
        {78, "可回收物-计算器"},
        {79, "可回收物-卡片"},
        {80, "可回收物-水泵"},
        {81, "可回收物-书本"},
        {82, "可回收物-麦克风"},
        {83, "可回收物-手机"},
        {84, "可回收物-鼠标"},
        {85, "可回收物-包装"},
        {86, "可回收物-裤子"},
        {87, "可回收物-网线"},
        {88, "可回收物-枕头"},
        {89, "可回收物-塑料盆"},
        {90, "可回收物-塑料瓶"},
        {91, "可回收物-盘子"},
        {92, "可回收物-充电宝"},
        {93, "可回收物-收音机"},
        {94, "可回收物-遥控器"},
        {95, "可回收物-电饭煲"},
        {96, "可回收物-路由器"},
        {97, "可回收物-尺子"},
        {98, "可回收物-剪刀"},
        {99, "可回收物-鞋子"},
        {100, "可回收物-裙子"},
        {101, "可回收物-袜子"},
        {102, "可回收物-勺叉"},
        {103, "可回收物-不锈钢管"},
        {104, "可回收物-凳子"},
        {105, "可回收物-行李箱"},
        {106, "可回收物-桌子"},
        {107, "可回收物-乒乓球拍"},
        {108, "可回收物-望远镜"},
        {109, "可回收物-保温杯"},
        {110, "可回收物-轮胎"},
        {111, "可回收物-镊子"},
        {112, "可回收物-雨伞"},
        {113, "可回收物-手表"},
        {114, "可回收物-水瓶"},
        {115, "可回收物-水杯"},
        {116, "可回收物-钢丝球"},
        {117, "可回收物-木梳"},
        {118, "可回收物-木砧板"},
        {119, "可回收物-木铲"}
    };
};

#endif // GARBAGECLASSIFIER_H
