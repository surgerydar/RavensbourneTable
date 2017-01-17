#include <QDebug>>
#include "segmentbuttongroup.h"

SegmentButtonGroup::SegmentButtonGroup(qreal startAngle, qreal sweep) : SegmentControl(startAngle,sweep) {

}
//
//
//
void SegmentButtonGroup::paint(QPainter *painter) {
    // NOTE: this is an invisible item so no paint
    // TODO: change this
    for ( auto button : m_buttons ) {
        button->paint(painter);
    }
}

void SegmentButtonGroup::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) {
    // NOTE: this is an invisible item so no geometry
    // TODO: change this
    for ( auto button : m_buttons ) {
        button->geometryChanged(newGeometry,oldGeometry);
    }
}

//
//
//
bool SegmentButtonGroup::mousePressEvent(QMouseEvent *event) {
    QMap<QString,SegmentButton*>::iterator it = m_buttons.begin();
    for ( ; it != m_buttons.end(); ++it ) {
        if ( it.value()->mousePressEvent(event) ) return true;
    }
    return false;
}

bool SegmentButtonGroup::mouseMoveEvent(QMouseEvent *event) {
    QMap<QString,SegmentButton*>::iterator it = m_buttons.begin();
    for ( ; it != m_buttons.end(); ++it ) {
        if ( it.value()->mouseMoveEvent(event) ) return true;
    }
    return false;
}

bool SegmentButtonGroup::mouseReleaseEvent(QMouseEvent *event) {
    qDebug() << "SegmentButtonGroup::mouseReleaseEvent";
    QString selected;
    QMap<QString,SegmentButton*>::iterator it = m_buttons.begin();
    for ( ; it != m_buttons.end(); ++it ) {
        if ( it.value()->mouseReleaseEvent(event) ) {
            selected = it.key();
            break;
        }
    }
    if ( selected.length() > 0 ) {
        qDebug() << "selected : " << selected;
        selectButton(selected);
        return true;
    }
    return false;
}

//
//
//
void SegmentButtonGroup::addButton( QString name, SegmentButton* button) {
    m_buttons[name] = button;
}

void SegmentButtonGroup::removeButton( QString name ) {
    m_buttons.remove(name);
}

void SegmentButtonGroup::selectButton( QString name ) {
    QMap<QString,SegmentButton*>::iterator it = m_buttons.begin();
    for ( ; it != m_buttons.end(); ++it ) {
        it.value()->setChecked(it.key()==name);
    }
}

QString SegmentButtonGroup::selectedButton() {
    QMap<QString,SegmentButton*>::iterator it = m_buttons.begin();
    for ( ; it != m_buttons.end(); ++it ) {
        if ( it.value()->isChecked() ) return it.key();
    }
    return "";
}
