#ifndef __FPSITEM_H__
#define __FPSITEM_H__

#include <QQuickItem>
#include "src/stdafx.h"

class FpsItem : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(int, fps)
public:
    FpsItem();

private:
    int _frameCount = 0;
};
#endif // __FPSITEM_H__