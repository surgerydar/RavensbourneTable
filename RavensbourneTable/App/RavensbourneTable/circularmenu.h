#ifndef CIRCULARMENU_H
#define CIRCULARMENU_H

#include <QQuickPaintedItem>
#include <QPainterPath>

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

};

#endif // CIRCULARMENU_H
