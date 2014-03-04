#ifndef QUERYID_H_
#define QUERYID_H_

#include <qobjectdefs.h>

namespace memorizer {

class QueryId
{
    Q_GADGET
    Q_ENUMS(Type)

public:
    enum Type {
    	ClearAllRecent,
    	DeleteFile,
        DeleteRecent,
        FetchRecent,
        SaveRecent,
        Setup
    };
};

} /* namespace backgroundvideo */

#endif /* QUERYID_H_ */
