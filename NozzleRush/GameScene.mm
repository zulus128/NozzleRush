//
//  GameScene.m
//  NozzleRush
//
//  Created on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "PhysicsSprite.h"
#import "HudLayer.h"
#import "Common.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

enum {
	kTagParentNode = 1,
};

@implementation GameScene

@synthesize tileMap = _tileMap;
@synthesize hudLayer = _hudLayer;

-(void) initPhysics
{

    //	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	world = new b2World(gravity);
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	world->SetContinuousPhysics(true);
    
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
			flags += b2Draw::e_jointBit;
			flags += b2Draw::e_aabbBit;
			flags += b2Draw::e_pairBit;
			flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
    
}

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

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width) 
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) 
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = ccpMult(viewPoint, 0.5f);
    self.position = viewPoint;
    
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

// on "init" you need to initialize your instance
-(id) init {

    if((self = [super init])) {				
	
//        self.isTouchEnabled = YES;
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"RaceMapTest1.tmx"];
		[self addChild:_tileMap z:-1];
		
        
        
        _background = [self.tileMap layerNamed:@"LayerTile7"];
        _background.position = ccp(81,0);

        _background1 = [self.tileMap layerNamed:@"LayerTile7Down"];
        _background1.position = ccp(83,2);

        
        debug = NO;
        
        [self initPhysics];
        
        [self processCollisionLayer];
        
        CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"Objects"];
        NSAssert(objects != nil, @"'Objects' object group not found");
        NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPoint"];        
        NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
        float x = [[spawnPoint valueForKey:@"x"] integerValue];
        float y = [[spawnPoint valueForKey:@"y"] integerValue];
        NSLog(@"SpawnPoint xy x = %f, y = %f, CC_CONTENT_SCALE_FACTOR = %f",x,y,CC_CONTENT_SCALE_FACTOR());
        
        
//        CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"4test.png" capacity:10];
//		spriteTexture_ = [parent texture];
//		[_tileMap addChild:parent z:0 tag:kTagParentNode];
//        PhysicsSprite* sprite = [PhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(0, 0, 191, 179)];						
//        [parent addChild:sprite];
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"car4.png"];
        [_tileMap addChild:sprite z:50];
        
        CGPoint p = ccp(x,y);

        sprite.position = [self ort2iso:p];
        NSLog(@"orttoiso SpawnPoint x = %f, y = %f",sprite.position.x,sprite.position.y);
        [self setViewpointCenter:sprite.position];
        
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        
        body = world->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 4.3f;
        body->CreateFixture(&fixtureDef);
        body->SetLinearDamping(1.0f);
        
//        [sprite setPhysicsBody:body];
        
        body->SetUserData(sprite);
                
//        body->ApplyLinearImpulse(b2Vec2(0, -3), body->GetWorldCenter());
        
//        body->SetTransform(body->GetPosition(), CC_DEGREES_TO_RADIANS(90));
        
        [self scheduleUpdate];

		
    }
    return self;
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);	
    
         CGPoint f = ccpMult([Common instance].direction, 1.0f);
         b2Vec2 force1 = b2Vec2(f.x, -f.y);
         force1.Normalize();
         force1 *= (float32)0.5f;
//        world->ClearForces();
//        body->ApplyForce(force1, body->GetPosition());
        body->ApplyLinearImpulse(force1, body->GetPosition());
         
//    float bodyAngle = body->GetAngle();
//    CGPoint vehicleDirectionVector = ccpNormalize(ccpSub(ccp(vehicleBonnetTip.x*PTM_RATIO, vehicleBonnetTip.y*PTM_RATIO), ccp(vehicleCenter.x*PTM_RATIO, vehicleCenter.y*PTM_RATIO)));
    b2Vec2 toTarget = force1;
    float desiredAngle = atan2f( -toTarget.x, -toTarget.y );
    body->SetTransform( body->GetPosition(), desiredAngle );
    
