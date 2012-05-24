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
@synthesize target, target1, target2, eye;

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
    CGPoint f = ccp(0, 1);
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
    
    
    b2Vec2 eyeOffset = b2Vec2(0, 0/*1.5*/);
    self.eye = body->GetWorldPoint(eyeOffset);
    self.target = force1;//b2Vec2(1, -0);
    self.target.Normalize();
    target *= 80.0;
    self.target = eye + target;
    
    RaysCastCallback callback;
    RaysCastCallback callback1;
    RaysCastCallback callback2;
    
    [Common instance].world->RayCast(&callback, eye, target);    
    if (callback.m_fixture) {
        
        NSLog(@"ray intersect fixture x = %f, y = %f, l = %f, f = %f", callback.m_point.x, callback.m_point.y, (eye - callback.m_point).Length(), callback.m_fraction);
    }

    self.target1 = b2Vec2(1, -1);//eye - body->GetWorldCenter();
    self.target1.Normalize();
    target1 *= 8.0;
    self.target1 = eye + target1;
    [Common instance].world->RayCast(&callback1, eye, target1);    
    if (callback1.m_fixture) {
        
        NSLog(@"ray intersect fixture1 x = %f, y = %f, l = %f, f = %f", callback1.m_point.x, callback1.m_point.y, (eye - callback1.m_point).Length(), callback1.m_fraction);
    }

    self.target2 = b2Vec2(1, 1);//eye - body->GetWorldCenter();
    self.target2.Normalize();
    target2 *= 8.0;
    self.target2 = eye + target2;
    [Common instance].world->RayCast(&callback2, eye, target2);    
    if (callback2.m_fixture) {
        
        NSLog(@"ray intersect fixture2 x = %f, y = %f, l = %f, f = %f", callback2.m_point.x, callback2.m_point.y, (eye - callback2.m_point).Length(), callback2.m_fraction);
    }

    
//    NSLog(@"vel = %f", body->GetLinearVelocity().Normalize());

}

@end
