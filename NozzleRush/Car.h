//
//  Car.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

#define hstep 7
#define hmax 60

enum Car_type { CT_ME, CT_ENEMY };

@interface Car : CCNode {
    
    float angle;
    int typ;
    b2BodyDef bodyDef;
    CCSprite* sprite;
    CGPoint groundPosition;
    float hh;
    int hdir;
}

//- (id) initWithX: (int) x  Y:(int) y Type:(int) type;
- (id) initWithType:(int) type;
- (void) update;
- (void) setPosX:(int)x Y:(int)y;
- (CGPoint) getGroundPosition;

@property (nonatomic) b2Body *body;
@property (readwrite) b2Vec2 eye;
@property (readwrite) b2Vec2 target;
@property (readwrite) b2Vec2 target1;
@property (readwrite) b2Vec2 target2;
@property (assign, readwrite) BOOL jump;

@end
