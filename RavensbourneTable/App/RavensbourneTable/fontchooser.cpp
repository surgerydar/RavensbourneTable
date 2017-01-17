#include <QPainter>
#include <QRect>
#include <QFontMetrics>
#include <QFontDatabase>
#include <QDebug>
#include <vector>
#include <cmath>

#include "fontchooser.h"

const std::vector<QFont::Weight> weights = { QFont::Normal, QFont::Bold };

FontChooser::FontChooser(QQuickItem *parent) : CircularMenu(parent) {
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
    qreal position = .25;
    qreal positionIncrement = .25 / count;
    for ( int i = 0; i < count + 1; i++ ) {
        QColor colour;
        colour.setHslF(h,1.,.5);
        m_gradient.setColorAt(position,colour);
        h += hIncrement;
        position += positionIncrement;
    }
    m_gradient.setCoordinateMode(QGradient::ObjectBoundingMode);
    m_gradient.setCenter(1.,1.);
}

void FontChooser::paint(QPainter *painter) {
    CircularMenu::paint(painter);
    qreal w = width();
    qreal h = height();
    QPointF cp(w/2.,h/2.);
    qreal swatchRadius = w / 4.;
    QRect outerRect( 0, 0, w, h);
    QRect innerRect( swatchRadius,swatchRadius, swatchRadius*2, swatchRadius*2);
    QRect middleRect( swatchRadius / 2., swatchRadius / 2., swatchRadius*3, swatchRadius*3 );
    QFontMetrics metrics(m_font);
    QRect textBounds;
    //
    //
    //
    painter->setRenderHint(QPainter::Antialiasing);
    //
    // draw gradient
    //
    QBrush brush(m_gradient);
    painter->setBrush(brush);
    painter->setPen(Qt::NoPen);
    QRect gradientRect( 0, 0, w, h );
    painter->drawPath(m_colourPath);
    //
    // draw size selector
    //
    QFont font = m_font;
    qreal percent = 1./4;
    painter->setBrush(Qt::NoBrush);
    painter->setPen("black");
    const int sizes[4] = { 48, 32, 24, 16 };
    const qreal spacing[ 4 ] = {.2,.13,.1,0.066666666666667};
    for ( int i = 0; i < 4; i++ ) {
        font.setPixelSize(sizes[i]);
        painter->setFont(font);
        QPointF point = m_sizePath.pointAtPercent(percent);
        qreal angle = m_sizePath.angleAtPercent(percent);   // Clockwise is negative
        painter->save();
        // Move the virtual origin to the point on the curve
        painter->translate(point);
        // Rotate to match the angle of the curve
        // Clockwise is positive so we negate the angle from above
        painter->rotate(-angle);
        // Draw a line width above the origin to move the text above the line
        // and let Qt do the transformations
        metrics = painter->fontMetrics();
        textBounds = metrics.tightBoundingRect("A");
        painter->drawText(QPoint(-textBounds.width()/2, textBounds.height()/2),"A");
        painter->restore();
        percent += spacing[ i ];
    }
    //
    // draw family selector
    //
    font = m_font;
    font.setPixelSize(48);
    //QFont::Style style[3] = { QFont::Bold,
    QStringList families = QFontDatabase().families();
    for ( auto& family : families ) {
        //qDebug() << family;
    }
    //
    // draw weight selector
    //
    font = m_font;
    font.setPixelSize(32.);
    int count = weights.size();
    qreal percentIncrement = 1./(count + 1);
    percent = 1./4;
    for ( int i = 0; i < count; i++ ) {
        font.setWeight(weights[i]);
        painter->setFont(font);
        QPointF point = m_weightPath.pointAtPercent(percent);
        qreal angle = m_weightPath.angleAtPercent(percent);   // Clockwise is negative
        painter->save();
        // Move the virtual origin to the point on the curve
        painter->translate(point);
        // Rotate to match the angle of the curve
        // Clockwise is positive so we negate the angle from above
        painter->rotate(-angle);
        // Draw a line width above the origin to move the text above the line
        // and let Qt do the transformations
        metrics = painter->fontMetrics();
        textBounds = metrics.tightBoundingRect("A");
        painter->drawText(QPoint(-textBounds.width()/2, textBounds.height()/2),"A");
        painter->restore();
        percent += percentIncrement;
    }
    //
    // draw swatch
    //
    painter->setFont(m_font);
    painter->setPen(m_colour);
    metrics = painter->fontMetrics();
    textBounds = metrics.tightBoundingRect("Aa");
    painter->drawText(cp.x()-textBounds.width()/2.,cp.y()+textBounds.height()/2.,"Aa");
    //
    // draw outline
    //
    painter->setPen(Qt::black);
    painter->drawEllipse(outerRect);
    painter->drawEllipse(innerRect);
}
//
//
//
void FontChooser::setFontFromPoint( QPoint p ) {
    QPointF cp(width()/2.,height()/2.);
    QLineF line(cp,p);
    qreal angle = line.angle();
    qDebug() << "angle=" << angle;
    if ( angle < 90. ) { // size segment
        qreal size = 16 + ( ( angle / 90. ) * ( 48. - 16. ) );
        m_font.setPixelSize(size);
    } else if ( angle < 180. ) { // colour
        qreal h =  1. - (( angle - 90. ) / 90.);
        qreal minRadius = cp.x() / 2.;
        qreal l = std::max(0.,std::min(1.,(line.length()-minRadius)/minRadius));
        qDebug() << "h=" << h << " l=" << l;
        m_colour.setHslF(h,1.,l);
    } else if ( angle < 270. ) { // weight
        qreal f = (angle-180.) / 90.;
        int index = std::floor(4.*f);
        m_font.setWeight(weights[index]);
    } else {
        qreal f = (angle-270.) / 90.;
    }
    emit fontChanged(m_font,m_colour);
    update();
}
//
//
//
void FontChooser::mousePressEvent(QMouseEvent *event) {
    qDebug() << "mouse press [" << event->x() << "," << event->y() << "]";
}

