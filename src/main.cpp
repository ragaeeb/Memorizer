#include "precompiled.h"

#include "Logger.h"
#include "Memorizer.hpp"

using namespace bb::cascades;
using namespace memorizer;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    Application app(argc, argv);
    Memorizer::create(&app);

    return Application::exec();
}
