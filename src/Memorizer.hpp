#ifndef Memorizer_HPP_
#define Memorizer_HPP_

#include <QSettings>

namespace bb {
	namespace cascades {
		class Application;
	}
}

namespace memorizer {

class Memorizer : public QObject
{
    Q_OBJECT

    QSettings m_settings;
    QObject* m_root;

    Memorizer(bb::cascades::Application* app);

private slots:
	void onMostRecentTriggered();

public:
	static void create(bb::cascades::Application* app);
    virtual ~Memorizer() {}
    Q_INVOKABLE void saveValueFor(const QString &objectName, const QVariant &inputValue);
    Q_INVOKABLE QVariant getValueFor(const QString &objectName);
};

}

#endif /* Memorizer_HPP_ */
