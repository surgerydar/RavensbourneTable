#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QPainter>
#include <QtMath>
#include <QDebug>
#include "drawing.h"

const float lengthThreshold = 8.;

Drawing::Drawing(QQuickItem *parent) : QQuickPaintedItem(parent) {
    m_lineOpen = false;
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
    m_lineOpen = true;
    return m_lines.back().getId();
}

QString Drawing::endLine(QPoint p) {
    QVector2D v(p.x(),p.y());
    m_lines.back().curveto(v);
    m_lines.back().curveto(v);
    m_lines.back().simplify();
    update();
    m_lineOpen = false;
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
void Drawing::cancelLine() {
    if ( m_lineOpen && m_lines.size() > 0 ) {
        m_lines.erase(m_lines.begin()+m_lines.size()-1);
    }
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
QVariant Drawing::getLineAtIndex( int index ) {
    if ( index >= 0 && index < m_lines.size() ) {
        return m_lines[ index ].save();
    }
    return QVariant();
}
int Drawing::getLineIndex( QString id ) {
    int count = m_lines.size();
    for ( int i = 0; i < count; i++ ) {
        if ( m_lines[i].getId() == id ) return i;
    }
    return -1;
}
QString Drawing::getLineId( int index ) {
    if ( index >= 0 && index < m_lines.size() ) {
        return m_lines[ index ].getId();
    }
    return QString();
}
//
//
//
void Drawing::restoreLine( QString id, QVariant data ) {
    for ( auto& line : m_lines ) {
        if ( line.getId() == id ) {
            line.load(data);
            break;
        }
    }
}

void Drawing::restoreLineAtIndex( int index, QVariant data ) {
    if ( index >= 0 && index < m_lines.size() ) {
        m_lines[ index ].load(data);
        update();
    }
}
void Drawing::insertLineAtIndex( int index, QVariant data ) {
    int i = std::max(0,std::min((int)m_lines.size(),index));
    std::vector<PolyLine>::iterator it = m_lines.insert(m_lines.begin()+i,PolyLine());
    it->load(data);
    update();
}
//
//
//
int Drawing::lineIndexAt( QPoint p ) {
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

void Drawing::moveLineAtIndex( int index, QPoint by ) {
    if ( index >= 0 && index < m_lines.size() ) {
        QVector2D v( by.x(), by.y() );
        m_lines[ index ].move( v );
        update();
    }
}

void Drawing::rotateLineAtIndex( int index, QPoint cp, float angle ) {
    float angleRad = qDegreesToRadians(angle);
    if ( index >= 0 && index < m_lines.size() ) {
        QVector2D v( cp.x(), cp.y() );
        m_lines[ index ].rotate( v, angleRad );
        update();
    }
}

void Drawing::scaleLineAtIndex( int index, QPoint cp, float scale ) {
    if ( index >= 0 && index < m_lines.size() ) {
        QVector2D v( cp.x(), cp.y() );
        m_lines[ index ].scale( v, scale );
        update();
    }
}

QString Drawing::deleteLineAtIndex( int index ) {
    if ( index >= 0 && index < m_lines.size() ) {
        QString lineId = m_lines[index].getId();
        m_lines.erase(m_lines.begin()+index);
        update();
        return lineId;
    }
    return "";
}

void Drawing::moveLine( QString id, QPoint by ) {
    QVector2D v( by.x(), by.y() );
    for ( auto& line : m_lines ) {
        if ( line.getId() == id ) {
            line.move( v );
            update();
            break;
        }
    }
}

void Drawing::moveBy( QPoint by ) {
    QVector2D v( by.x(), by.y() );
    for ( auto& line : m_lines ) {
        line.move( v );
    }
    update();
}

void Drawing::deleteLine( QString id ) {
    for ( int i = 0; i < m_lines.size(); i++ ) {
        if ( m_lines[i].getId() == id ) {
            m_lines.erase(m_lines.begin()+i);
            update();
            break;
        }
    }
}

void Drawing::addLine( QVariant path ) {
    m_lines.resize(m_lines.size()+1);
    m_lines.back().load(path);
    update();
}

//
//
//
void Drawing::setLineColourAtIndex( int index, QColor colour ) {
    if ( index >= 0 && index < m_lines.size() ) {
        m_lines[index].setColour(colour);
        update();
    }
}

void Drawing::setLineWidthAtIndex( int index, qreal width ) {
    if ( index >= 0 && index < m_lines.size() ) {
        m_lines[index].setLineWidth(width);
        update();
    }
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


