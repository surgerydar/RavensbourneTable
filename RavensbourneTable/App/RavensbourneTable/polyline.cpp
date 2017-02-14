#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QPointF>
#include <QLine>
#include <QUuid>
#include <QDebug>
#include <cmath>
#include "polyline.h"

const int curveResolution = 30;
const float distanceThreshold = 20.;

PolyLine::PolyLine() :
    m_hasChanged(false),
    m_lineWidth(4) {
    m_id = QUuid::createUuid().toString();
}

void PolyLine::start( QVector2D& p ) {
    m_points.clear();
    m_curveVertices.clear();
    m_points.push_back(p);
    m_hasChanged = true;
}

void PolyLine::lineto( QVector2D& p ) {
    m_curveVertices.clear();
    m_points.push_back(p);
    m_hasChanged = true;
}

void PolyLine::curveto( QVector2D& p ) {

    m_curveVertices.push_back(p);

    if (m_curveVertices.size() == 4) {

        float x0 = m_curveVertices[0].x();
        float y0 = m_curveVertices[0].y();
        float x1 = m_curveVertices[1].x();
        float y1 = m_curveVertices[1].y();
        float x2 = m_curveVertices[2].x();
        float y2 = m_curveVertices[2].y();
        float x3 = m_curveVertices[3].x();
        float y3 = m_curveVertices[3].y();

        float t,t2,t3;
        float x,y;

        for (int i = 0; i < curveResolution; i++){

            t 	=  (float)i / (float)(curveResolution-1);
            t2 	= t * t;
            t3 	= t2 * t;

            x = 0.5f * ( ( 2.0f * x1 ) +
                        ( -x0 + x2 ) * t +
                        ( 2.0f * x0 - 5.0f * x1 + 4 * x2 - x3 ) * t2 +
                        ( -x0 + 3.0f * x1 - 3.0f * x2 + x3 ) * t3 );

            y = 0.5f * ( ( 2.0f * y1 ) +
                        ( -y0 + y2 ) * t +
                        ( 2.0f * y0 - 5.0f * y1 + 4 * y2 - y3 ) * t2 +
                        ( -y0 + 3.0f * y1 - 3.0f * y2 + y3 ) * t3 );


            m_points.push_back(QVector2D(x,y));
        }
        m_curveVertices.pop_front();
    }
    m_hasChanged = true;
}

void PolyLine::move(const QVector2D& by ) {
    for ( auto& point : m_points ) {
        point += by;
    }
}

QPolygonF& PolyLine::polygon() {
    if ( hasChanged() ) {
        //
        //
        //
        m_polygon.clear();
        for ( auto& vect : m_points ) {
            QPointF point( vect.x(), vect.y() );
            m_polygon.append(point);
        }
    }
    return m_polygon;
}
//
//
//
bool PolyLine::hasChanged() {
    if( m_hasChanged ){
        m_hasChanged=false;
        return true;
    } else {
        return false;
    }
}
//
//
//
QRectF PolyLine::getBounds() {
    if ( m_points.size() == 0 ) return QRect();
    qreal min_x = std::numeric_limits<qreal>::max();
    qreal max_x = std::numeric_limits<qreal>::min();
    qreal min_y = std::numeric_limits<qreal>::max();
    qreal max_y = std::numeric_limits<qreal>::min();
    for ( auto& point : m_points ) {
        if ( point.x() < min_x ) min_x = point.x();
        if ( point.x() > max_x ) max_x = point.x();
        if ( point.y() < min_y ) min_y = point.y();
        if ( point.x() > max_y ) max_y = point.y();
    }
    return QRectF( min_x, min_y, max_x - min_x, max_y - min_y );
}
//
//
//
static QVector2D nearestPointOnLine( const QVector2D& p1, const QVector2D& p2, const QVector2D& p3 ) {
    if ( p1 == p2 ) {
        return p1;
    }
    float u = (p3.x() - p1.x()) * (p2.x() - p1.x());
    u += (p3.y() - p1.y()) * (p2.y() - p1.y());
    // perfect place for fast inverse sqrt...
    QVector2D d = p2 - p1;
    float len = d.length();
    u /= (len * len);

    // clamp u
    if(u > 1) {
        u = 1;
    } else if(u < 0) {
        u = 0;
    }
    return p1 + ( d * u );
}

QVector2D PolyLine::nearestPoint( const QVector2D& target ) const {
    float minDistance = std::numeric_limits<float>::max();
    QVector2D nearest;
    int count = m_points.size() - 1;
    for ( int i = 0; i < count; i++ ) {
        QVector2D point = nearestPointOnLine( m_points[ i ], m_points[ i+ 1 ], target );
        float distance = ( point - target ).length();
        if ( distance < minDistance ) {
            minDistance = distance;
            nearest = point;
        }
    }
    return nearest;
}

QVariant PolyLine::save() {
    QVariantList points;
    for ( auto& vect : m_points ) {
        QVariantMap point;
        point["x"] = QVariant::fromValue(vect.x());
        point["y"] = QVariant::fromValue(vect.y());
        points.append(QVariant::fromValue(point));
    }
    QVariantMap object;
    object["id"] = QVariant(m_id);
    object["colour"] = QVariant(m_colour);
    object["linewidth"] = QVariant(m_lineWidth);
    object["points"] = QVariant::fromValue(points);
    return QVariant::fromValue(object);
}

