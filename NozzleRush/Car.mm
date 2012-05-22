//
//  Car.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Car.h"
#import "Common.h"

@implementation Car

-(id) initWithX: (int) x  Y:(int) y {
    
    if((self = [super init])) {				
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"car4.png"];
        [[Common instance].tileMap addChild:sprite z:51];
        
        CGPoint p = ccp(x,y);
        
        sprite.position = [[Common instance] ort2iso:p];

        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        
        body = [Common instance].world->CreateBody(&bodyDef);
        body->SetLinearDamping(1.0f);
        body->SetUserData(sprite);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(2.1f, 2.1f);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.02f;
        //        fixtureDef.friction = 4.3f;
        body->CreateFixture(&fixtureDef);
        
    }
    return self;
}

@end
