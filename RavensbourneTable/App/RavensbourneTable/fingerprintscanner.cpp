#include <QUuid>
#include <QFile>
#include <QDataStream>

#include "fingerprintscanner.h"

static bool InterpretDPFJStatus( int status ) {
    QString message = "Unknown error";
    switch( status ) {
    case DPFJ_SUCCESS : {
        return true;
    }
    case DPFJ_E_NOT_IMPLEMENTED : {
        message = "API call is not implemented";
        break;
    }
    case DPFJ_E_FAILURE : {
        message = "Unspecified failure";
        break;
    }
    case DPFJ_E_NO_DATA : {
        message = "No data is available";
        break;
    }
    case DPFJ_E_MORE_DATA : {
        message = "Memory allocated by application is not enough to contain data which is expected";
        break;
    }
    case DPFJ_E_INVALID_PARAMETER : {
        message = "One or more parameters passed to the API call are invalid";
        break;
    }
    case DPFJ_E_INVALID_FID : {
        message = "FID is invalid";
        break;
    }
    case DPFJ_E_TOO_SMALL_AREA : {
        message = "Image is too small";
        break;
    }
    case DPFJ_E_INVALID_FMD : {
        message = "FMD is invalid";
        break;
    }
    case DPFJ_E_ENROLLMENT_IN_PROGRESS : {
        message = "Enrollment operation is in progress";
        break;
    }
    case DPFJ_E_ENROLLMENT_NOT_STARTED : {
        message = "Enrollment operation has not begun";
        break;
    }
    case DPFJ_E_ENROLLMENT_NOT_READY : {
        message = "Not enough in the pool of FMDs to create enrollment FMD";
        break;
    }
    case DPFJ_E_ENROLLMENT_INVALID_SET : {
        message = "Unable to create enrollment FMD with the collected set of FMDs";
        break;
    }
    }
    qDebug() << message;
    return false;
}

static void DPAPICALL CaptureCallback(void* context, unsigned int /*reserved*/, unsigned int /*data_size*/, void* data){
    //sanity checks
    if(!(context&&data)) return;

    //allocate memory for capture data and the image in one chunk
    DPFPDD_CAPTURE_CALLBACK_DATA_0* capture_data = reinterpret_cast<DPFPDD_CAPTURE_CALLBACK_DATA_0*>(data);
    unsigned char* buffer = new unsigned char[sizeof(DPFPDD_CAPTURE_CALLBACK_DATA_0) + capture_data->image_size];
    if(buffer){
        //
        // copy capture data
        //
        DPFPDD_CAPTURE_CALLBACK_DATA_0* pcd = reinterpret_cast<DPFPDD_CAPTURE_CALLBACK_DATA_0*>(buffer);
        memcpy(pcd, capture_data, sizeof(DPFPDD_CAPTURE_CALLBACK_DATA_0));
        //
        // copy image
        //
        pcd->image_data = buffer + sizeof(DPFPDD_CAPTURE_CALLBACK_DATA_0);
        memcpy(pcd->image_data, capture_data->image_data, capture_data->image_size);
        //
        // notify
        //
        FingerprintScanner::Scanner* scanner = reinterpret_cast<FingerprintScanner::Scanner*>(context);
        FingerprintScanner::shared()->processFinger(scanner->name(),pcd);
        //
        // schedule next capture
        //
        scanner->capture();
    }
}

FingerprintScanner::Scanner::Scanner() {
    m_device = 0;
}

FingerprintScanner::Scanner::~Scanner() {
    close();
}

//
//
//
bool FingerprintScanner::Scanner::open(char* name) {
    //
    // close existing connection
    //
    close();
    //
    // open new connection
    //
    int status = dpfpdd_open(name,&m_device);
    if ( status == DPFPDD_SUCCESS ) {
        if( capture() ) {
            m_name = name;
            return true;
        }
        return false;
    } else {
        qDebug() << "ERROR : dpfpdd_open : " << status;
    }
    //
    // TODO: handle error or start capture
    //
    return false;
}