void PolyLine::load( const QVariant& line ) {
    QVariantMap lineMap = line.toMap();
    m_id = lineMap.contains("id") ? lineMap["id"].value<QString>() : QUuid::createUuid().toString();
    if ( lineMap.contains("colour") ) {
        qDebug() << "PolyLine::load : setting colour";
        QVariantMap colourMap = lineMap["colour"].toMap();
        if ( colourMap.contains("r") && colourMap.contains("g") && colourMap.contains("b") ) {
            qDebug() << "PolyLine::load : colour has rgb";
            qreal r = colourMap["r"].value<qreal>();
            qreal g = colourMap["g"].value<qreal>();
            qreal b = colourMap["b"].value<qreal>();
            qDebug() << "PolyLine::load : rgb = [" << r << "," << g << "," << b << "]";
            m_colour.setRgbF(r,g,b);
        } else if ( lineMap["colour"].canConvert<QColor>() ) {
            m_colour = lineMap["colour"].value<QColor>();
        } else {
            qDebug() << "PolyLine::load : unknown colour format : " << lineMap["colour"].toString();
            m_colour = lineMap["colour"].value<QColor>();
        }
        qDebug() << "PolyLine::load : m_colour = [" << m_colour.redF() << "," << m_colour.greenF() << "," << m_colour.blueF() << "]";
    }
    m_lineWidth = lineMap.contains("linewidth") ? lineMap["linewidth"].value<int>() : m_lineWidth;
    QVariantList points = lineMap["points"].toList();
    int count = points.size();
    qDebug() << "PolyLine::load : " << count << " points";
    m_points.resize(count);
    for ( int i = 0; i < count; i++ ) {
        QVariantMap pointMap = points[ i ].toMap();
        m_points[ i ].setX(pointMap["x"].value<float>());
        m_points[ i ].setY(pointMap["y"].value<float>());
    }
    m_hasChanged = true;
}

// dot product (3D) which allows vector operations in arguments
#define dot(u,v)   ((u).x() * (v).x() + (u).y() * (v).y() )
#define norm2(v)   dot(v,v)        // norm2 = squared length of vector
#define norm(v)    sqrt(norm2(v))  // norm = length of vector
#define d2(u,v)    norm2(u-v)      // distance squared = norm2 of difference
#define d(u,v)     norm(u-v)       // distance = norm of difference

//--------------------------------------------------
static void simplifyDP(float tol, QVector2D* v, int j, int k, int* mk ){
    if (k <= j+1) // there is nothing to simplify
        return;

    // check for adequate approximation by segment S from v[j] to v[k]
    int     maxi	= j;          // index of vertex farthest from S
    float   maxd2	= 0;         // distance squared of farthest vertex
    float   tol2	= tol * tol;  // tolerance squared
    QVector2D p0    = v[j];
    QVector2D p1    = v[k];  // segment from v[j] to v[k]
    QVector2D u     = p1 - p0;   // segment direction vector
    double  cu		= dot(u,u);     // segment length squared

    // test each vertex v[i] for max distance from S
    // compute using the Feb 2001 Algorithm's dist_ofPoint_to_Segment()
    // Note: this works in any dimension (2D, 3D, ...)
    QVector2D  w;
    QVector2D  Pb;                // base of perpendicular from v[i] to S
    float  b, cw, dv2;        // dv2 = distance v[i] to S squared

    for (int i=j+1; i<k; i++){
        // compute distance squared
        w = v[i] - p0;
        cw = dot(w,u);
        if ( cw <= 0 ) dv2 = d2(v[i], p0);
        else if ( cu <= cw ) dv2 = d2(v[i], p1);
        else {
            b = (float)(cw / cu);
            Pb = p0 + u*b;
            dv2 = d2(v[i], Pb);
        }
        // test with current max distance squared
        if (dv2 <= maxd2) continue;

        // v[i] is a new max vertex
        maxi = i;
        maxd2 = dv2;
    }
    if (maxd2 > tol2)        // error is worse than the tolerance
    {
        // split the polyline at the farthest vertex from S
        mk[maxi] = 1;      // mark v[maxi] for the simplified polyline
        // recursively simplify the two subpolylines at v[maxi]
        simplifyDP( tol, v, j, maxi, mk );  // polyline v[j] to v[maxi]
        simplifyDP( tol, v, maxi, k, mk );  // polyline v[maxi] to v[k]
    }
    // else the approximation is OK, so ignore intermediate vertices
    return;
}

//--------------------------------------------------
void PolyLine::simplify(float tol){
    if(m_points.size() < 2) return;

    int n = m_points.size();
    qDebug() << "PolyLine::simplify : before : " << n;

    QVector<QVector2D> sV;
    sV.resize(n);

    int    i, k, m, pv;            // misc counters
    float  tol2 = tol * tol;       // tolerance squared
    QVector<QVector2D> vt;
    QVector<int> mk;
    vt.resize(n);
    mk.fill(0,n);

    // STAGE 1.  Vertex Reduction within tolerance of prior vertex cluster
    vt[0] = m_points[0];              // start at the beginning
    for (i=k=1, pv=0; i<n; i++) {
        if (d2(m_points[i], m_points[pv]) < tol2) continue;

        vt[k++] = m_points[i];
        pv = i;
    }
    if (pv < n-1) vt[k++] = m_points[n-1];      // finish at the end

    // STAGE 2.  Douglas-Peucker polyline simplification
    mk[0] = mk[k-1] = 1;       // mark the first and last vertices
    simplifyDP( tol, &vt[0], 0, k-1, &mk[0] );

    // copy marked vertices to the output simplified polyline
    for (i=m=0; i<k; i++) {
        if (mk[i]) sV[m++] = vt[i];
    }

    m_points = sV;
    if( m < (int)m_points.size() ) {
        //get rid of the unused points
        m_points.resize(m);
    }
    qDebug() << "PolyLine::simplify : after : " << m;
}





