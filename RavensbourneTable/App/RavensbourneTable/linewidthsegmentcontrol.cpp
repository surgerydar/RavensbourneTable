#include "linewidthsegmentcontrol.h"

LineWidthSegmentControl::LineWidthSegmentControl(qreal startAngle,qreal sweep, qreal minWidth, qreal maxWidth ) :
    SegmentControl(startAngle,sweep),
    m_lineWidth( minWidth ),
    m_minWidth( minWidth ),
    m_maxWidth( maxWidth ) {
}

void LineWidthSegmentControl::paint(QPainter*painter) {
    //SegmentControl::paint(painter);
    //
    //
    //
    painter->save();
    qreal margin = 5.;
    qreal ellipseUBase = ( 360. - ( m_startAngle + margin ) ) / 360.; // start ellipse interpolation
    //qreal ellipseUExtent = -( m_sweep - margin * 2. ) / 360.;
    qreal ellipseUExtent = -( m_sweep - margin ) / 360.;
    qreal ellipseU = ellipseUBase;
    painter->setBrush(Qt::NoBrush);
    QBrush blackBrush("black");
    qreal sizeU = 0.;
    const int count = 10;
    qreal sizeUIncr = 1./count;
    qreal pointOffset = ( m_outerRect.height() - m_innerRect.height() ) * .1;
    QPointF p1( 0., -pointOffset );
    QPointF p2( 0., +pointOffset );
    for ( int i = 0; i < count; i++ ) {
        painter->save();
        //
        // interpolate pensize
        //
        QPen pen(blackBrush, m_minWidth + ( m_maxWidth - m_minWidth ) * sizeU, Qt::SolidLine, Qt::RoundCap);
        painter->setPen(pen);
        //
        //
        //
        QPointF point   = m_penPath.pointAtPercent(wrapInterpolation(ellipseU));
        qreal angle     = m_penPath.angleAtPercent(wrapInterpolation(ellipseU));
        //
        // Move the virtual origin to the point on the curve
        //
        painter->translate(point);
        painter->rotate(-angle);
        //
        //
        painter->drawLine(p1,p2);
        //
        //
        //
        painter->restore();
        //
        // move on
        //
        sizeU += sizeUIncr;
        ellipseU = ellipseUBase + ellipseUExtent * sizeU;
    }
    painter->restore();
}

void LineWidthSegmentControl::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    SegmentControl::geometryChanged(newGeometry,oldGeometry);
    //
    // adjust gradient center
    //
    m_penPath = QPainterPath();
    m_penPath.addEllipse(m_middleRect);
}
//
//
//
bool LineWidthSegmentControl::mousePressEvent(QMouseEvent *event) {
    if ( SegmentControl::mousePressEvent(event) ) {
        setLineWidthFromPoint(event->localPos());
        return true;
    }
    return false;
}

bool LineWidthSegmentControl::mouseMoveEvent(QMouseEvent *event) {
    if ( SegmentControl::mouseMoveEvent(event) ) {
        setLineWidthFromPoint(event->localPos());
        return true;
    }
    return false;
}

bool LineWidthSegmentControl::mouseReleaseEvent(QMouseEvent *event) {
    if ( SegmentControl::mouseReleaseEvent(event) ) {
        setLineWidthFromPoint(event->localPos());
        return true;
    }
    return false;
}
//
//
//
void LineWidthSegmentControl::setLineWidthFromPoint(QPointF point) {
    QPointF centerPoint = m_outerRect.center();
    QLineF line(centerPoint,point);
    qreal angle = line.angle();
    //
    //
    //
    qreal value = std::max(.0,std::min(1.,SegmentControl::valueAtAngle(angle)));
    m_lineWidth = m_minWidth + ( m_maxWidth - m_minWidth ) * value;
}


