#ifndef FONTCHOOSER_H
#define FONTCHOOSER_H

#include <QQuickPaintedItem>
#include <QConicalGradient>
#include <QPainterPath>
#include <QFont>

#include "circularmenu.h"

class FontChooser : public CircularMenu
{
    Q_OBJECT
public:
    FontChooser(QQuickItem *parent = 0);
    void paint(QPainter *painter) override;
    //
    //
    //

    //
    //
    //
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
signals:
    void fontChanged( QFont font, QColor colour );

public slots:
    void setFontFromPoint( QPoint p );
    QFont getFont() { return m_font; };

protected:
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) override;

private:
    void buildPaths();
    //
    //
    //
    QFont               m_font;
    QColor              m_colour;
    QConicalGradient    m_gradient;
    QPainterPath        m_colourPath;
    QPainterPath        m_sizePath;
    QPainterPath        m_familyPath;
    QPainterPath        m_weightPath;
    //
    //
    //


};

#endif // FONTCHOOSER_H
