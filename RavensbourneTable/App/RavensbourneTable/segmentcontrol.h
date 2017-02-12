#ifndef SEGMENTCONTROL_H
#define SEGMENTCONTROL_H

#include <QPainterPath>
#include <QPainter>
#include <QMouseEvent>
#include <QMap>

class SegmentControl
{
public:
    SegmentControl( qreal startAngle, qreal sweep );
    virtual void paint(QPainter*painter);
    virtual void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);
    //
    //
    //
    virtual bool mousePressEvent(QMouseEvent *event);
    virtual bool mouseMoveEvent(QMouseEvent *event);
    virtual bool mouseReleaseEvent(QMouseEvent *event);
protected:
    void createOutline();
    qreal valueAtAngle( qreal angle );
    qreal wrapInterpolation(qreal u);
    qreal   m_startAngle;
    qreal   m_sweep;
    QRectF  m_outerRect;
    QRectF  m_middleRect;
    QRectF  m_innerRect;
    QPainterPath m_segment;

};

#endif // SEGMENTCONTROL_H
