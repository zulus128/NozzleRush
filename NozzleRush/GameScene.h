
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Car.h"
#import "Heal.h"

@interface DebugStruc : NSObject {
}
    
@property (readwrite) CGPoint debugPoint;
@property (nonatomic, readwrite) b2PolygonShape debugShape;

@end

@interface GameScene : CCLayer {
    
//    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;	
    CCTMXLayer *_background1;	
	
//    b2World* world;	
    
//    CCTexture2D *spriteTexture_;
    
    GLESDebugDraw *m_debugDraw;		// strong ref
    
//    CGPoint debugPoint;
//    b2PolygonShape debugShape;
    BOOL debug;
    
//    b2Body *body;
    
    NSMutableArray* debugs;
    
    Car* me;
    Car* enemy;
    
    Heal* heal;
    
    int tr_cnt;
    
}

//@property (nonatomic, retain) CCTMXTiledMap *tileMap;
//@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCLayer *hudLayer;

+ (id) scene;
- (void) setViewpointCenter:(CGPoint) position;
- (b2PolygonShape) getShape:(id) object;

//@property (nonatomic, retain) NSTimer* timer;

@end
