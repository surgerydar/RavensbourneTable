#ifndef POLYLINE_H
#define POLYLINE_H

#include <QVector2D>
#include <QColor>
#include <QVector>
#include <QPolygonF>
#include <vector>
#include <deque>

class PolyLine
{
public:
    PolyLine();
    //
    //
    //
    QString getId() { return m_id; }
    //
    //
    //
    void start( QVector2D& p );
    void lineto( QVector2D& p );
    void curveto( QVector2D& p );
    //
    //
    //
    void move(const QVector2D& by );
    //
    //
    //
    QVector<QVector2D>& points() { return m_points; }
    QPolygonF& polygon();
    //
    //
    //
    void setColour(const QColor& colour) { m_colour = colour; }
    QColor getColour() const { return m_colour; }
    //
    //
    //
    void setLineWidth( int width ) { m_lineWidth = width; }
    int getLineWidth() const { return m_lineWidth; }
    //
    //
    //
    bool hasChanged();
    //
    //
    //
    QRectF getBounds();
    //
    //
    //
    QVector2D nearestPoint( const QVector2D& target ) const;
    //QVector2D getClosestPoint(const QVector2D& target, unsigned int* nearestIndex) const;
    //
    //
    //
    void simplify(float tolerance=0.3f);
    //
    //
    //
    QVariant save();
    void load( const QVariant& line );
private:
    QVector<QVector2D>      m_points;
    QColor                  m_colour;
    int                     m_lineWidth;
    std::deque<QVector2D>   m_curveVertices;
    bool                    m_hasChanged;
    QPolygonF               m_polygon;
    QString                 m_id;
};

#endif // POLYLINE_H
