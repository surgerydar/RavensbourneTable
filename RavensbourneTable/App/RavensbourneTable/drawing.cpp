#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QPainter>
#include <QDebug>
#include "drawing.h"

const float lengthThreshold = 8.;

Drawing::Drawing(QQuickItem *parent) : QQuickPaintedItem(parent) {
}

void Drawing::paint(QPainter *painter) {
    painter->setBrush(Qt::NoBrush);
    painter->setRenderHint(QPainter::Antialiasing);
    for ( auto& line : m_lines ) {
        QPen pen(line.getColour());
        pen.setWidth(line.getLineWidth());
        painter->setPen(pen);
        painter->drawPolyline(line.polygon());
        //painter->drawLines(line.points());
    }
}
//
//
//
void Drawing::clear() {
    m_lines.clear();
    update();
}
QVariant Drawing::save() {
    QVariantList lines;
    for ( auto& line : m_lines ) {
        lines.append(line.save());
    }
    return QVariant::fromValue(lines);
}

void Drawing::load( const QVariant& drawing ) {
    QVariantList lines = drawing.toList();
    clear();
    int count = lines.size();
    qDebug() << "Drawing::load : " << count << " lines";
    m_lines.resize(count);
    for ( int i = 0; i < count; i++ ) {
        m_lines[i].load(lines[i]);
    }
    update();
}

void Drawing::startLine(QPoint p, QColor colour) {
    m_lines.push_back(PolyLine());
    m_lines.back().setColour(colour);
    QVector2D v(p.x(),p.y());
    m_lines.back().curveto(v);
    m_lines.back().curveto(v);
    m_lastPoint = v;
}

void Drawing::endLine(QPoint p) {
    QVector2D v(p.x(),p.y());
    m_lines.back().curveto(v);
    m_lines.back().curveto(v);
    update();
}

void Drawing::addPoint(QPoint p) {
    QVector2D v(p.x(),p.y());
    if ( (v - m_lastPoint ).length() < lengthThreshold ) return; // TODO: move threshol into Polyline
    m_lines.back().curveto(v);
    m_lastPoint = v;
    update();
}
//
//
//
int Drawing::pathAt( QPoint p ) {
    float minDistance = std::numeric_limits<float>::max();
    int currentNearest = -1;
    int count = m_lines.size();
    QVector2D target( p.x(), p.y() );
    for ( int i = 0; i < count; i++ ) {
        float distance = ( m_lines[ i ].nearestPoint(target) - target ).length();
        if ( distance < minDistance ) {
            minDistance = distance;
            currentNearest = i;
        }
    }
    return minDistance < 10. ? currentNearest : -1;
}

void Drawing::movePath( int index, QPoint by ) {

}

void Drawing::deletePath( int index ) {
    if ( index >= 0 && index < m_lines.size() ) {
        m_lines.erase(m_lines.begin()+index);
        update();
    }
}


