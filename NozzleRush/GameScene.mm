//
//  GameScene.m
//  NozzleRush
//
//  Created on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "HudLayer.h"
#import "Common.h"


enum {
	kTagParentNode = 1,
};

@implementation DebugStruc

@synthesize debugPoint;
@synthesize debugShape;

@end

@implementation GameScene

//@synthesize tileMap = _tileMap;
@synthesize hudLayer = _hudLayer;

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene* layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer z:1];
	
    HudLayer *hud = [HudLayer node];
	[scene addChild:hud z:2];
	layer.hudLayer = hud;
    
	// return the scene
	return scene;
}

- (void) setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, ([Common instance].tileMap.mapSize.width * [Common instance].tileMap.tileSize.width) 
            - winSize.width / 2);
    y = MIN(y, ([Common instance].tileMap.mapSize.height * [Common instance].tileMap.tileSize.height) 
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = ccpMult(viewPoint, 0.5f);
    self.position = viewPoint;
    
}


// on "init" you need to initialize your instance
-(id) init {
    
    if((self = [super init])) {				
        
        //        self.isTouchEnabled = YES;
        
        debugs = [[NSMutableArray alloc] init];
        
        //      self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"RaceMapTest1.tmx"];
        //		[self addChild:_tileMap z:-1];
        
        //        [Common instance].tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"RaceMapTest5.tmx"];
		[self addChild:[Common instance].tileMap z:-1];
		
        _background = [[Common instance].tileMap layerNamed:@"RoadLayer"];
        _background.position = ccp(0,0);
        
        
        // added by Andrew Osipov 28.05.12      
        [[[Common instance].tileMap layerNamed:@"BackBackgroundLayer"] setZOrder:-5];
        [[[Common instance].tileMap layerNamed:@"FrontBackgroundLayer"] setZOrder:-4];
        [[[Common instance].tileMap layerNamed:@"ColumnLayer"] setZOrder:-3];
        [[[Common instance].tileMap layerNamed:@"RoadLayer"] setZOrder:-2];
        [[[Common instance].tileMap layerNamed:@"BackBorderLayer"] setZOrder:-1];
        //zOrder:0 for cars
        [[[Common instance].tileMap layerNamed:@"FrontBorderLayer"] setZOrder:1];
        //==========================        
        debug = NO;
        
        //        [self initPhysics];
        
        m_debugDraw = new GLESDebugDraw( PTM_RATIO );
        [Common instance].world->SetDebugDraw(m_debugDraw);
        
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        //			flags += b2Draw::e_jointBit;
        //			flags += b2Draw::e_aabbBit;
        //			flags += b2Draw::e_pairBit;
        //			flags += b2Draw::e_centerOfMassBit;
        m_debugDraw->SetFlags(flags);
        
        
        [self processCollisionLayer];
        
        //        CCTMXObjectGroup *objects = [[Common instance].tileMap objectGroupNamed:@"Objects"];
        //        NSAssert(objects != nil, @"'Objects' object group not found");
        //        NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPoint"];        
        //        NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
        //        float x = [[spawnPoint valueForKey:@"x"] integerValue];
        //        float y = [[spawnPoint valueForKey:@"y"] integerValue];
        //        NSLog(@"SpawnPoint xy x = %f, y = %f, CC_CONTENT_SCALE_FACTOR = %f",x,y,CC_CONTENT_SCALE_FACTOR());
        
        
        //        CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"4test.png" capacity:10];
        //		spriteTexture_ = [parent texture];
        //		[_tileMap addChild:parent z:0 tag:kTagParentNode];
        //        PhysicsSprite* sprite = [PhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(0, 0, 191, 179)];						
        //        [parent addChild:sprite];
        
        //        CCSprite* sprite = [CCSprite spriteWithFile:@"car4.png"];
        //        [[Common instance].tileMap addChild:sprite z:50];
        //        
        //        CGPoint p = ccp(x,y);
        //
        //        sprite.position = [[Common instance] ort2iso:p];
        //        sprite.scale = 0.5f;
        //        NSLog(@"orttoiso SpawnPoint x = %f, y = %f",sprite.position.x,sprite.position.y);
        //        [self setViewpointCenter:sprite.position];
        //        
        //        // Define the dynamic body.
        //        //Set up a 1m squared box in the physics world
        //        b2BodyDef bodyDef;
        //        bodyDef.type = b2_dynamicBody;
        //        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        //        
        //        body = [Common instance].world->CreateBody(&bodyDef);
        //        body->SetLinearDamping(1.0f);
        //        body->SetUserData(sprite);
        //        
        //        // Define another box shape for our dynamic body.
        //        b2PolygonShape dynamicBox;
        ////        dynamicBox.SetAsBox(2.1f, 2.1f);
        //        dynamicBox.SetAsBox(1.0f, 1.0f);
        //        
        //        // Define the dynamic body fixture.
        //        b2FixtureDef fixtureDef;
        //        fixtureDef.shape = &dynamicBox;	
        //        fixtureDef.density = 0.02f;
        ////        fixtureDef.friction = 4.3f;
        //        body->CreateFixture(&fixtureDef);
        
        
        CGPoint sp = [[Common instance] getMapObjectPos:@"SpawnPoint"];
        
        me = [[Car alloc] initWithX: sp.x Y:sp.y Type:CT_ME];
        
        enemy = [[Car alloc] initWithX: sp.x+200 Y:sp.y+0 Type:CT_ENEMY];
        
        [self scheduleUpdate];
        
		
    }
    return self;
}

