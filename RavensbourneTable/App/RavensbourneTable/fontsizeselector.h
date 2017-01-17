#ifndef FONTSIZESELECTOR_H
#define FONTSIZESELECTOR_H

#include "segmentcontrol.h"

class FontSizeSelector : public SegmentControl
{
public:
    FontSizeSelector( qreal startAngle, qreal sweep, qreal minSize, qreal maxSize );
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
    qreal getSize() { return m_size; }
    void setSize(qreal size) { m_size = size; }
    //
    //
    //
    void setFont( QFont font ) { m_font = font; m_size = m_font.pixelSize(); }
protected:
    void setSizeFromPoint(QPointF point);
    qreal m_minSize;
    qreal m_maxSize;
    qreal m_size;
    //
    //
    //
    QFont           m_font;
    QPainterPath    m_textPath;
};

#endif // FONTSIZESELECTOR_H
