//
//  Car.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

@interface Car : NSObject {
    
//    b2Vec2 eye;
//    b2Vec2 target;
}

- (id) initWithX: (int) x  Y:(int) y;

- (void) update;

@property (nonatomic) b2Body *body;
@property (readwrite) b2Vec2 eye;
@property (readwrite) b2Vec2 target;
@end
