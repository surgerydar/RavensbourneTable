#include <QPainter>

#include "circularmenu.h"

CircularMenu::CircularMenu(QQuickItem* parent) : QQuickPaintedItem(parent) {

}
void CircularMenu::paint(QPainter *painter) {
    painter->setBrush(Qt::NoBrush);
    painter->setPen(Qt::black);
    painter->drawPath(m_outerPath);
    painter->drawPath(m_innerPath);
}

void CircularMenu::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    QQuickPaintedItem::geometryChanged(newGeometry,oldGeometry);
    if ( newGeometry != oldGeometry ) {
        layout();
    }
}

void CircularMenu::layout() {
    qreal w = width();
    qreal h = height();
    qreal swatchRadius = w / 4.;
    QRect outerRect( 0, 0, w, h);
    QRect middleRect( swatchRadius / 2., swatchRadius / 2., swatchRadius*3, swatchRadius*3 );
    QRect innerRect( swatchRadius,swatchRadius, swatchRadius*2, swatchRadius*2);
    //
    //
    //
    m_outerPath = QPainterPath();
    m_outerPath.addEllipse(outerRect);
    m_middlePath = QPainterPath();
    m_middlePath.addEllipse(outerRect);
    m_innerPath = QPainterPath();
    m_innerPath.addEllipse(outerRect);
}
//
// get segment
//
QPainterPath CircularMenu::getSegment( qreal startAngle, qreal sweep ) {
    qreal w = width();
    qreal h = height();
    qreal swatchRadius = w / 4.;
    QRect outerRect( 0, 0, w, h);
    QRect middleRect( swatchRadius / 2., swatchRadius / 2., swatchRadius*3, swatchRadius*3 );
    QRect innerRect( swatchRadius,swatchRadius, swatchRadius*2, swatchRadius*2);
    //
    //
    //
    QPointF innerPoint = m_innerPath.pointAtPercent((startAngle+sweep)/360.);
    //
    //
    //
    QPainterPath segment;
    segment.arcMoveTo(outerRect,startAngle);
    segment.arcTo(outerRect,startAngle,sweep);
    segment.lineTo(innerPoint.x(),innerPoint.y());
    segment.arcTo(innerRect,startAngle+sweep,-sweep);
    segment.closeSubpath();

}


