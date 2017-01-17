#include "fontsizeselector.h"

FontSizeSelector::FontSizeSelector(qreal startAngle, qreal sweep, qreal minSize, qreal maxSize) : SegmentControl( startAngle, sweep ) {
    m_minSize = minSize;
    m_maxSize = maxSize;
}
void FontSizeSelector::paint(QPainter *painter) {
    SegmentControl::paint(painter);
    //
    //
    //
    painter->save();
    QFont font = m_font;
    qreal percent = ( 360. - m_startAngle ) / 360.; // ellipse appears to go clockwise???
    qreal percentExtent = -m_sweep / 360.;
    percent += percentExtent * .25; // Fudge a margin
    painter->setBrush(Qt::NoBrush);
    painter->setPen("black");
    const int sizes[4] = { 48, 32, 24, 16 }; // TODO: adjust size relative to sweep
    const qreal spacing[ 4 ] = {.2,.13,.1,0.066666666666667};
    for ( int i = 0; i < 4; i++ ) {
        font.setPixelSize(sizes[i]);
        painter->setFont(font);
        QPointF point = m_textPath.pointAtPercent(percent);
        qreal angle = m_textPath.angleAtPercent(percent);
        painter->save();
        // Move the virtual origin to the point on the curve
        painter->translate(point);
        // Rotate to match the angle of the curve
        // Clockwise is positive so we negate the angle from above
        painter->rotate(-angle);
        // Draw a line width above the origin to move the text above the line
        // and let Qt do the transformations
        QFontMetrics metrics = painter->fontMetrics();
        QRectF textBounds = metrics.tightBoundingRect("A");
        painter->drawText(QPoint(-textBounds.width()/2, textBounds.height()/2),"A");
        painter->restore();
        percent += percentExtent * spacing[ i ];
    }
    painter->restore();
}

void FontSizeSelector::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    SegmentControl::geometryChanged(newGeometry,oldGeometry);
    m_textPath = QPainterPath();
    m_textPath.addEllipse(m_middleRect);
}
//
//
//
bool FontSizeSelector::mousePressEvent(QMouseEvent *event) {
    if ( SegmentControl::mousePressEvent(event) ) {
        setSizeFromPoint(event->localPos());
        return true;
    }
    return false;
}

bool FontSizeSelector::mouseMoveEvent(QMouseEvent *event) {
    if ( SegmentControl::mouseMoveEvent(event) ) {
        setSizeFromPoint(event->localPos());
        return true;
    }
    return false;
}

bool FontSizeSelector::mouseReleaseEvent(QMouseEvent *event) {
    if ( SegmentControl::mouseReleaseEvent(event) ) {
        setSizeFromPoint(event->localPos());
        return true;
    }
    return false;
}

void FontSizeSelector::setSizeFromPoint(QPointF point) {
    QPointF centerPoint = m_outerRect.center();
    QLineF line(centerPoint,point);
    qreal angle = line.angle();
    qreal value = 1. - SegmentControl::valueAtAngle(angle);
    m_size = m_minSize + ( m_maxSize - m_minSize ) * value;
}
