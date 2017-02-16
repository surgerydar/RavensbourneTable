#include <cstdlib>
#include "linestylechooser.h"

static qreal rangeRandom( qreal lower, qreal upper ) {
    return lower + ( upper - lower ) * ( ( qreal ) std::rand() / ( qreal ) RAND_MAX );
}

LineStyleChooser::LineStyleChooser(QQuickItem *parent) :
    CircularMenu(parent),
    m_colourSelector(45,180.),
    m_widthSelector( 225., 180., 4., 24. ) {
    //
    //
    //
    addControl("width",&m_widthSelector);
    addControl("colour",&m_colourSelector);
    //
    //
    //
    /*
    QRectF swatchBounds = m_innerPath.boundingRect();
    qreal safeDim = std::sqrt( (swatchBounds.width()*swatchBounds.width()) / 2.);
    qreal safeOffset = ( swatchBounds.width() - safeDim ) * .5;
    QRectF safeArea( swatchBounds.x() + safeOffset, swatchBounds.y() + safeOffset, safeDim, safeDim );
    m_swatch.moveTo(rangeRandom(safeArea.left(),safeArea.right()),rangeRandom(safeArea.top(),safeArea.bottom()));
    for ( int i = 0; i < 10; i++ ) {
        qreal x = rangeRandom(safeArea.left(),safeArea.right());
        qreal y = rangeRandom(safeArea.top(),safeArea.bottom());
        qreal w = rangeRandom(safeArea.left(),safeArea.right());
        qreal h = rangeRandom(safeArea.top(),safeArea.bottom());
        qreal start = rangeRandom(0.,360.);
        qreal size = rangeRandom(0.,360.);
        m_swatch.arcTo(x,y,w,h,start,size);
    }
    */
    updateStyle();
}

void LineStyleChooser::paint(QPainter *painter) {
    painter->setRenderHint(QPainter::Antialiasing);
    //
    //
    //
    CircularMenu::paint(painter);
    //
    // draw swatch
    //
    QRectF innerRect = m_innerPath.boundingRect();
    painter->save();
    QBrush brush(m_colour);
    QPen pen(brush, m_width, Qt::SolidLine, Qt::RoundCap);
    painter->setPen(pen);
    QPointF p1( innerRect.x() + innerRect.width() * .35, innerRect.y() + innerRect.height() * .5 );
    QPointF p2( innerRect.x() + innerRect.width() * .65, innerRect.y() + innerRect.height() * .5 );
    painter->drawLine(p1,p2);
    /*
    painter->drawPath(m_swatch);
    */
    //
    // draw outline
    //
    painter->setPen(Qt::black);
    painter->drawPath(m_outerPath);
    painter->drawPath(m_innerPath);
    painter->restore();
}
//
//
//
void LineStyleChooser::mousePressEvent(QMouseEvent *event) {
    QString control = mousePressControls(event);
    if ( control.length() > 0 ) {
        updateStyle();
    } else {
        event->ignore();
    }
}

void LineStyleChooser::mouseMoveEvent(QMouseEvent *event) {
    QString control = mouseMoveControls(event);
    if ( control.length() > 0 ) {
        updateStyle();
    } else {
        event->ignore();
    }
}

void LineStyleChooser::mouseReleaseEvent(QMouseEvent *event) {
    QString control = mouseReleaseControls(event);
    if ( control.length() > 0 ) {
        updateStyle();
    } else {
        event->ignore();
    }
}

//
//
//
void LineStyleChooser::updateStyle() {
    QColor oldColour = m_colour;
    qreal oldWidth = m_width;
    m_colour = m_colourSelector.getColour();
    m_width = m_widthSelector.getLineWidth();
    if ( m_colour != oldColour || m_width != oldWidth ) {
        update();
        emit styleChanged(m_width,m_colour);
    }

}
