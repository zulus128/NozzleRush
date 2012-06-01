//
//  HudLayer.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface HudLayer : CCLayer {
    
    float trigbeginx, trigbeginy;
    BOOL flagbegin;
    CCSprite* joyfire;
    id move_ease_in;
    
    CCLabelTTF* score;
    
    CCLabelTTF* label2;
}

- (void) updateScore;
- (void) showGO;
- (void) hideGO;

@end
