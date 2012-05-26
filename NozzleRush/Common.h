//
//  Common.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

#define SCALE 0.4f

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

#define MAX_CHECKPOINTS 50
#define CHP_NAME @"Checkpoint"

@interface Common : NSObject {
    
    CGPoint chp[MAX_CHECKPOINTS];
    int chp_cnt;
}

+ (Common*) instance;
- (CGPoint) getMapObjectPos:(NSString*) name;
- (CGPoint) ort2iso:(CGPoint) pos;
- (CGPoint) getCheckpoint:(int) c;
- (int) getCheckpointCnt;

@property (assign, readwrite) CGPoint direction;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic) b2World* world;

@end
