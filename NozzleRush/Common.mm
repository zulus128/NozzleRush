//
//  Common.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

@implementation Common

@synthesize direction;
@synthesize tileMap = _tileMap;
@synthesize world;

+ (Common*) instance  {
	
	static Common* instance;
	
	@synchronized(self) {
		
		if(!instance) {
			
			instance = [[Common alloc] init];
		}
	}
	return instance;
}

-(void) initPhysics
{
    
    //	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	self.world = new b2World(gravity);
	// Do we want to let bodies sleep?
	self.world->SetAllowSleeping(true);
	self.world->SetContinuousPhysics(true);
        
}

- (id) init{	
	
	self = [super init];
	if(self !=nil) {
 
        [self initPhysics];
    }
	return self;	
}

- (CGPoint) ort2iso:(CGPoint) pos {
    
    float mapHeight = _tileMap.mapSize.height;
    float mapWidth = _tileMap.mapSize.width;
    float tileHeight = _tileMap.tileSize.height;
    float tileWidth = _tileMap.tileSize.width;
    float ratio = tileWidth / tileHeight;
    
    int x = tileWidth /2 * ( mapWidth + pos.x/(tileWidth / ratio) - pos.y/tileHeight);// + 0.49f;
    int y = tileHeight /2 * (( mapHeight * 2 - pos.x/(tileWidth / ratio) - pos.y/tileHeight) +1);// + 0.49f;
    return ccp(x / CC_CONTENT_SCALE_FACTOR(), (y - 0.5f * tileHeight) / CC_CONTENT_SCALE_FACTOR());
}

-(void) dealloc {
   
    [_tileMap release];
    
    delete world;
	world = NULL;

    [super dealloc];
}

@end
