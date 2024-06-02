#ifndef __LOG_H__
#define __LOG_H__

#include <QtCore/qstring.h>

namespace Log
{
    QString prettyProductInfoWrapper();

    void setup(char *argv[], const QString &app, int level = 4);
}

#endif // __LOG_H__