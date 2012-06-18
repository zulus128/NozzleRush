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
@synthesize laps, checkpoint, distToChp;
@synthesize gametype;
@synthesize  gamescene;
@synthesize heal;

+ (Common*) instance  {
	
	static Common* instance;
	
	@synchronized(self) {
		
		if(!instance) {
			
			instance = [[Common alloc] init];
		}
	}
	return instance;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    
//    int x = position.x / self.tileMap.tileSize.width;
//    int y = ((self.tileMap.mapSize.height * self.tileMap.tileSize.height) - position.y) / self.tileMap.tileSize.height;
//    return ccp(x, y);
    
    float halfMapWidth = self.tileMap.mapSize.width * 0.5f;
    float mapHeight = self.tileMap.mapSize.height;
    float tileWidth = self.tileMap.tileSize.width;
    float tileHeight = self.tileMap.tileSize.height;
    
    CGPoint tilePosDiv = CGPointMake(position.x / tileWidth, position.y / tileHeight);
    float inverseTileY = mapHeight - tilePosDiv.y;
    
    float posX = (int)(inverseTileY + tilePosDiv.x - halfMapWidth);
    float posY = (int)(inverseTileY - tilePosDiv.x + halfMapWidth);
    
    return ccp(posX, posY);
}

- (CGPoint) getMapObjectPos:(NSString*) name {
    
    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found");
    
    NSMutableDictionary *spawnPoint = [objects objectNamed:name];        
    NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
    
    float x = [[spawnPoint valueForKey:@"x"] integerValue];
    float y = [[spawnPoint valueForKey:@"y"] integerValue];

    return ccp(x, y);
}

- (int) getCheckpointCnt {
    
    return chp_cnt;
}

- (CGPoint) getCurCheckpoint {

    return [self getCheckpoint:self.checkpoint];
}

- (CGPoint) getCheckpoint:(int) c {
    
    if(chp_cnt > 0)
        return [self ort2iso: chp[c]];
    
    CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found 1");
    
    chp_cnt = 0;
    NSMutableDictionary *sp;
    do {

        NSString* s = [NSString stringWithFormat:@"%@%d", CHP_NAME, (chp_cnt + 1)];
        sp = [objects objectNamed:s];        
        if(sp != nil) {
            
            float x = [[sp valueForKey:@"x"] integerValue];
            float y = [[sp valueForKey:@"y"] integerValue];
            chp[chp_cnt++] = ccp(x, y); 
//            NSLog(@"Checkpoint%d x = %f, y = %f", chp_cnt, x, y);
        }
        
    } while (sp != nil);

    if (chp_cnt > 0)
        return [self ort2iso: chp[c]];

    return ccp(0, 0);
}

-(void) initPhysics {
    
    //	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	self.world = new b2World(gravity);
	// Do we want to let bodies sleep?
	self.world->SetAllowSleeping(true);
	self.world->SetContinuousPhysics(true);
        
}

- (id) init {	
	
	self = [super init];
	if(self !=nil) {
 
        [self initPhysics];
        
//        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"RaceMapTest5.tmx"];
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"MoonMap.tmx"];
        
        chp_cnt = -1;
        
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
