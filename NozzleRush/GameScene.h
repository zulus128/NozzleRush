
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface GameScene : CCLayer {
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;	
	
    b2World* world;	
    
    CCTexture2D *spriteTexture_;
    
    GLESDebugDraw *m_debugDraw;		// strong ref
    
    CGPoint debugPoint;
    b2PolygonShape debugShape;
    BOOL debug;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

+ (id) scene;

@end
