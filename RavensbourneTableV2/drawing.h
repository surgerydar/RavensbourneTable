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
    QString startLine(QPoint p, qreal width, QColor color);
    QString endLine(QPoint p);
    QString addPoint(QPoint p);
    void cancelLine();
    //
    //
    //
    QVariant getLine( QString id );
    QVariant getLineAtIndex( int index );
    int getLineIndex( QString id );
    QString getLineId( int index );
    bool isLineOpen() { return m_lineOpen; }
    //
    //
    //
    void restoreLine( QString id, QVariant data );
    void restoreLineAtIndex( int index, QVariant data );
    void insertLineAtIndex( int index, QVariant data );
    //
    // TODO: refactor to lineAt, moveLineAt etc
    //
    int lineIndexAt( QPoint p );
    void moveLineAtIndex( int index, QPoint by );
    void rotateLineAtIndex( int index, QPoint cp, float angle );
    void scaleLineAtIndex( int index, QPoint cp, float scale );
    QString deleteLineAtIndex( int index );
    void moveLine( QString id, QPoint by );
    void deleteLine( QString id );
    void addLine( QVariant data );
    void moveBy( QPoint by );
    //
    //
    //
    void setLineColourAtIndex( int index, QColor colour );
    void setLineWidthAtIndex( int index, qreal width );
    //
    //
    //
    QVariant getBounds();
    QVariant getTransformedBounds() { return getBounds(); }
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
    bool                    m_lineOpen;
};

#endif // DRAWING_H
