
#import "cocos2d.h"

@interface MenuScene : CCLayer {
    
    CCScene *scene;
}

+ (id) scene;

- (void) race:(id) sender;
- (void) ride:(id) sender;

@end
