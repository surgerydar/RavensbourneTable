#ifndef DRAWING_H
#define DRAWING_H

#include <QQuickPaintedItem>
#include "polyline.h"

class Drawing : public QQuickPaintedItem
{
    Q_OBJECT
public:
    Drawing(QQuickItem *parent = 0);
    void paint(QPainter *painter) override;
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) override;
public slots:
    //
    //
    //
    void clear();
    QVariant save();
    void load( const QVariant& drawing );
    //
    //
    //
    QString startLine(QPoint p, qreal width, QColor color);
    QString endLine(QPoint p);
    QString addPoint(QPoint p);
    //
    //
    //
    QVariant getLine( QString id );
    //
    //
    //
    int pathAt( QPoint p );
    void movePathAtIndex( int index, QPoint by );
    QString deletePathAtIndex( int index );
    void movePath( QString id, QPoint by );
    void deletePath( QString id );
    void addPath( QVariant data );
    //
    //
    //
    QVariant getBounds();
    //
    //
    //
private slots:

private:
    //
    //
    //
    std::vector<PolyLine>   m_lines;
    QVector2D               m_lastPoint;
};

#endif // DRAWING_H
