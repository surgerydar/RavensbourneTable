#ifndef LINESTYLECHOOSER_H
#define LINESTYLECHOOSER_H

#include <QObject>
#include "circularmenu.h"
#include "hslsegmentcontrol.h"
#include "linewidthsegmentcontrol.h"

class LineStyleChooser : public CircularMenu
{
    Q_OBJECT
public:
    explicit LineStyleChooser(QQuickItem *parent = 0);
    void paint(QPainter *painter) override;
    //
    //
    //
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    //
    //
    //
signals:
    void styleChanged( qreal lineWidth, QColor colour );

public slots:
    qreal getWidth() { return m_width; }
    QColor getColour() { return m_colour; }
    void setStyle( qreal width, QColor colour ) { m_width = width; m_colour = colour; update(); }
protected:

private:
    void updateStyle();
    //
    //
    //
    QPainterPath        m_swatch;
    //
    //
    //
    qreal               m_width;
    QColor              m_colour;
    //
    //
    //
    HslSegmentControl       m_colourSelector;
    LineWidthSegmentControl m_widthSelector;
};

#endif // LINESTYLECHOOSER_H
