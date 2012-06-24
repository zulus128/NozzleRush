//
//  Heal.m
//  NozzleRush
//
//  Created by Mac on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Heal.h"
#import "Common.h"

@implementation Heal

@synthesize timer;

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy {
    
    if((self = [super init])) {				
        

        x = xx;
        y = yy;
        
        b2BodyDef bodyDef;
        bodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
        b2Body *bodyw = [Common instance].world->CreateBody(&bodyDef);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &sh;	
        fixtureDef.isSensor = true;
        bodyw->CreateFixture(&fixtureDef);
        
//        CCNode* o = [[CCNode alloc] init];
        self.tag = HEAL_TAG;
        bodyw->SetUserData(self);
        
        CGPoint ppp = [[Common instance] ort2iso:ccp(x,y)];
        tile = [[Common instance] tileCoordForPosition:ppp];

        
    }
    return self;
}

- (void) hide {
 

//    NSLog(@"Heal hide");

    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerSel) userInfo:nil repeats:NO];

    [[[Common instance].tileMap layerNamed:@"TrackObjectsLayer"] setTileGID:0 at:tile]; 

}

- (void) timerSel {
    
    [self.timer invalidate];
    self.timer = nil;
    
    //    [[[Common instance].tileMap layerNamed:@"TrackObjectsLayer"] setTileGID:43/*36*/ at:ccp(51,74)]; 
    [self show];
    
}

- (void) show {
 
//    NSLog(@"Heal show");
    [[[Common instance].tileMap layerNamed:@"TrackObjectsLayer"] setTileGID:43/*36*/ at:tile]; 

}

-(void) dealloc {
    
    
    [super dealloc];
}
@end