void FingerprintScanner::Scanner::close() {
    if ( m_device != 0 ) {
        dpfpdd_close(m_device);
        m_device = 0;
        m_name = "";
    }
}

bool FingerprintScanner::Scanner::capture() {
    if ( m_device ) {
        DPFPDD_CAPTURE_PARAM cp = {0};
        cp.size         = sizeof(cp);
        cp.image_fmt    = DPFPDD_IMG_FMT_ISOIEC19794;
        cp.image_proc   = DPFPDD_IMG_PROC_NONE;
        cp.image_res    = 500;
        //
        // start asyncronous capture
        //
        int status = dpfpdd_capture_async(m_device, &cp, this, CaptureCallback);
        return status == DPFPDD_SUCCESS;
    }
    return false;
}

FingerprintScanner* FingerprintScanner::s_shared = nullptr;

FingerprintScanner::FingerprintScanner(QObject *parent) : QObject(parent) {
    m_mode = VALIDATION;
    m_enrollment_stage = 0;
    m_enrollment_fmd = nullptr;
    m_enrollment_fmd_size = 0;
    m_templates.reserve(100);
}

FingerprintScanner::~FingerprintScanner() {
    close();
}

FingerprintScanner* FingerprintScanner::shared() {
    if ( !s_shared ) {
        s_shared = new FingerprintScanner();
    }
    return s_shared;
}

bool FingerprintScanner::open() {
    //
    // initialise library
    //
    if ( dpfpdd_init() == DPFPDD_SUCCESS ) {
        //
        // read database
        //
        read();
        //
        // enumerate devices
        //
        return enumerateDevices();
    } else {
        qDebug() << "Unable to initialise Digital Persona library";
    }
    return false;
}

void FingerprintScanner::close() {
    dpfpdd_exit();
}

bool FingerprintScanner::write(QString filename) {
    QFile f(filename);
    if ( f.open(QIODevice::WriteOnly) ) {
        qDebug() << "writing database to : " << filename;
        //
        //
        //
        QDataStream s(&f);
        //
        // write count
        //
        quint32 entry_count = (quint32)m_templates.size();
        s << entry_count;
        //
        // write entries
        //
        for ( auto& entry : m_templates ) {
            //
            // TODO: shift this to
            //
            s << entry.m_name;
            s << (quint32)entry.m_size;
            s.writeRawData((char*)entry.m_data,entry.m_size);
        }
        f.close();
        return true;
    }
    qDebug() << "Unable to open database for writing";
    return false;
}

bool FingerprintScanner::read(QString filename) {
    QFile f(filename);
    if ( f.open(QIODevice::ReadOnly) ) {
        qDebug() << "reading database from : " << filename;
        m_templates.clear();
        QDataStream s(&f);
        quint32 entry_count;
        s >> entry_count;
        for ( quint32 i = 0; i < entry_count; i++ ) {
            QString name;
            quint32 size;
            s >> name;
            s >> size;
            unsigned char* data = new unsigned char [size];
            s.readRawData((char*)data,size);
            m_templates.resize(i+1);
            m_templates[i].set(name,data,size);
            delete [] data;
        }
        f.close();
        return true;
    }
    qDebug() << "Unable to open database for reading";
    return false;
}

bool FingerprintScanner::enumerateDevices() {
    //
    //
    //
    m_scanners.clear();
    //
    //
    //
    unsigned int device_count = 0;
    if ( dpfpdd_query_devices( &device_count, nullptr ) == DPFPDD_E_MORE_DATA ) {
        DPFPDD_DEV_INFO *device_info = new DPFPDD_DEV_INFO [ device_count ];
        if ( dpfpdd_query_devices(&device_count,device_info) == DPFPDD_SUCCESS ) {
            for ( unsigned int i = 0; i < device_count; i++ ) {
                DPFPDD_DEV_INFO info = device_info[ i ];
                qDebug() << info.name;
                if( !m_scanners[ QString( info.name ) ].open(info.name) ) {
                    qDebug() << "Unable to open device";
                    m_scanners.erase(m_scanners.find(QString( info.name )));
                }
            }
        }
        delete [] device_info;
    }
    return m_scanners.size() > 0;
}

