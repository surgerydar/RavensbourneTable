#include <QFontMetrics>
#include <QDebug>
#include "segmentbutton.h"

SegmentButton::SegmentButton(qreal startAngle, qreal sweep, QString label, bool checkable) :
    SegmentControl(startAngle, sweep) {
    m_label = label;
    m_checkable = checkable;
    m_checked = false;
}

void SegmentButton::paint(QPainter *painter) {
    //
    // position label
    // NOTE: this assumes single letter, for now
    //
    qreal centerPercentage = ( ( 360. - m_startAngle ) - ( m_sweep / 2. ) ) / 360.;
    QPointF point = m_labelPath.pointAtPercent( centerPercentage );
    qreal angle = m_labelPath.angleAtPercent( centerPercentage );
    //
    //
    //
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);
    //
    //
    //
    painter->setPen(Qt::white);
    painter->setBrush((m_checked?QBrush("#00D2C2"):Qt::NoBrush));
    painter->drawPath(m_segment);
    //
    //
    //
    painter->setFont(m_font);
    painter->setPen(Qt::black);
    painter->setBrush(Qt::NoBrush);
    painter->translate(point);
    painter->rotate(-angle);
    QFontMetrics metrics = painter->fontMetrics();
    QRect textBounds = metrics.tightBoundingRect(m_label);
    painter->drawText(QPoint(-textBounds.width()/2, textBounds.height()/2),m_label);
    //
    //
    //
    painter->restore();
}

void SegmentButton::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    SegmentControl::geometryChanged(newGeometry,oldGeometry);
    //
    //
    //
    m_labelPath = QPainterPath();
    m_labelPath.addEllipse(m_middleRect);
}

//
//
//
bool SegmentButton::mousePressEvent(QMouseEvent *event) {
    return SegmentControl::mousePressEvent(event);
}

bool SegmentButton::mouseMoveEvent(QMouseEvent *event) {
    return SegmentControl::mouseMoveEvent(event);
}

bool SegmentButton::mouseReleaseEvent(QMouseEvent *event) {
    if ( SegmentControl::mouseReleaseEvent(event) ) {
        if ( m_checkable ) {
            m_checked = !m_checked;
        }
        return true;
    }
    return false;
}
