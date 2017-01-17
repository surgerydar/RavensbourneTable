#ifndef COLOURCHOOSER_H
#define COLOURCHOOSER_H

#include <QQuickPaintedItem>
#include <QColor>
#include <QPoint>
#include <QConicalGradient>

class ColourChooser : public QQuickPaintedItem
{
    Q_OBJECT
public:
    ColourChooser(QQuickItem *parent = 0);
    void paint(QPainter *painter) override;
    //
    //
    //
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;

signals:
    void colourChanged( QColor colour );

public slots:
    void setColour( QColor colour );
    void setColourFromPoint( QPoint p );
    QColor getColour();

private slots:

protected:
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) override;
private:
    QColor              m_colour;
    QConicalGradient    m_gradient;
};

#endif // COLOURCHOOSER_H
