//
//  Heal.h
//  NozzleRush
//
//  Created by Mac on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

@interface Heal : CCNode {
    
    int x,y;
    CGPoint tile;
    
}

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy;

- (void) hide;
- (void) show;

@property (nonatomic, retain) NSTimer* timer;

@end
