#include <QPainter>

#include "circularmenu.h"

CircularMenu::CircularMenu(QQuickItem* parent) : QQuickPaintedItem(parent) {
    //
    //
    //
    setAcceptedMouseButtons(Qt::AllButtons);

}
void CircularMenu::paint(QPainter *painter) {
    //
    //
    //
    painter->save();
    painter->setBrush(QBrush(Qt::white));
    painter->setPen(Qt::black);
    painter->drawPath(m_outerPath);
    painter->drawPath(m_innerPath);
    //
    //
    //
    for ( auto control : m_controls ) {
        control->paint(painter);
    }
    painter->restore();
}

void CircularMenu::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    QQuickPaintedItem::geometryChanged(newGeometry,oldGeometry);
    if ( newGeometry != oldGeometry ) {
        layout();
        //
        // layout controls
        //
        for ( auto control : m_controls ) {
            control->geometryChanged(newGeometry,oldGeometry);
        }
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
//
//
void CircularMenu::addControl(QString name,SegmentControl* control) {
    m_controls[name] = control;
}

void CircularMenu::removeControl(QString name) {
    m_controls.remove(name);
}

//
//
//
QString CircularMenu::mousePressControls( QMouseEvent* event ) {
    QMap<QString,SegmentControl*>::iterator it = m_controls.begin();
    for (; it != m_controls.end(); ++it ) {
        if ( it.value()->mousePressEvent(event) ) return it.key();
    }
    return "";
}

QString CircularMenu::mouseMoveControls( QMouseEvent* event ) {
    QMap<QString,SegmentControl*>::iterator it = m_controls.begin();
    for (; it != m_controls.end(); ++it ) {
        if ( it.value()->mouseMoveEvent(event) ) return it.key();
    }
    return "";
}

QString CircularMenu::mouseReleaseControls( QMouseEvent* event ) {
    QMap<QString,SegmentControl*>::iterator it = m_controls.begin();
    for (; it != m_controls.end(); ++it ) {
        if ( it.value()->mouseReleaseEvent(event) ) return it.key();
    }
    return "";
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
    //segment.lineTo(innerPoint.x(),innerPoint.y());
    segment.arcTo(innerRect,startAngle+sweep,-sweep);
    segment.closeSubpath();

    return segment;
}


