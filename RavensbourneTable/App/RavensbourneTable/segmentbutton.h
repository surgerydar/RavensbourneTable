#ifndef SEGMENTBUTTON_H
#define SEGMENTBUTTON_H

#include <QString>
#include <QFont>
#include <QPainterPath>

#include "segmentcontrol.h"

class SegmentButton : public SegmentControl
{
public:
    SegmentButton(qreal startAngle, qreal sweep, QString label, bool checkable = false);
    void paint(QPainter *painter) override;
    virtual void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) override;
    //
    //
    //
    void setFont( const QFont& font ) { m_font = font; }
    bool isChecked() { return m_checked; }
    void setChecked( bool checked=true ) { m_checked = checked; }
    //
    //
    //
    virtual bool mousePressEvent(QMouseEvent *event) override;
    virtual bool mouseMoveEvent(QMouseEvent *event) override;
    virtual bool mouseReleaseEvent(QMouseEvent *event) override;
protected:
    bool            m_checkable;
    bool            m_checked;
    QString         m_label;
    QPainterPath    m_labelPath;
    QFont           m_font;
};

#endif // SEGMENTBUTTON_H
