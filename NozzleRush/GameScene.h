
#import "cocos2d.h"

@interface GameScene : CCLayer {
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;	
	
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

+ (id) scene;

@end