void FingerprintScanner::processFinger( QString device, DPFPDD_CAPTURE_CALLBACK_DATA_0* data ) {
    qDebug() << "Got finger!" << device;
    switch( m_mode ) {
        case VALIDATION :
            handleValidation(device,data);
            break;
        case ENROLLMENT :
            handleEnrollement(device,data);
            break;
    }

    delete [] data;
}

void FingerprintScanner::handleEnrollement(QString device, DPFPDD_CAPTURE_CALLBACK_DATA_0* data) {
    //
    // check for capture errors
    //
    if(data->error != DPFPDD_SUCCESS) {
        qDebug() << "capture failed with error " <<  data->error;
        endEnrollment(device,data->error);
        return;
    } else if ( !data->capture_result.success ) {
        qDebug() << "capture result error";
        endEnrollment(device,-1);
        return;
    }
    //
    // extract features
    //
    unsigned int features_size = MAX_FMD_SIZE;
    unsigned char features[ MAX_FMD_SIZE ];
    qDebug() << "extracting features";
    int status = dpfj_create_fmd_from_fid(data->capture_parm.image_fmt, data->image_data, data->image_size, !m_enrollment_fmd ? DPFJ_FMD_DP_PRE_REG_FEATURES : DPFJ_FMD_DP_VER_FEATURES, features, &features_size);
    if ( !InterpretDPFJStatus(status) ) {
        endEnrollment(device,status);
        return;
    }
    if ( !m_enrollment_fmd ) { // still building template
        //
        //
        //
        qDebug() << "adding features to template";
        status = dpfj_add_to_enrollment(DPFJ_FMD_DP_PRE_REG_FEATURES, features, features_size, 0);
        if ( status == DPFJ_E_MORE_DATA ) {
            //
            // need another template
            //
            qDebug() << "need more features";
        } else if ( !InterpretDPFJStatus(status) ) {
            endEnrollment(device,status);
            return;
        } else {
            //
            //
            //
            qDebug() << "getting enrollment fmd size";
            status = dpfj_create_enrollment_fmd(NULL, &m_enrollment_fmd_size);
            if(status == DPFJ_E_MORE_DATA){
                //
                // create FMD
                //
                qDebug() << "creating enrollment fmd";
                m_enrollment_fmd = new unsigned char[m_enrollment_fmd_size];
                status = dpfj_create_enrollment_fmd(m_enrollment_fmd, &m_enrollment_fmd_size);
                if ( !InterpretDPFJStatus(status) ) {
                    endEnrollment(device,status);
                    return;
                }
            } else {
                InterpretDPFJStatus(status);
                endEnrollment(device,status);
                return;
            }
        }
    } else {
        //
        // compare to template
        //
        unsigned int falsematch_rate = 0;
        qDebug() << "comparing to template";
        status = dpfj_compare(DPFJ_FMD_DP_VER_FEATURES, features, features_size, 0, DPFJ_FMD_DP_REG_FEATURES, m_enrollment_fmd, m_enrollment_fmd_size, 0, &falsematch_rate);
        if ( !InterpretDPFJStatus(status) ) {
            endEnrollment(device,status);
            return;
        }
        const unsigned int target_falsematch_rate = DPFJ_PROBABILITY_ONE / 100000; //target rate is 0.00001
        if(falsematch_rate < target_falsematch_rate) {
            //
            // done, add template to database
            //
            storeTemplate(m_enrollment_fmd, m_enrollment_fmd_size);
            endEnrollment(device,0);
            return;
        }
    }
    emit enrollmentStage(device,++m_enrollment_stage);
}

