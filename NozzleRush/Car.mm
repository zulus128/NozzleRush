//
//  Car.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Car.h"
#import "Common.h"
#import "RaysCastCallback.h"

@implementation Car
@synthesize body;
@synthesize target, eye;

- (id) initWithX: (int) x  Y:(int) y {
    
    if((self = [super init])) {				
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"car6.png"];
        [[Common instance].tileMap addChild:sprite z:51];
        
        CGPoint p = ccp(x,y);
        
        sprite.position = [[Common instance] ort2iso:p];

        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        
        self.body = [Common instance].world->CreateBody(&bodyDef);
        self.body->SetLinearDamping(1.0f);
        self.body->SetUserData(sprite);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(2.1f, 2.1f);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.02f;
        //        fixtureDef.friction = 4.3f;
        self.body->CreateFixture(&fixtureDef);
        
        
        

        
    }
    return self;
}

- (void) update {

//    CGPoint f = ccp(self.body->GetPosition().x, self.body->GetPosition().y + 0);
    CGPoint f = ccp(1, 0);
    b2Vec2 force1 = b2Vec2(f.x, -f.y);
    force1.Normalize();
    force1 *= (float32)0.08f;
    body->ApplyLinearImpulse(force1, body->GetPosition());
    
    b2Vec2 toTarget = force1;
    float desiredAngle = atan2f( -toTarget.x, -toTarget.y );
    body->SetTransform( body->GetPosition(), desiredAngle );
    
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
    
     
    CCSprite *eData = (CCSprite *)body->GetUserData();
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:name];
    [eData setTexture: tex];
    
//    CCSprite *eData = (CCSprite *)(body->GetUserData());
    CGPoint ep = ccp(body->GetPosition().x * PTM_RATIO,
                     body->GetPosition().y * PTM_RATIO);
    eData.position = [[Common instance] ort2iso:ep];
    //    eData.rotation = -1 * CC_RADIANS_TO_DEGREES(enemy.body->GetAngle());
    
    
    b2Vec2 eyeOffset = b2Vec2(0, 1.5);
    self.eye = body->GetWorldPoint(eyeOffset);
    self.target = b2Vec2(1, -0);//eye - body->GetWorldCenter();
    self.target.Normalize();
    target *= 8.0;
    self.target = eye + target;
    
    RaysCastCallback callback;
    [Common instance].world->RayCast(&callback, eye, target);
    
    if (callback.m_fixture) {
        
        NSLog(@"ray intersect fixture x = %f, y = %f, l = %f", callback.m_point.x, callback.m_point.y, callback.m_point.Normalize());
        
        //        monsterData.target = ccp(callback.m_point.x * [LevelHelperLoader pixelsToMeterRatio], 
        //                                 callback.m_point.y * [LevelHelperLoader pixelsToMeterRatio]);
        //        if (callback.m_fixture->GetBody() == _heroBody) {    
        //            monsterData.canSeePlayer = TRUE;
        //        }
    }

    
//    NSLog(@"vel = %f", body->GetLinearVelocity().Normalize());

}

@end
