
#import "cocos2d.h"
#import "Box2D.h"

@interface GameScene : CCLayer {
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;	
	
    b2World* world;	
    
    CCTexture2D *spriteTexture_;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

+ (id) scene;

@end
