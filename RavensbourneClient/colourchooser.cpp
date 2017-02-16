#include <QPainter>
#include <QLineF>
#include <QDebug>
#include <cmath>

#include "colourchooser.h"

ColourChooser::ColourChooser(QQuickItem *parent) :
    QQuickPaintedItem(parent),
    m_colour("steelblue") {
    //
    //
    //
    setAcceptedMouseButtons(Qt::AllButtons);
    //
    // setup hsl gradient
    //
    int count = 180;
    qreal h = 0.;
    qreal hIncrement = 1. / count;
    for ( int i = 0; i < count + 1; i++ ) {
        QColor colour;
        colour.setHslF(h,1.,.5);
        m_gradient.setColorAt(h,colour);
        h += hIncrement;
    }
    m_gradient.setCoordinateMode(QGradient::ObjectBoundingMode);
    m_gradient.setCenter(.5,.5);
}

void ColourChooser::paint(QPainter *painter) {
    //
    //
    //
    painter->setRenderHint(QPainter::Antialiasing);
    //
    // draw gradient
    //
    QBrush brush(m_gradient);
    painter->setBrush(brush);
    QRect gradientRect( 0, 0, width(), height() );
    painter->drawEllipse(gradientRect);
    //
    // draw swatch
    //
    QBrush colour(m_colour);
    QRect colourRect( width()/4,height()/4,width()/2,height()/2);
    painter->setBrush(colour);
    painter->drawEllipse(colourRect);
}
//
//
//
void ColourChooser::setColour( QColor colour ) {
    m_colour = colour;
    //
    // request redraw
    //
    update();
}

void ColourChooser::setColourFromPoint( QPoint p ) {
    //
    // update colour
    //
    QPointF cp(width()/2.,height()/2.);
    QLineF line(cp,p);
    qreal h = line.angle()/360.;
    qreal s = 1.;
    qreal swatchRadius = cp.x() / 2.;
    qreal l = std::max(0.,std::min(1.,(line.length()-swatchRadius)/swatchRadius));
    qDebug() << "radius=" << swatchRadius << " length=" << line.length();
    m_colour.setHslF(h,s,l);
    QGradientStops stops = m_gradient.stops();
    for ( auto& stop : stops ) {
        h = stop.second.hslHueF();
        stop.second.setHslF(h,s,l);
    }
    m_gradient.setStops(stops);
    //
    // signal change
    //
    emit colourChanged(m_colour);
    //
    // request redraw
    //
    update();
}

QColor ColourChooser::getColour() {
    return m_colour;
}
//
//
//
void ColourChooser::mousePressEvent(QMouseEvent *event) {
    qDebug() << "mouse press [" << event->x() << "," << event->y() << "]";
}

void ColourChooser::mouseMoveEvent(QMouseEvent *event) {
    qDebug() << "mouse move [" << event->x() << "," << event->y() << "]";
    setColourFromPoint(QPoint(event->x(),event->y()));
}

void ColourChooser::mouseReleaseEvent(QMouseEvent *event) {
    qDebug() << "mouse release [" << event->x() << "," << event->y() << "]";
}
//
//
//
void ColourChooser::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    QQuickPaintedItem::geometryChanged(newGeometry,oldGeometry);
    if ( newGeometry != oldGeometry ) {

    }
}