//    NSLog(@"desiredAngle = %f",desiredAngle);

    CCSprite *carData = (CCSprite *)body->GetUserData();
    CGPoint p = ccp(body->GetPosition().x * PTM_RATIO,
                    body->GetPosition().y * PTM_RATIO);
    carData.position = [self ort2iso:p];
//    carData.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
    
    float rot = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
    
    NSString* name = @"car1.png";
    float a = (rot < 0)?(360 + rot):rot;
    a = a + 22.5f;
    
    if (a < 360.0f) {
        if (a < 315.0f) {
            if (a < 270.0f) {
                if (a < 225.0f) {
                    if (a < 180.0f) {
                        if (a < 135.0f) {
                            if (a < 90.0f) {
                                if (a < 45.0f) {
                                   name = @"car4.png";  
                                } else name = @"car5.png";
                            } else name = @"car6.png";
                        } else name = @"car7.png";
                    } else name = @"car8.png";
                } else name = @"car1.png";
            } else name = @"car2.png";
        } else name = @"car3.png";
    }

//    NSLog(@"angle = %f, name = %@", a, name);
    if(([Common instance].direction.x != 0) || ([Common instance].direction.y != 0)) {

        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:name];
        [carData setTexture: tex];
        
    }
    
    [self setViewpointCenter:carData.position];

//    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {    
//        if (b->GetUserData() != NULL) {
//
//            
//            CCSprite *ballData = (CCSprite *)b->GetUserData();
//            
//            CGPoint p = ccp(b->GetPosition().x * PTM_RATIO,
//                                    b->GetPosition().y * PTM_RATIO);
//            ballData.position = [self ort2iso:p];
//            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
//            
//            [self setViewpointCenter:ballData.position];
//        }        
//    }
    
//    world->ClearForces();

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
	delete world;
	world = NULL;
	
    [_tileMap release];
        
    delete m_debugDraw;
	m_debugDraw = NULL;

	[super dealloc];
}	


-(void) processCollisionLayer
{
    // create Box2d polygons for map collision boundaries
    CCTMXObjectGroup *collisionObjects = [_tileMap objectGroupNamed:@"Collisions"];
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
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
    
    
//    if(debug) {
//        
//        glLineWidth(3);
//        int32 cnt = debugShape.GetVertexCount();
//        b2Vec2 p0 = debugShape.GetVertex(0);
//        b2Vec2 p00 = p0;
//        float x = debugPoint.x;
//        float y = debugPoint.y;
//        for (int i = 1; i < cnt; i++) {
//            
//            b2Vec2 p = debugShape.GetVertex(i);
//            ccDrawLine( [self ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [self ort2iso:ccp(x + p.x * PTM_RATIO, y + p.y * PTM_RATIO)] );
//            p0 = p;
//        }
//        ccDrawLine( [self ort2iso:ccp(x + p0.x * PTM_RATIO, y + p0.y * PTM_RATIO)], [self ort2iso:ccp(x + p00.x * PTM_RATIO, y + p00.y * PTM_RATIO)] );
//
//        glLineWidth(1);
//    }
}

- (void) addWall: (CGPoint) p sh:(b2PolygonShape)shape {

    debugPoint = p;
    debugShape = shape;
    debug = YES;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;/* b2_dynamicBody;*/
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *bodyw = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
//    b2PolygonShape dynamicBox;
//    dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    bodyw->CreateFixture(&fixtureDef);
    
    
    NSLog(@"x = %f, y = %f",p.x,p.y);
    
    
//    b2BodyDef groundBodyDef;
//	groundBodyDef.position.Set(p.x, p.y); // bottom-left corner
//    // Call the body factory which allocates memory for the ground body
//	// from a pool and creates the ground box shape (also from a pool).
//	// The body is also added to the world.
//	b2Body* groundBody = world->CreateBody(&groundBodyDef);
//	
//	groundBody->CreateFixture(&shape,0);
	

   
}


@end
