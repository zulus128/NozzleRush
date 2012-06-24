//
//  Rocket.h
//  NozzleRush
//
//  Created by вадим on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

enum Rocket_Type { RT_STANDARD };

@interface Rocket : CCNode {
    
    int typ;
//    float32 angle;
    b2BodyDef bodyDef;
    CCSprite* sprite;
}

- (id) initWithX: (int) x  Y:(int) y Angle:(float32) a Type:(int) type;
- (void) update;

@property (nonatomic) b2Body *body;

@end
