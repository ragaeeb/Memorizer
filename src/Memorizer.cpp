#include "Logger.h"
#include "Memorizer.hpp"

#include <bb/cascades/ActionItem>
#include <bb/cascades/Application>
#include <bb/cascades/Control>
#include <bb/cascades/NavigationPane>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/SceneCover>

namespace memorizer {

using namespace bb::cascades;

Memorizer::Memorizer(Application* app) : QObject(app)
{
	AbstractActionItem* aai = NULL;

	if ( getValueFor("animations").isNull() ) { // first run
		LOGGER("First run!");
		saveValueFor("animations", 1);
		saveValueFor("input", "/accounts/1000/removable/sdcard/music");
	} else {
		QStringList mostRecent = getValueFor("recent").toStringList();
		LOGGER("Most recent:" << mostRecent);

	    if ( !mostRecent.isEmpty() )
	    {
	    	QString uri = mostRecent[0];
	    	int index = uri.lastIndexOf("/")+1;
	    	LOGGER("Non empty most recent:" << uri << index);

	    	saveValueFor( "input", uri.left(index) );

	    	QString title = uri.mid(index);
	    	LOGGER("Action title:" << title);

	    	aai = ActionItem::create().title(title).image( Image("asset:///images/action_openRecent.png") );
	    	aai->setProperty("uri", uri);

	    	connect( aai, SIGNAL( triggered() ), this, SLOT( onMostRecentTriggered() ) );
	    }
	}

	QmlDocument* qmlCover = QmlDocument::create("asset:///Cover.qml").parent(this);
	Control* sceneRoot = qmlCover->createRootObject<Control>();
	SceneCover* cover = SceneCover::create().content(sceneRoot);
	app->setCover(cover);

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("cover", sceneRoot);

    NavigationPane *root = qml->createRootObject<NavigationPane>();
    app->setScene(root);
    m_root = root;

    if (aai) {
    	root->top()->addAction(aai, ActionBarPlacement::InOverflow);
    }
}


void Memorizer::create(Application* app) {
	new Memorizer(app);
}


void Memorizer::onMostRecentTriggered()
{
	QString uri = sender()->property("uri").toString();
	LOGGER("onMostRecentTriggered()" << uri);
	QMetaObject::invokeMethod( m_root, "playFile", Q_ARG(QVariant,QVariant(uri)) );
}


QVariant Memorizer::getValueFor(const QString &objectName)
{
    QVariant value( m_settings.value(objectName) );

	LOGGER(objectName << value);

    return value;
}


void Memorizer::saveValueFor(const QString &objectName, const QVariant &inputValue)
{
	LOGGER(objectName << inputValue);
	m_settings.setValue(objectName, inputValue);
}

} // memorizer
