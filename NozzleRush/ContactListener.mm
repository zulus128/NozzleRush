#import "ContactListener.h"

void ContactListener::BeginContact(b2Contact *contact) {
//	Actor *actor1 = (Actor *)contact->GetFixtureA()->GetBody()->GetUserData();
//	Actor *actor2 = (Actor *)contact->GetFixtureB()->GetBody()->GetUserData();
//	if(actor1 && actor2) {
//		[actor1 addContact:actor2];
//		[actor2 addContact:actor1];
//	}
    
    NSLog(@"BEGIN CONTACT!");
}

void ContactListener::EndContact(b2Contact *contact) {
//	Actor *actor1 = (Actor *)contact->GetFixtureA()->GetBody()->GetUserData();
//	Actor *actor2 = (Actor *)contact->GetFixtureB()->GetBody()->GetUserData();
//	if(actor1 && actor2) {
//		[actor1 removeContact:actor2];
//		[actor2 removeContact:actor1];
//	}
}