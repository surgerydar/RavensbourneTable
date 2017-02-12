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
        pen.setCapStyle(Qt::RoundCap);
        painter->setPen(pen);
        painter->drawPolyline(line.polygon());
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

QString Drawing::startLine(QPoint p, qreal width, QColor colour) {
    m_lines.push_back(PolyLine());
    m_lines.back().setLineWidth(width);
    m_lines.back().setColour(colour);
    QVector2D v(p.x(),p.y());
    m_lines.back().curveto(v);
    m_lines.back().curveto(v);
    m_lastPoint = v;
    return m_lines.back().getId();
}

QString Drawing::endLine(QPoint p) {
    QVector2D v(p.x(),p.y());
    m_lines.back().curveto(v);
    m_lines.back().curveto(v);
    m_lines.back().simplify();
    update();
    return m_lines.back().getId();
}

QString Drawing::addPoint(QPoint p) {
    QVector2D v(p.x(),p.y());
    if ( (v - m_lastPoint ).length() >= lengthThreshold ) {
        m_lines.back().curveto(v);
        m_lastPoint = v;
        update();
    }
    return m_lines.back().getId();
}
//
//
//
//
//
//
QVariant Drawing::getLine( QString id ) {
    for ( auto& line : m_lines ) {
        if ( line.getId() == id ) {
            return line.save();
        }
    }
    return QVariant();
}

//
//
//
int Drawing::pathAt( QPoint p ) {
    float minDistance = std::numeric_limits<float>::max();
    int currentNearest = -1;
    int count = (int)m_lines.size();
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

void Drawing::movePathAtIndex( int index, QPoint by ) {
    if ( index >= 0 && index < m_lines.size() ) {
        QVector2D v( by.x(), by.y() );
        m_lines[ index ].move( v );
    }
}

QString Drawing::deletePathAtIndex( int index ) {
    if ( index >= 0 && index < m_lines.size() ) {
        QString lineId = m_lines[index].getId();
        m_lines.erase(m_lines.begin()+index);
        update();
        return lineId;
    }
    return "";
}

void Drawing::movePath( QString id, QPoint by ) {

}

void Drawing::deletePath( QString id ) {
    for ( int i = 0; i < m_lines.size(); i++ ) {
        if ( m_lines[i].getId() == id ) {
            m_lines.erase(m_lines.begin()+i);
            break;
        }
    }
}

void Drawing::addPath( QVariant path ) {
    m_lines.resize(m_lines.size()+1);
    m_lines.back().load(path);
    update();
}

QVariant Drawing::getBounds() {
    QRectF bounds;
    for ( auto& line : m_lines ) {
        QRectF lineBounds = line.getBounds();
        if ( bounds.width() <= 0. && bounds.height() <= 0 ) {
            bounds = lineBounds;
        } else {
            bounds = bounds.united(lineBounds);
        }
    }
    return bounds;
}


