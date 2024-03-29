//
//  Common.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Car.h"

#define SCALE 0.4f

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

#define MAX_CHECKPOINTS 50
#define CHP_NAME @"Checkpoint"
#define TRP_NAME @"Tramplin"
#define OIL_NAME @"oilSpot"
#define HEAL_NAME @"healingPoint"

#define LAPS_CNT 3

#define TRAMPLIN_TAG 3000
#define OILSPOT_TAG 3001
#define HEAL_TAG 3002
//#define ME_TAG 2000
#define CAR_TAG 2000
#define ROCKET_TAG 2001

enum game_type { GT_RACE, GT_FREERIDE };

@interface Common : NSObject {
    
    CGPoint chp[MAX_CHECKPOINTS];
    int chp_cnt;
    NSMutableSet* remove_objects;
}

+ (Common*) instance;
- (CGPoint) getMapObjectPos:(NSString*) name;
- (CGPoint) ort2iso:(CGPoint) pos;
- (CGPoint) getCheckpoint:(int) c;
- (CGPoint) getCurCheckpoint;
- (int) getCheckpointCnt;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (BOOL) bum:(CGPoint) p;

- (void) markObjectForDelete:(CCNode*)obj;
- (void) deleteMarkedObjects;

@property (assign, readwrite) CGPoint direction;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic) b2World* world;
@property (assign, readwrite) int laps;
@property (assign, readwrite) int checkpoint;
@property (assign, readwrite) int distToChp;
@property (assign, readwrite) int gametype;
@property (nonatomic, retain) CCLayer* gamescene;
@property (assign, readwrite) BOOL heal;
@property (assign, readwrite) BOOL machinegun;

@property (nonatomic, retain) Car* enemy;
@property (nonatomic, retain) Car* me;


@end
