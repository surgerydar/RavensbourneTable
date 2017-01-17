#ifndef HSLSEGMENTCONTROL_H
#define HSLSEGMENTCONTROL_H

#include "segmentcontrol.h"
#include <QColor>
#include <QConicalGradient>

class HslSegmentControl : public SegmentControl
{
public:
    HslSegmentControl(qreal startAngle,qreal sweep);
    virtual void paint(QPainter*painter) override;
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
    QColor getColour() { return m_colour; };

protected:
    void setColourFromPoint(QPointF point);
    QColor              m_colour;
    QConicalGradient    m_gradient;
};

#endif // HSLSEGMENTCONTROL_H
