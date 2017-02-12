#include <QMouseEvent>
#include "segmentcontrol.h"

SegmentControl::SegmentControl(qreal startAngle, qreal sweep) {
    m_startAngle = startAngle;
    m_sweep = sweep;
}
void SegmentControl::paint(QPainter*painter) {
    painter->save();
    painter->setBrush(Qt::NoBrush);
    painter->setPen(Qt::black);
    painter->drawPath(m_segment);
    painter->restore();
}

void SegmentControl::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    qreal w = newGeometry.width();
    qreal h = newGeometry.height();
    qreal innerRadius = w / 4.;
    m_outerRect = QRectF( 0, 0, w, h);
    m_middleRect = QRectF( innerRadius / 2., innerRadius / 2., innerRadius*3, innerRadius*3 );
    m_innerRect = QRectF( innerRadius, innerRadius, innerRadius*2, innerRadius*2);
    createOutline();
}

//
//
//
bool SegmentControl::mousePressEvent(QMouseEvent *event) {
    return m_segment.contains(event->localPos());
}

bool SegmentControl::mouseMoveEvent(QMouseEvent *event) {
    return m_segment.contains(event->localPos());
}

bool SegmentControl::mouseReleaseEvent(QMouseEvent *event) {
    return m_segment.contains(event->localPos());
}
//
//
//
void SegmentControl::createOutline() {
    m_segment = QPainterPath();
    m_segment.arcMoveTo(m_outerRect,m_startAngle);
    m_segment.arcTo(m_outerRect,m_startAngle,m_sweep);
    m_segment.arcTo(m_innerRect,m_startAngle+m_sweep,-m_sweep);
    m_segment.closeSubpath();

}
qreal SegmentControl::valueAtAngle( qreal angle ) {
    qreal wrappedAngle = angle < m_startAngle ? 360. + angle : angle;
    qreal localAngle = wrappedAngle - m_startAngle;
    if ( localAngle < 0 ) {
        return 0.;
    } else if ( localAngle > m_sweep ) {
        return 1.;
    }
    return localAngle / m_sweep;
}
qreal SegmentControl::wrapInterpolation(qreal u) {
    qreal wrappedU = u;
    if ( u < 0. ) {
        wrappedU = 1. + u;
    } else if ( u > 1. ) {
        wrappedU = u - 1.;
    }
    return wrappedU;
}

