#ifndef DRAWINGRENDERER_H
#define DRAWINGRENDERER_H

#include <QObject>
#include <QOpenGLFunctions>
#include <QQuickWindow>
#include <QOpenGLShaderProgram>

#include "polyline.h"

class DrawingRenderer : public QObject, protected QOpenGLFunctions
{
    Q_OBJECT
public:
    explicit DrawingRenderer(QObject *parent = 0);

    void setViewportSize(const QSize &size) { m_viewportSize = size; }
    void setWindow(QQuickWindow *window) { m_window = window; }
    //
    //
    //
    void begin();
    void end();
    void draw( const PolyLine& line );
public slots:

private:
    QSize                   m_viewportSize;
    QQuickWindow*           m_window;
    QOpenGLShaderProgram*   m_program;
};

#endif // DRAWINGRENDERER_H