-(void) update: (ccTime) dt {
    
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	[Common instance].world->Step(dt, velocityIterations, positionIterations);	
    
    
    [me update];
    CCSprite *eData = (CCSprite *)(me.body->GetUserData());
    [self setViewpointCenter:eData.position];
    
    [enemy update];
    
    //    CCSprite *eData = (CCSprite *)(enemy.body->GetUserData());
    //    [self setViewpointCenter:eData.position];
    
    [self.hudLayer updateScore];
}

//- (CGPoint)boundLayerPos:(CGPoint)newPos {
//    
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    CGPoint retval = newPos;
//    retval.x = MIN(retval.x, 0);
//    retval.x = MAX(retval.x, -_tileMap.contentSize.width+winSize.width); 
//    retval.y = MIN(0, retval.y);
//    retval.y = MAX(-_tileMap.contentSize.height+winSize.height, retval.y); 
//    return retval;
//}
//
//- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {    
//        
//        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
//        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
//        touchLocation = [self convertToNodeSpace:touchLocation];                
//        
//    } else if (recognizer.state == UIGestureRecognizerStateChanged) {    
//        
//        CGPoint translation = [recognizer translationInView:recognizer.view];
//        translation = ccp(translation.x, -translation.y);
//        CGPoint newPos = ccpAdd(self.position, translation);
//        self.position = [self boundLayerPos:newPos];  
//        [recognizer setTranslation:CGPointZero inView:recognizer.view];    
//        
//    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        
//		float scrollDuration = 0.2;
//		CGPoint velocity = [recognizer velocityInView:recognizer.view];
//		CGPoint newPos = ccpAdd(self.position, ccpMult(ccp(velocity.x, velocity.y * -1), scrollDuration));
//		newPos = [self boundLayerPos:newPos];
//        
//		[self stopAllActions];
//		CCMoveTo *moveTo = [CCMoveTo actionWithDuration:scrollDuration position:newPos];            
//		[self runAction:[CCEaseOut actionWithAction:moveTo rate:1]];            
//        
//    }        
//}

-(void) dealloc
{
    //	delete world;
    //	world = NULL;
	
    //    [_tileMap release];
    
    delete m_debugDraw;
	m_debugDraw = NULL;
    
    [me release];
    [enemy release];
    
	[super dealloc];
}	


