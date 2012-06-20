//
//  HudLayer.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"
#import "Common.h"

#define JOYCENTERX 70
#define JOYCENTERY 70
#define JOYTRIGGERRADIUS 102
#define JOYFIELDRADIUS 250

#define JOYWEAPONX 200
#define JOYWEAPONY 70

@implementation HudLayer

-(id) init {
    
	if ((self = [super init])) {

		CGSize winSize = [[CCDirector sharedDirector] winSize];

        self.isTouchEnabled = YES;
        
        CCSprite* joyfield = [CCSprite spriteWithFile:@"Button_field_1.png"];
        [self addChild:joyfield];
        joyfield.scale = SCALE;
        joyfield.position = ccp(JOYCENTERX, JOYCENTERY);

        joyfire = [CCSprite spriteWithFile:@"Button_trigger_1.png"];
        [self addChild:joyfire];
        joyfire.scale = SCALE;
        joyfire.position = ccp(JOYCENTERX, JOYCENTERY);
        
        
        CCSprite* joyweapon = [CCSprite spriteWithFile:@"Button_fire_1.png"];
        [self addChild:joyweapon];
        joyweapon.scale = SCALE/2;
        joyweapon.position = ccp(JOYWEAPONX, JOYWEAPONY);

        move_ease_in = [[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.3f position:ccp(JOYCENTERX, JOYCENTERY)] rate:3.0f] retain];

        score = [CCLabelTTF labelWithString:@"Checkpoint:  Lap: " fontName:@"Marker Felt" fontSize:18];
        score.position = ccp(245, winSize.height - 30);
        [self addChild:score z:60];

        label2 = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Helvetica" fontSize:38];
        label2.position = ccp(winSize.width / 2 - 40, winSize.height / 2);
        label2.visible = NO;
        [self addChild:label2 z:100];
	}
	return self;
}

- (void) showGO {
    
    joyfire.position = ccp(JOYCENTERX, JOYCENTERY);
    trigbeginx = 0;
    trigbeginy = 0;
    flagbegin = NO;
    
    label2.visible = YES;
}

- (void) hideGO {
    
    label2.visible = NO;
}

- (void) updateScore {
    
    NSString* str = [NSString stringWithFormat:@"Checkpoint: %d, Lap: %d, Distance to checkpoint: %d", [Common instance].checkpoint, [Common instance].laps, [Common instance].distToChp];
    [score setString:str];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
        if(flagbegin)
            return;
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        
        
        location = [[CCDirector sharedDirector] convertToGL: location];
        
        
        if((fabs(location.x - JOYCENTERX) < JOYTRIGGERRADIUS*SCALE) && (fabs(location.y - JOYCENTERY) < JOYTRIGGERRADIUS*SCALE)) {
            
            trigbeginx = location.x;
            trigbeginy = location.y;
            flagbegin = YES;
//            NSLog(@"touch began x = %f, y = %f", location.x, location.y);
        }
    
    if((fabs(location.x - JOYWEAPONX) < 50) && (fabs(location.y - JOYWEAPONY) < 50)) {

        [Common instance].machinegun = YES;
        
        NSLog(@"touch began x = %f, y = %f", location.x, location.y);
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
        if(!flagbegin)
            return;
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
            
        location = [[CCDirector sharedDirector] convertToGL: location];
        
//        NSLog(@"touch move x = %f, y = %f", location.x, location.y);
        
    float deltax = trigbeginx - JOYCENTERX;
    float deltay = trigbeginy - JOYCENTERY;
    CGPoint p = ccp(location.x - deltax, location.y - deltay);
    if(ccpDistance(p, ccp(JOYCENTERX, JOYCENTERY)) < JOYFIELDRADIUS*SCALE*2)
        joyfire.position = p;
    
    [Common instance].direction = ccp(p.x - trigbeginx, p.y - trigbeginy);
    
//    NSLog(@"----------m");
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
//        NSLog(@"touch ended");
       
    if([Common instance].machinegun) {
    
        [Common instance].machinegun = NO;
        return;
    }
    
        [joyfire stopAllActions];
        [joyfire runAction:move_ease_in];
        
        flagbegin = NO;
    
    [Common instance].direction = ccp(0,0);
    
//    NSLog(@"----------e");
    
    
    if([[CCDirector sharedDirector] isPaused]) {
        
        [self hideGO];
        [[CCDirector sharedDirector] resume];
//        [[CCDirector sharedDirector] replaceScene:[Common instance].menuscene];
        [[CCDirector sharedDirector] popScene];
    }
}


-(void) dealloc {

    [move_ease_in release];
    
	[super dealloc];
}	

@end
