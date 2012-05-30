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

- (id) initWithX: (int) x  Y:(int) y Type:(int) type {
    
    if((self = [super init])) {				
        
        typ = type;
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"car6.png"];
        [[Common instance].tileMap addChild:sprite z:0];    //corrected by Andrew Osipov 28.05.12
        
        CGPoint p = ccp(x,y);
        
        sprite.position = [[Common instance] ort2iso:p];
        sprite.scale = 0.5f;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        
        self.body = [Common instance].world->CreateBody(&bodyDef);
        self.body->SetLinearDamping(1.0f);
        self.body->SetUserData(sprite);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        //        dynamicBox.SetAsBox(2.1f, 2.1f);
        dynamicBox.SetAsBox(1.0f, 1.0f);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.02f;
        //        fixtureDef.friction = 4.3f;
        self.body->CreateFixture(&fixtureDef);
        
        
        
        [[Common instance] getCheckpoint:1];
        
    }
    return self;
}

- (void) update {
    
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
    } else name = @"car4.png";
    
    if(typ == CT_ME)
        NSLog(@"angle = %f, %f, %@", rot, a, name);
    
    CCSprite *eData = (CCSprite *)body->GetUserData();
    
    if(([Common instance].direction.x != 0) || ([Common instance].direction.y != 0) || (typ != CT_ME)) {
        
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:name];
        [eData setTexture: tex];
        
    }
    
    
    //    CCSprite *eData = (CCSprite *)(body->GetUserData());
    CGPoint ep = ccp(body->GetPosition().x * PTM_RATIO,
                     body->GetPosition().y * PTM_RATIO);
    eData.position = [[Common instance] ort2iso:ep];
    //    eData.rotation = -1 * CC_RADIANS_TO_DEGREES(enemy.body->GetAngle());
    
    if (typ == CT_ME) {
        
        CGPoint f = ccpMult([Common instance].direction, 1.0f);
        //        b2Vec2 ff1 = b2Vec2(f.x, -f.y);
        float32 ang = CC_DEGREES_TO_RADIANS(-45);
        float32 x2 = f.x * cos(ang) - (-f.y) * sin(ang);
        float32 y2 = (-f.y) * cos(ang) + f.x * sin(ang);
        //        b2Vec2 f2 = b2Vec2(cos(CC_DEGREES_TO_RADIANS(angle2)), sin(CC_DEGREES_TO_RADIANS(angle2)));
        b2Vec2 fforce1 = b2Vec2(x2, y2);
        fforce1.Normalize();
        fforce1 *= (float32)0.08f;
        body->ApplyLinearImpulse(fforce1, body->GetPosition());
        
        b2Vec2 toTarget = fforce1;
        float desiredAngle = atan2f( -toTarget.x, -toTarget.y );
        body->SetTransform( body->GetPosition(), desiredAngle );
        
        
        CGPoint p1 = eData.position;
        CGPoint p2 = [[Common instance] getCurCheckpoint];
        float d = ccpDistance(p1, p2);
        [Common instance].distToChp = d;
        if(d < 250) {
            
            [Common instance].checkpoint++;
            if([Common instance].checkpoint >= [[Common instance] getCheckpointCnt]) {
                
                [Common instance].checkpoint = 0;
                [Common instance].laps++;
                
            }
        }
        //        NSLog(@"dist = %f", d);
        
        return;
    }
    
    
    
    b2Vec2 force1 = b2Vec2(cos(CC_DEGREES_TO_RADIANS(angle)), sin(CC_DEGREES_TO_RADIANS(angle)));
    
    force1.Normalize();
    force1 *= (float32)0.08f;
    body->ApplyLinearImpulse(force1, body->GetPosition());
    
    b2Vec2 toTarget = force1;
    float desiredAngle = atan2f( -toTarget.x, -toTarget.y );
    body->SetTransform( body->GetPosition(), desiredAngle );
    
    b2Vec2 eyeOffset = b2Vec2(0, 0/*1.5*/);
    self.eye = body->GetWorldPoint(eyeOffset);
    self.target = force1;//b2Vec2(1, -0);
    self.target.Normalize();
    target *= 330.0;
    self.target = eye + target;
    
    RaysCastCallback callback;
    RaysCastCallback callback1;
    RaysCastCallback callback2;
    
    float l0 = 1000;
    float l1 = 1000;
    float l2 = 1000;
    
    [Common instance].world->RayCast(&callback, eye, target);    
    if (callback.m_fixture) {
        
        l0 = (eye - callback.m_point).Length();
        //        NSLog(@"ray intersect fixture x = %f, y = %f, l = %f, f = %f", callback.m_point.x, callback.m_point.y, l0, callback.m_fraction);
    }
    
    float angle1 = angle + 45;
    b2Vec2 f1 = b2Vec2(cos(CC_DEGREES_TO_RADIANS(angle1)), sin(CC_DEGREES_TO_RADIANS(angle1)));
    
    self.target1 = f1;//b2Vec2(1, -1);//eye - body->GetWorldCenter();
    self.target1.Normalize();
    target1 *= 18.0;
    self.target1 = eye + target1;
    [Common instance].world->RayCast(&callback1, eye, target1);    
    if (callback1.m_fixture) {
        
        l1 = (eye - callback1.m_point).Length();
        //        NSLog(@"ray intersect fixture1 x = %f, y = %f, l = %f, f = %f", callback1.m_point.x, callback1.m_point.y, l1, callback1.m_fraction);
    }
    
    float angle2 = angle - 45;
    b2Vec2 f2 = b2Vec2(cos(CC_DEGREES_TO_RADIANS(angle2)), sin(CC_DEGREES_TO_RADIANS(angle2)));
    
    self.target2 = f2;//b2Vec2(1, 1);//eye - body->GetWorldCenter();
    self.target2.Normalize();
    target2 *= 18.0;
    self.target2 = eye + target2;
    [Common instance].world->RayCast(&callback2, eye, target2);    
    if (callback2.m_fixture) {
        
        l2 = (eye - callback2.m_point).Length();
        //        NSLog(@"ray intersect fixture2 x = %f, y = %f, l = %f, f = %f", callback2.m_point.x, callback2.m_point.y, l2, callback2.m_fraction);
    }
    
    
    if ((l0 < 999) && (fabs(l1 - l2) > 6)) {
        
        //        NSLog(@"turn");
        
        if (l1 < l2) {
            
            angle -= 11.25;
        }
        else {
            
            angle += 11.25;
        }
    }
    //    NSLog(@"vel = %f", body->GetLinearVelocity().Normalize());
    
}

@end
