#ifndef CIRCULARMENU_H
#define CIRCULARMENU_H

#include <QQuickPaintedItem>
#include <QPainterPath>

#include "segmentcontrol.h"

class CircularMenu : public QQuickPaintedItem
{
    Q_OBJECT
public:
    CircularMenu(QQuickItem* parent);
    virtual void paint(QPainter *painter) override;
signals:

public slots:

protected:
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) override;
    virtual void layout();
    //
    //
    //
    QPainterPath getSegment( qreal startAngle, qreal sweep );

    QPainterPath m_outerPath;
    QPainterPath m_middlePath;
    QPainterPath m_innerPath;
    //
    //
    //
    QMap<QString,SegmentControl*> m_controls;
    void addControl(QString name,SegmentControl* control);
    void removeControl(QString name);
    //
    //
    //
    QString mousePressControls( QMouseEvent* event );
    QString mouseMoveControls( QMouseEvent* event );
    QString mouseReleaseControls( QMouseEvent* event );
};

#endif // CIRCULARMENU_H
