//
//  MenuScene.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "Common.h"

@implementation MenuScene

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuScene* layer = [MenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    
    if((self = [super init])) {				
        
        CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"Race" fontName:@"Helvetica" fontSize:38];
        CCMenuItemLabel* item1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(race:)];

        CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Free Ride" fontName:@"Helvetica" fontSize:38];
        CCMenuItemLabel* item2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(ride:)];

        CCMenu* menu = [CCMenu menuWithItems:item1, item2, nil];

        menu.position = ccp(0,0);
        item1.position = ccp(200, 200);	
        item2.position = ccp(400, 200);	
        
        [self addChild: menu];
    }
    return self;
}

- (void) race:(id) sender {

    [Common instance].gametype = GT_RACE;
    if(scene == nil)
        scene = [[GameScene scene] retain];
    [[Common instance].gamescene start];
	[[CCDirector sharedDirector] pushScene: scene]; 
    
}

- (void) ride:(id) sender {

    [Common instance].gametype = GT_FREERIDE;
    if(scene == nil)
        scene = [[GameScene scene] retain];
    [[Common instance].gamescene start];
	[[CCDirector sharedDirector] pushScene: scene]; 

}

@end
