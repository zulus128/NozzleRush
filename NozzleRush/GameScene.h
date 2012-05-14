
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface GameScene : CCLayer {
    
    CCTMXTiledMap *_tileMap;
//    CCTMXLayer *_background;	
	
    b2World* world;	
    
    CCTexture2D *spriteTexture_;
    
    GLESDebugDraw *m_debugDraw;		// strong ref
    
    CGPoint debugPoint;
    b2PolygonShape debugShape;
    BOOL debug;
    
    b2Body *body;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
//@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCLayer *hudLayer;

+ (id) scene;

@end
