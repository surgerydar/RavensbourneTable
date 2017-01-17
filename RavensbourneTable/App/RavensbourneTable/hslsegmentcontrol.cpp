#include "hslsegmentcontrol.h"

HslSegmentControl::HslSegmentControl(qreal startAngle, qreal sweep) : SegmentControl(startAngle,sweep) {
    //
    // setup hsl gradient
    //
    int count = 180;
    qreal position = startAngle / 360.;
    qreal positionIncrement = ( sweep / 360. ) / count;
    qreal hue = 0.;
    qreal hueIncrement = 1. / count;
    for ( int i = 0; i < count + 1; i++ ) {
        QColor colour;
        colour.setHslF(hue,1.,.5);
        m_gradient.setColorAt(position,colour);
        hue += hueIncrement;
        position += positionIncrement;
    }
    m_gradient.setCoordinateMode(QGradient::ObjectBoundingMode);
    m_gradient.setCenter(.5,.5);
}

void HslSegmentControl::paint(QPainter*painter) {
    SegmentControl::paint(painter);
    //
    //
    //
    painter->save();
    //
    // draw gradient
    //
    QBrush brush(m_gradient);
    painter->setBrush(brush);
    painter->setPen(Qt::NoPen);
    painter->drawPath(m_segment);
    //
    //
    //
    painter->restore();
}

void HslSegmentControl::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    SegmentControl::geometryChanged(newGeometry,oldGeometry);
    //
    // adjust gradient center
    //
    QPointF controlCenter = m_outerRect.center();
    QRectF segmentBounds = m_segment.boundingRect();
    QPointF segmentCenter = segmentBounds.center();
    QPointF gradientCenter( 0.5 + ( controlCenter.x() - segmentCenter.x() ) / segmentBounds.width(),
                            0.5 + ( controlCenter.y() - segmentCenter.y() ) / segmentBounds.height());
    m_gradient.setCenter(gradientCenter);
}
//
//
//
bool HslSegmentControl::mousePressEvent(QMouseEvent *event) {
    if ( SegmentControl::mousePressEvent(event) ) {
        setColourFromPoint(event->localPos());
        return true;
    }
    return false;
}

bool HslSegmentControl::mouseMoveEvent(QMouseEvent *event) {
    if ( SegmentControl::mouseMoveEvent(event) ) {
        setColourFromPoint(event->localPos());
        return true;
    }
    return false;
}

bool HslSegmentControl::mouseReleaseEvent(QMouseEvent *event) {
    if ( SegmentControl::mouseReleaseEvent(event) ) {
        setColourFromPoint(event->localPos());
        return true;
    }
    return false;
}
//
//
//
void HslSegmentControl::setColourFromPoint(QPointF point) {
    QPointF centerPoint = m_outerRect.center();
    QLineF line(centerPoint,point);
    qreal angle = line.angle();
    qreal distance = line.length();
    //
    //
    //
    qreal hue = SegmentControl::valueAtAngle(angle);
    qreal lightness = ( distance - ( m_innerRect.width() / 2. ) ) / ( (m_outerRect.width()-m_innerRect.width()) / 2.);
    //
    //
    //
    m_colour.setHslF(hue,1.,lightness);

}

