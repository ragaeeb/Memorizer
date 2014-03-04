#include "precompiled.h"

#include "Memorizer.hpp"
#include "InvocationUtils.h"
#include "IOUtils.h"
#include "LazyMediaPlayer.h"
#include "Logger.h"
#include "QueryId.h"
#include "TextUtils.h"

namespace memorizer {

using namespace bb::cascades;
using namespace canadainc;

Memorizer::Memorizer(Application* app) :
        QObject(app), m_cover("Cover.qml"), m_mkw(NULL)
{
    INIT_SETTING("delay", 0);
    m_cover.setContext("player", &m_player);

    loadRoot("main.qml");
    connect( &m_invokeManager, SIGNAL( invoked(bb::system::InvokeRequest const&) ), this, SLOT( invoked(bb::system::InvokeRequest const&) ) );
    connect( app, SIGNAL( aboutToQuit() ), this, SLOT( saveCurrent() ) );
    connect( &m_player, SIGNAL( activeChanged() ), this, SLOT( activeChanged() ) );
}


QObject* Memorizer::loadRoot(QString const& qmlDoc, bool invoked)
{
    Q_UNUSED(invoked);

    QString database = QString("%1/database.db").arg( QDir::homePath() );
    m_sql.setSource(database);

    if ( !QFile(database).exists() )
    {
        IOUtils::writeFile(database);

        QStringList qsl;
        qsl << "CREATE TABLE IF NOT EXISTS recent (file TEXT PRIMARY KEY, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)";
        m_sql.executeTransaction(qsl, QueryId::Setup);
    }

    qmlRegisterType<bb::cascades::pickers::FilePicker>("bb.cascades.pickers", 1, 0, "FilePicker");
    qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("bb.cascades.pickers", 1, 0, "FileType", "Can't instantiate");
    qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("bb.cascades.pickers", 1, 0, "FilePickerMode", "Can't instantiate");
    qmlRegisterUncreatableType<QueryId>("com.canadainc.data", 1, 0, "QueryId", "Can't instantiate");

    QmlDocument* qml = QmlDocument::create( QString("asset:///%1").arg(qmlDoc) ).parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("persist", &m_persistance);
    qml->setContextProperty("player", &m_player);
    qml->setContextProperty("sql", &m_sql);
    qml->setContextProperty("formatter", &m_formatter);

    AbstractPane* root = qml->createRootObject<AbstractPane>();

    connect( this, SIGNAL( initialize() ), this, SLOT( init() ), Qt::QueuedConnection ); // async startup
    emit initialize();

    Application::instance()->setScene(root);

    return root;
}


void Memorizer::saveCurrent()
{
    m_player.pause();

    QVariantMap map = m_player.metaData();
    QString filePath = map.value("uri").toString();

    if ( !filePath.isEmpty() && QFile::exists(filePath) )
    {
        m_sql.setQuery("INSERT OR REPLACE INTO recent (file) VALUES(?)");
        QVariantList params = QVariantList() << filePath;
        m_sql.executePrepared(params, QueryId::SaveRecent);
    }
}


void Memorizer::activeChanged()
{
    if (m_mkw == NULL) {
        m_mkw = new MediaKeyWatcher(MediaKey::PlayPause, this);
        connect( m_mkw, SIGNAL( shortPress(bb::multimedia::MediaKey::Type) ), this, SLOT( onShortPress(bb::multimedia::MediaKey::Type) ) );
    }
}


void Memorizer::onShortPress(bb::multimedia::MediaKey::Type key)
{
    Q_UNUSED(key);
    m_player.togglePlayback();
}


void Memorizer::invoked(bb::system::InvokeRequest const& request)
{
    LOGGER("========= INVOKED WITH" << request.uri().toString() );

    if ( !request.uri().isEmpty() ) {
        m_player.play( request.uri().toString() );
    }
}


void Memorizer::init()
{
    INIT_SETTING("input", "/accounts/1000/removable/sdcard/voice");

    InvocationUtils::validateSharedFolderAccess( tr("Warning: It seems like the app does not have access to your Shared Folder. This permission is needed for the app to access the media files so they can be played. If you leave this permission off, some features may not work properly.") );
}


void Memorizer::fetchAllRecent()
{
    m_sql.setQuery("SELECT * from recent ORDER BY timestamp DESC LIMIT 10");
    m_sql.load(QueryId::FetchRecent);
}


void Memorizer::deleteRecent(QString const& file)
{
    m_sql.setQuery( QString("DELETE FROM recent WHERE file=?").arg(file) );
    QVariantList params = QVariantList() << file;
    m_sql.executePrepared(params, QueryId::DeleteRecent);

    fetchAllRecent();
}


bool Memorizer::deleteFile(QString const& file, bool removeBookmarks)
{
    bool result = QFile::remove(file);
    deleteRecent(file);

    return result;
}


void Memorizer::clearAllRecent()
{
    m_sql.setQuery("DELETE from recent");
    m_sql.load(QueryId::ClearAllRecent);

    fetchAllRecent();
}


void Memorizer::create(Application* app) {
	new Memorizer(app);
}


} // memorizer