-(void) processCollisionLayer
{
    // create Box2d polygons for map collision boundaries
    CCTMXObjectGroup *collisionObjects = [[Common instance].tileMap objectGroupNamed:@"Collisions"];
    NSMutableArray *polygonObjectArray = [collisionObjects objects];
    // TMX polygon points delimiters (Box2d points must have counter-clockwise winding)
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString: @", "];
    int x, y, n, i, k, fX, fY;
    float area;
    NSString *pointsString;
    NSArray *pointsArray;
    for (id object in polygonObjectArray)
    {
        // NSLog(@"Poligon!!!");
        pointsString = [object valueForKey:@"polygonPoints"];
        if (pointsString != NULL)
        {
            pointsArray = [pointsString componentsSeparatedByCharactersInSet:characterSet];
            n = pointsArray.count;
            b2PolygonShape shape;
            shape.m_vertexCount = n/2;
            if (shape.m_vertexCount > b2_maxPolygonVertices)
            {
                // polygon has too many vertices, so skip over object
                NSLog(@"%s skipped TMX polygon at x=%d,y=%d for exceeding %d vertices", __PRETTY_FUNCTION__, x, y, b2_maxPolygonVertices);
                continue;
            }
            NSLog(@"pointsArray = %@", pointsArray);
            
            // build polygon verticies;
            for (i = 0, k = 0; i < n; ++k)
            {
                fX = [[pointsArray objectAtIndex:i] intValue];// / CC_CONTENT_SCALE_FACTOR();
                ++i;
                // flip y-position (TMX y-origin is upper-left)
                //                fY = - [[pointsArray objectAtIndex:i] intValue] / CC_CONTENT_SCALE_FACTOR();
                fY = [[pointsArray objectAtIndex:i] intValue];// / CC_CONTENT_SCALE_FACTOR();
                ++i;
                shape.m_vertices[k].Set(fX/PTM_RATIO, fY/PTM_RATIO);
            }
            
            // calculate area of a simple (ie. non-self-intersecting) polygon,
            // because it will be negative for counter-clockwise winding
            area = 0.0;
            n = shape.m_vertexCount;
            for (i = 0; i < n; ++i)
            {
                k = (i + 1) % n;
                area += (shape.m_vertices[k].x * shape.m_vertices[i].y) - (shape.m_vertices[i].x * shape.m_vertices[k].y);
            }
            if (area > 0)
            {
                // reverse order of vertices, because winding is clockwise
                b2PolygonShape reverseShape;
                reverseShape.m_vertexCount = shape.m_vertexCount;
                for (i = n - 1, k = 0; i > -1; --i, ++k)
                {
                    reverseShape.m_vertices[i].Set(shape.m_vertices[k].x, shape.m_vertices[k].y);
                }
                shape = reverseShape;
            }
            // must call 'Set', because it processes points
            shape.Set(shape.m_vertices, shape.m_vertexCount);
            x = [[object valueForKey:@"x"] intValue];// / CC_CONTENT_SCALE_FACTOR();
            y = [[object valueForKey:@"y"] intValue];// / CC_CONTENT_SCALE_FACTOR();
            // TODO add the box2d object to the box2d world at coordinate (x,y)
            
            NSLog(@"Point x = %d, y = %d",x,y);
            
            [self addWall:ccp(x,y) sh:shape];
            
            
            //            glLineWidth(3);
            //            ccDrawLine( ccp(x,y), ccp(x+width,y) );
            //            ccDrawLine( ccp(x+width,y), ccp(x+width,y+height) );
            //            ccDrawLine( ccp(x+width,y+height), ccp(x,y+height) );
            //            ccDrawLine( ccp(x,y+height), ccp(x,y) );
            //            glLineWidth(1);
        }
    }
    
}