void FingerprintScanner::handleValidation(QString device, DPFPDD_CAPTURE_CALLBACK_DATA_0* data) {
    //
    // TODO: compare to database
    //
    unsigned int features_size = MAX_FMD_SIZE;
    unsigned char features[ MAX_FMD_SIZE ];
    qDebug() << "extracting features";
    int status = dpfj_create_fmd_from_fid(data->capture_parm.image_fmt, data->image_data, data->image_size, DPFJ_FMD_DP_VER_FEATURES, features, &features_size);
    if ( !InterpretDPFJStatus(status) ) {
        emit validationFailed(device,status);
        return;
    }
    QString match = validate(features,features_size);
    //
    // notify
    //
    if ( match.length() > 0 ) {
        emit validated(device,match);
    } else {
        emit validationFailed(device,0);
    }
}

void FingerprintScanner::endEnrollment( QString device, int status ) {
    dpfj_finish_enrollment();
    if ( status != 0 ) {
        emit enrollmentFailed(device, status);
    } else {
        emit enrolled(device, m_templates[m_templates.size()-1].m_name);
    }
    m_mode = VALIDATION;
    if ( m_enrollment_fmd ) {
        delete [] m_enrollment_fmd;
        m_enrollment_fmd = nullptr;
    }
    m_enrollment_fmd_size = 0;
}
void FingerprintScanner::storeTemplate( unsigned char* fmd, unsigned int fmd_size ) {

    QString id = QUuid::createUuid().toString();
    qDebug() << "storing template : " << id;
    m_templates.resize(m_templates.size()+1);
    m_templates[m_templates.size()-1].set(id,fmd,fmd_size);
    //
    // save database
    //
    write();
}

QString FingerprintScanner::validate( unsigned char* features, unsigned int features_size ) {
    const unsigned int target_falsematch_rate = DPFJ_PROBABILITY_ONE / 100000;
    unsigned int minimum_falsematch_rate = DPFJ_PROBABILITY_ONE;
    qDebug() << "matching against " << m_templates.size() << " entries";
    QString match;
    for ( auto& entry : m_templates ) {
        unsigned int falsematch_rate = 0;
        int status = dpfj_compare(DPFJ_FMD_DP_VER_FEATURES, features, features_size, 0, DPFJ_FMD_DP_REG_FEATURES, entry.m_data, entry.m_size, 0, &falsematch_rate);
        if ( InterpretDPFJStatus(status) ) {
            if ( falsematch_rate < target_falsematch_rate && falsematch_rate < minimum_falsematch_rate ) {
                match = entry.m_name;
                minimum_falsematch_rate = falsematch_rate;
            }
        } else {
            qDebug() << "match failed for " << entry.m_name;
        }
    }
    return match;
}

//
// slots
//
void FingerprintScanner::enroll(QString device) {
    //
    //
    //
    int status = dpfj_start_enrollment(DPFJ_FMD_DP_REG_FEATURES);
    if ( !InterpretDPFJStatus(status) ) {
        m_mode = VALIDATION;
        m_enrollment_stage = 0;
        emit enrollmentFailed(device, status);
    } else {
        m_mode = ENROLLMENT;
        m_enrollment_stage = 0;
        emit enrollmentStage(device, m_enrollment_stage);
    }
}

void FingerprintScanner::cancelEnrollment() {
    dpfj_finish_enrollment();
    m_mode = VALIDATION;
    if ( m_enrollment_fmd ) {
        delete [] m_enrollment_fmd;
        m_enrollment_fmd = nullptr;
    }
    m_enrollment_fmd_size = 0;
}

quint32 FingerprintScanner::count() {
    return m_scanners.size();
}

QVariantList FingerprintScanner::scanners() {
    QVariantList list;
    for ( auto& device : m_scanners ) {
        list << device.name();
    }
    return list;
}

