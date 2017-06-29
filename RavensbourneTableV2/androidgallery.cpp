#include <QtAndroidExtras>
#include "androidgallery.h"

class ImagePickerAndroid : public QObject, public QAndroidActivityResultReceiver
{
    Q_OBJECT

public:
    ImagePickerAndroid() {

    }

    void buscaImagem() {
        QAndroidJniObject ACTION_PICK = QAndroidJniObject::fromString("android.intent.action.GET_CONTENT");
        QAndroidJniObject intent("android/content/Intent");
        if (ACTION_PICK.isValid() && intent.isValid())
        {
            intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", ACTION_PICK.object<jstring>());
            intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
            QtAndroid::startActivity(intent.object<jobject>(), 101, this);
            qDebug() << "OK";
        }
        else
        {
            qDebug() << "ERRO";
        }
    }

    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data) {
        qDebug() << "Trabalha com os dados";

            jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
            if (receiverRequestCode == 101 && resultCode == RESULT_OK) {
                QString imagemCaminho = data.callObjectMethod("getData", "()Landroid/net/Uri;").callObjectMethod("getPath", "()Ljava/lang/String;").toString();
                emit imagemCaminhoSignal(imagemCaminho);

                qDebug() << imagemCaminho;
            }
            else
            {
                qDebug() << "Caminho errado";
            }
    }

signals:
    void imagemCaminhoSignal(QString);
};

AndroidGallery::AndroidGallery() {

}

void AndroidGallery::buscaImagem()
{
    ImagePickerAndroid *imagePicker = new ImagePickerAndroid();
    connect(imagePicker, SIGNAL(imagemCaminhoSignal(QString)), this, SLOT(retornaImagem(QString)));

    imagePicker->buscaImagem();
}

void AndroidGallery::retornaImagem(QString path)
{
    qDebug() << path;

    m_imagemCaminho = path;

    emit imagemCaminhoChanged();
}

QString AndroidGallery::imagemCaminho()
{
    return m_imagemCaminho;
}