//-(void) draw
//{
//    glLineWidth(3);
//    ccDrawLine( [self ort2iso:ccp(0,0)], [self ort2iso:ccp(800,800)] );
//    glLineWidth(1);
//}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
    //	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
    //	kmGLPushMatrix();
    //	world->DrawDebugData();	
    //	kmGLPopMatrix();
    
    if(! debug) {
        
        glLineWidth(3);
        
        for (int i = 0; i < [[Common instance] getCheckpointCnt]; i++) {
            
            CGPoint p = [[Common instance] getCheckpoint:i];
            //            ccDrawPoint([[Common instance]ort2iso:p]);
            ccDrawPoint(p);
        }
        
        float ex = enemy.eye.x * PTM_RATIO;
        float ey = enemy.eye.y * PTM_RATIO;
        float ex1 = enemy.target.x * PTM_RATIO;
        float ey1 = enemy.target.y * PTM_RATIO;
        
        ccDrawLine( [[Common instance] ort2iso:ccp(ex, ey)], [[Common instance] ort2iso:ccp(ex1, ey1)] );
        
        ex1 = enemy.target1.x * PTM_RATIO;
        ey1 = enemy.target1.y * PTM_RATIO;
        
        ccDrawLine( [[Common instance] ort2iso:ccp(ex, ey)], [[Common instance] ort2iso:ccp(ex1, ey1)] );
        
        ex1 = enemy.target2.x * PTM_RATIO;
        ey1 = enemy.target2.y * PTM_RATIO;
        
        ccDrawLine( [[Common instance] ort2iso:ccp(ex, ey)], [[Common instance] ort2iso:ccp(ex1, ey1)] );
        
        
        
        for (b2Fixture* f = enemy.body->GetFixtureList(); f; f = f->GetNext()) {
            
            b2PolygonShape* sh = (b2PolygonShape*)f->GetShape();
            
            int32 cnt = sh->GetVertexCount();
            b2Vec2 p0 = sh->GetVertex(0);
            b2Vec2 p00 = p0;
            float x = enemy.body->GetPosition().x * PTM_RATIO;
            float y = enemy.body->GetPosition().y * PTM_RATIO;
            for (int i = 1; i < cnt; i++) {
                
                b2Vec2 p = sh->GetVertex(i);
                //                ccDrawLine( [self ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [self ort2iso:ccp(x + p.x * PTM_RATIO, y + p.y * PTM_RATIO)] );
                ccDrawLine( [[Common instance] ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [[Common instance] ort2iso:ccp(x + p.x * PTM_RATIO, y + p.y * PTM_RATIO)] );
                p0 = p;
            }
            ccDrawLine( [[Common instance] ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [[Common instance] ort2iso:ccp(x + p00.x * PTM_RATIO, y + p00.y * PTM_RATIO)] );
            
        }
        
        for (b2Fixture* f = me.body->GetFixtureList(); f; f = f->GetNext()) {
            
            b2PolygonShape* sh = (b2PolygonShape*)f->GetShape();
            
            int32 cnt = sh->GetVertexCount();
            b2Vec2 p0 = sh->GetVertex(0);
            b2Vec2 p00 = p0;
            float x = me.body->GetPosition().x * PTM_RATIO;
            float y = me.body->GetPosition().y * PTM_RATIO;
            for (int i = 1; i < cnt; i++) {
                
                b2Vec2 p = sh->GetVertex(i);
                //                ccDrawLine( [self ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [self ort2iso:ccp(x + p.x * PTM_RATIO, y + p.y * PTM_RATIO)] );
                ccDrawLine( [[Common instance] ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [[Common instance] ort2iso:ccp(x + p.x * PTM_RATIO, y + p.y * PTM_RATIO)] );
                p0 = p;
            }
            ccDrawLine( [[Common instance] ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [[Common instance] ort2iso:ccp(x + p00.x * PTM_RATIO, y + p00.y * PTM_RATIO)] );
            
        }
        
        
        
        for (int j = 0; j < debugs.count; j++) {
            
            DebugStruc* ds = [debugs objectAtIndex:j];
            
            int32 cnt = ds.debugShape.GetVertexCount();
            b2Vec2 p0 = ds.debugShape.GetVertex(0);
            b2Vec2 p00 = p0;
            float x = ds.debugPoint.x;
            float y = ds.debugPoint.y;
            for (int i = 1; i < cnt; i++) {
                
                b2Vec2 p = ds.debugShape.GetVertex(i);
                ccDrawLine( [[Common instance] ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [[Common instance] ort2iso:ccp(x + p.x * PTM_RATIO, y + p.y * PTM_RATIO)] );
                p0 = p;
            }
            ccDrawLine( [[Common instance] ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [[Common instance] ort2iso:ccp(x + p00.x * PTM_RATIO, y + p00.y * PTM_RATIO)] );
        }
        
        glLineWidth(1);
    }
}

- (void) addWall: (CGPoint) p sh:(b2PolygonShape)shape {
    
    DebugStruc* ds = [[DebugStruc alloc] init];
    ds.debugPoint = p;
    ds.debugShape = shape;
    
    [debugs addObject:ds];
    
    
    debug = YES;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;/* b2_dynamicBody;*/
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *bodyw = [Common instance].world->CreateBody(&bodyDef);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
    fixtureDef.density = 1000.0f;
    fixtureDef.friction = 0.3f;
    bodyw->CreateFixture(&fixtureDef);
    
    //    NSLog(@"x = %f, y = %f",p.x,p.y);
    
}


@end
