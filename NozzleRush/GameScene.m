//
//  GameScene.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene* layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer z:1];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {

    if((self = [super init])) {				
	
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
		self.background.anchorPoint = ccp(0, 0);
		[self addChild:_tileMap z:0];
		
		// Call game logic about every second
//        [self schedule:@selector(update:)];
//		[self schedule:@selector(gameLogic:) interval:1.0];		
		
		self.position = ccp(-228, -122);
		
    }
    return self;
}

@end
