#include "Box2D.h"
#include "cocos2d.h"

class ContactListener : public b2ContactListener {
public:
	void BeginContact(b2Contact *contact);
	void EndContact(b2Contact *contact);
};