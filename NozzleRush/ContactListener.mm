#import "ContactListener.h"
#import "Common.h"
#import "Car.h"

void ContactListener::BeginContact(b2Contact *contact) {
//	Actor *actor1 = (Actor *)contact->GetFixtureA()->GetBody()->GetUserData();
//	Actor *actor2 = (Actor *)contact->GetFixtureB()->GetBody()->GetUserData();
//	if(actor1 && actor2) {
//		[actor1 addContact:actor2];
//		[actor2 addContact:actor1];
//	}
    
//    NSLog(@"Contact!");
    
    
    CCNode* actor1 = (CCNode*)contact->GetFixtureA()->GetBody()->GetUserData();
    if(actor1 != nil)
    if (actor1.tag == TRAMPLIN_TAG) {

        Car* actor2 = (Car*)contact->GetFixtureB()->GetBody()->GetUserData();
        if(actor2 != nil)
            actor2.jump = YES;
        
//        NSLog(@"BEGIN CONTACT!");
    }

//    CCNode* actor2 = (CCNode*)contact->GetFixtureB()->GetBody()->GetUserData();
//    if ((actor2 != nil) && (actor2.tag == TRAMPLIN_TAG)) {
//        
//        NSLog(@"BEGIN CONTACT!2");
//    }

}

void ContactListener::EndContact(b2Contact *contact) {
//	Actor *actor1 = (Actor *)contact->GetFixtureA()->GetBody()->GetUserData();
//	Actor *actor2 = (Actor *)contact->GetFixtureB()->GetBody()->GetUserData();
//	if(actor1 && actor2) {
//		[actor1 removeContact:actor2];
//		[actor2 removeContact:actor1];
//	}
}

//virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
//virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);