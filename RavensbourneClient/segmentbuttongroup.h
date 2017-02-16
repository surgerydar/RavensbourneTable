#ifndef SEGMENTBUTTONGROUP_H
#define SEGMENTBUTTONGROUP_H

#include <QMap>
#include "segmentcontrol.h"
#include "segmentbutton.h"

class SegmentButtonGroup : public SegmentControl
{
public:
    SegmentButtonGroup(qreal startAngle, qreal sweep);
    void paint(QPainter *painter) override;
    virtual void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) override;
    //
    //
    //
    virtual bool mousePressEvent(QMouseEvent *event) override;
    virtual bool mouseMoveEvent(QMouseEvent *event) override;
    virtual bool mouseReleaseEvent(QMouseEvent *event) override;
    //
    //
    //
    void addButton( QString name, SegmentButton* button);
    void removeButton( QString name );
    void selectButton( QString name );
    QString selectedButton();
protected:
    QMap<QString,SegmentButton*> m_buttons;
};

#endif // SEGMENTBUTTONGROUP_H
