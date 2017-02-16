#include "drawingrenderer.h"
#include <QDebug>

bool glInitialised = false;

DrawingRenderer::DrawingRenderer(QObject *parent) :
    QObject(parent),
    m_program(nullptr) {

}

void DrawingRenderer::begin() {
    if ( !glInitialised ) {
        glInitialised = true;
        initializeOpenGLFunctions();

            m_program = new QOpenGLShaderProgram();
            m_program->addShaderFromSourceCode(QOpenGLShader::Vertex,
                                               "attribute highp vec4 vertices;"
                                               "varying highp vec2 coords;"
                                               "void main() {"
                                               "    gl_Position = vertices;"
                                               "    coords = vertices.xy;"
                                               "}");
            m_program->addShaderFromSourceCode(QOpenGLShader::Fragment,
                                               "varying highp vec2 coords;"
                                               "uniform lowp float t;"
                                               "void main() {"
                                               "    lowp float i = 1. - (pow(abs(coords.x), 4.) + pow(abs(coords.y), 4.));"
                                               "    i = smoothstep(t - 0.8, t + 0.8, i);"
                                               "    i = floor(i * 20.) / 20.;"
                                               "    gl_FragColor = vec4(coords * .5 + .5, i, i);"
                                               "}");

            m_program->bindAttributeLocation("vertices", 0);
            m_program->link();

    }
    //
    //
    //
    qDebug() << "width=" << m_viewportSize.width() << " height=" << m_viewportSize.height();
    glViewport(0, 0, m_viewportSize.width(), m_viewportSize.height());
    glDisable(GL_DEPTH_TEST);
}

void DrawingRenderer::end() {
    //
    //
    //
    m_window->resetOpenGLState();
}

void DrawingRenderer::draw( const PolyLine& line ) {
    m_program->bind();

    m_program->enableAttributeArray(0);

    float values[] = {
        -1, -1,
        1, -1,
        -1, 1,
        1, 1
    };
    m_program->setAttributeArray(0, GL_FLOAT, values, 2);
    m_program->setUniformValue("t", (float) 1);


    glDisable(GL_DEPTH_TEST);

    //glClearColor(0, 0, 0, 1);
    //glClear(GL_COLOR_BUFFER_BIT);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    m_program->disableAttributeArray(0);
    m_program->release();
    //
    //
    //
    /*
    QColor colour = line.getColour();
    qDebug() << "r=" << colour.redF() << " g=" << colour.greenF() << " b=" << colour.blueF();
    glColor3d(colour.redF(),colour.greenF(),colour.blueF());
    //
    //
    //
    glLineWidth(line.getLineWidth());
    //
    //
    //
    glBegin(GL_LINE_STRIP);
    //qDebug() << "start line";
    std::vector<QPoint>::const_iterator it = line.begin();
    for ( ; it != line.end(); ++it ) {
        float x = (float)it->x() / (float)m_viewportSize.width();
        float y = (float)it->y() / (float)m_viewportSize.height();

        glVertex2f(x,y);
        //qDebug() << "x=" << it->x() << " y=" << it->y();
    }
    glEnd();
    */
}
