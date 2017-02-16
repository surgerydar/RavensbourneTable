#ifndef LINEWIDTHSEGMENTCONTROL_H
#define LINEWIDTHSEGMENTCONTROL_H

#include <QPainterPath>
#include "segmentcontrol.h"

class LineWidthSegmentControl : public SegmentControl
{
public:
    LineWidthSegmentControl(qreal startAngle,qreal sweep, qreal minWidth, qreal maxWidth );
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
    qreal getLineWidth() { return m_lineWidth; }

protected:
    void setLineWidthFromPoint(QPointF point);
    qreal m_minWidth;
    qreal m_maxWidth;
    qreal m_lineWidth;
    QPainterPath m_penPath;
};

#endif // LINEWIDTHSEGMENTCONTROL_H
