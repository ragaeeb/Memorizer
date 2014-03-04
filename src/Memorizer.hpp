#ifndef Memorizer_HPP_
#define Memorizer_HPP_

#include <bb/system/InvokeManager>

#include <bb/multimedia/MediaKey>

#include "customsqldatasource.h"
#include "LazyMediaPlayer.h"
#include "LazySceneCover.h"
#include "Persistance.h"
#include "TextUtils.h"

namespace bb {
	namespace cascades {
		class Application;
	}

	namespace multimedia {
	    class MediaKeyWatcher;
	}
}

namespace memorizer {

using namespace canadainc;

class Memorizer : public QObject
{
    Q_OBJECT

    CustomSqlDataSource m_sql;
    bb::system::InvokeManager m_invokeManager;
    LazySceneCover m_cover;
    LazyMediaPlayer m_player;
    Persistance m_persistance;
    TextUtils m_formatter;
    bb::multimedia::MediaKeyWatcher* m_mkw;

    Memorizer(bb::cascades::Application* app);
    QObject* loadRoot(QString const& qml, bool invoked=false);

signals:
    void initialize();

private slots:
    void activeChanged();
    void init();
    void invoked(bb::system::InvokeRequest const& request);
    void onShortPress(bb::multimedia::MediaKey::Type key);

public:
	static void create(bb::cascades::Application* app);
    virtual ~Memorizer() {}
    Q_INVOKABLE void fetchAllRecent();
    Q_INVOKABLE void deleteRecent(QString const& file);
    Q_INVOKABLE bool deleteFile(QString const& file, bool removeBookmarks=false);
    Q_INVOKABLE void clearAllRecent();
    Q_SLOT void saveCurrent();
};

}

#endif /* Memorizer_HPP_ */
