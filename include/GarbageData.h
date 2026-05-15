#ifndef GARBAGEDATA_H
#define GARBAGEDATA_H

#pragma once
#include <QString>
#include <QStringList>
#include <QMap>

class GarbageData {
public:
    static const QStringList& categories();
    static const QMap<int, QString>& chineseNames();
    static const QMap<int, QString>& suggestions();
};

#endif // GARBAGEDATA_H
