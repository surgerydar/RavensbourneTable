#ifndef FONTCHOOSER_H
#define FONTCHOOSER_H

#include <QQuickPaintedItem>
#include <QConicalGradient>
#include <QPainterPath>
#include <QFont>

#include "circularmenu.h"
#include "hslsegmentcontrol.h"
#include "fontsizeselector.h"
#include "segmentbutton.h"
#include "segmentbuttongroup.h"

class FontChooser : public CircularMenu
{
    Q_OBJECT
public:
    FontChooser(QQuickItem *parent = 0);
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
    void fontChanged( QFont font, QColor colour );

public slots:
    QFont getFont() { return m_font; }
    void setFont(QFont font, QColor colour);

protected:

private:
    void updateFont();
    //
    //
    //
    QFont               m_font;
    QColor              m_colour;
    //
    //
    //
    HslSegmentControl   m_colourSelector;
    FontSizeSelector    m_fontSizeSelector;
    SegmentButton       m_boldSelector;
    SegmentButton       m_italicSelector;
    SegmentButton       m_underlineSelector;
    SegmentButtonGroup  m_familyGroup;
    SegmentButton       m_sansSelector;
    SegmentButton       m_serifSelector;
    //SegmentButton       m_cursiveSelector;
};

#endif // FONTCHOOSER_H
