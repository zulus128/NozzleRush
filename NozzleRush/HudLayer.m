//
//  HudLayer.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"
#import "Common.h"


#define JOYCENTERX 50
#define JOYCENTERY 50
#define JOYTRIGGERRADIUS 102

@implementation HudLayer
-(id) init
{
	if ((self = [super init])) {

//		CGSize winSize = [[CCDirector sharedDirector] winSize];

        self.isTouchEnabled = YES;
        
        CCSprite* joyfield = [CCSprite spriteWithFile:@"Button_field_1.png"];
        [self addChild:joyfield];
        joyfield.scale = SCALE;
        joyfield.position = ccp(JOYCENTERX, JOYCENTERY);

        CCSprite* joyfire = [CCSprite spriteWithFile:@"Button_trigger_1.png"];
        [self addChild:joyfire];
        joyfire.scale = SCALE;
        joyfire.position = ccp(JOYCENTERX, JOYCENTERY);

	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];

		NSLog(@"touch began x = %f, y = %f", location.x, location.y);
        
        if((fabs(location.x - JOYCENTERX)<JOYTRIGGERRADIUS*SCALE) && (fabs(location.y - JOYCENTERY)<JOYTRIGGERRADIUS*SCALE)) {
            
            trigbeginx = location.x;
            trigbeginy = location.y;
        }
	}
}

@end