void FontChooser::mouseMoveEvent(QMouseEvent *event) {
    qDebug() << "mouse move [" << event->x() << "," << event->y() << "]";
    setFontFromPoint(QPoint(event->x(),event->y()));
}

void FontChooser::mouseReleaseEvent(QMouseEvent *event) {
    qDebug() << "mouse release [" << event->x() << "," << event->y() << "]";
}
//
//
//
void FontChooser::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    CircularMenu::geometryChanged(newGeometry,oldGeometry);
    if ( newGeometry != oldGeometry ) {
        buildPaths();
    }
}

//
//
//
void FontChooser::buildPaths() {
    //
    //
    //
    qreal w = width();
    qreal h = height();
    qreal swatchRadius = w / 4.;
    QRect outerRect( 0, 0, w, h);
    QRect innerRect( swatchRadius,swatchRadius, swatchRadius*2, swatchRadius*2);
    QRect middleRect( swatchRadius / 2., swatchRadius / 2., swatchRadius*3, swatchRadius*3 );
    //
    // colour selector
    //
    m_colourPath = QPainterPath();
    m_colourPath.arcMoveTo(outerRect,90.);
    m_colourPath.arcTo(outerRect,90.,90.);
    m_colourPath.lineTo(innerRect.x(),h/2.);
    m_colourPath.arcTo(innerRect,180,-90.);
    m_colourPath.closeSubpath();
    //
    // size selector
    //
    m_sizePath = QPainterPath();
    m_sizePath.arcMoveTo(middleRect,90.);
    m_sizePath.arcTo(middleRect,90.,-90.);
    //
    // family selector
    //
    m_familyPath = QPainterPath();
    m_familyPath.arcMoveTo(middleRect,90.);
    m_familyPath.arcTo(middleRect,0.,-90.);
    //
    // weight selector
    //
    m_weightPath = QPainterPath();
    m_weightPath.arcMoveTo(middleRect,270.);
    m_weightPath.arcTo(middleRect,270.,-90.);
}

