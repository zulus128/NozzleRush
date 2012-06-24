//
//  Rocket.mm
//  NozzleRush
//
//  Created by вадим on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Rocket.h"
#import "Common.h"

@implementation Rocket

@synthesize body;

- (id) initWithX: (int) x  Y:(int) y  Angle:(float32) a Type:(int) type {
   
    if((self = [super init])) {				
        
        typ = type;
//        angle = a;
        self.tag = ROCKET_TAG;
        
        sprite = [CCSprite spriteWithFile:@"rock.png"];
        [[Common instance].tileMap addChild:sprite z:0];    //corrected by Andrew Osipov 28.05.12
        
        bodyDef.type = b2_dynamicBody;
        
        self.body = [Common instance].world->CreateBody(&bodyDef);
        self.body->SetLinearDamping(1.0f);
        //        self.body->SetUserData(sprite);
        self.body->SetUserData(self);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        //        dynamicBox.SetAsBox(2.1f, 2.1f);
        dynamicBox.SetAsBox(0.5f, 0.5f);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.02f;
        //        fixtureDef.friction = 4.3f;
        self.body->CreateFixture(&fixtureDef);
        
        self.body->SetTransform( b2Vec2(x, y), a );
        
        CGPoint f = ccpMult(/*[Common instance].direction*/ccp(-1,0), 1.0f);
        
        float32 x2 = f.x * cos(a) - (-f.y) * sin(a);
        float32 y2 = (-f.y) * cos(a) + f.x * sin(a);

        b2Vec2 fforce1 = b2Vec2(x2, y2);
        fforce1.Normalize();
//        fforce1 *= (float32)0.08f;
        body->ApplyLinearImpulse(fforce1, body->GetPosition());

        sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(self.body->GetAngle());
    }
    return self;
}

-(void) dealloc {
    
//    [sprite stopAllActions];
    [[Common instance].tileMap removeChild:sprite cleanup:YES];
    [Common instance].world->DestroyBody( self.body );
    self.body = nil;
    
    NSLog(@"Rocket dealloc");
    
    [super dealloc];
}

- (void) update {

    CGPoint ep = ccp(body->GetPosition().x * PTM_RATIO,
                     body->GetPosition().y * PTM_RATIO);
    
    CGPoint ep1 = [[Common instance] ort2iso:ep];
    
    sprite.position = ep1;

}

@end
