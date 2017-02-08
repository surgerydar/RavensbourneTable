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
    int startLine(QPoint p, QColor color);
    int endLine(QPoint p);
    int addPoint(QPoint p);
    //
    //
    //
    int pathAt( QPoint p );
    void movePath( int index, QPoint by );
    void deletePath( int index );
private slots:

private:
    //
    //
    //
    std::vector<PolyLine>   m_lines;
    QVector2D               m_lastPoint;
};

#endif // DRAWING_H
