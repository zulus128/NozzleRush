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
#import "MachParticleSystem.h"

@implementation Car
@synthesize body;
@synthesize target, target1, target2, eye;
@synthesize jump;
@synthesize oil/*, heal*/;

- (id) initWithType:(int) type {
    
    if((self = [super init])) {				
        
        typ = type;
        
        sprite = [CCSprite spriteWithFile:@"car2.png"];
        [[Common instance].tileMap addChild:sprite z:0];    //corrected by Andrew Osipov 28.05.12
        
        sprite.scale = 0.5f;
        
        bodyDef.type = b2_dynamicBody;
        
        self.body = [Common instance].world->CreateBody(&bodyDef);
        self.body->SetLinearDamping(1.0f);
//        self.body->SetUserData(sprite);
        self.body->SetUserData(self);
        
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
        
        
        hdir = 1;

//        emitter = [CCParticleSmoke node];
        emitter = [[CCParticleSmoke alloc] initWithTotalParticles:40];
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"smoke.png"];
        emitter.gravity = CGPointZero;
//        emitter.startColor = _color;
        emitter.posVar = CGPointZero;
        emitter.positionType = kCCPositionTypeRelative;
        emitter.emitterMode = kCCParticleModeRadius;
        [[Common instance].tileMap addChild:emitter z:-1];
//        [[Common instance].gamescene addChild:emitter z:1150];
        
        if (typ == CT_ME) {

//            mach = [[CCParticleSystemQuad particleWithFile:@"machinegun.plist"] retain];
            mach = [[MachParticleSystem particleWithFile:@"machinegun.plist"] retain];
            mach.positionType = kCCPositionTypeRelative;

            [[Common instance].tileMap addChild:mach z:0];
            
            [mach stopSystem];
        }
    }
    return self;
}

-(void) dealloc {

    [emitter release];

    if (typ == CT_ME)        
        [mach release];
    
    [super dealloc];
}

- (void) setPosX:(int)x Y:(int)y {

    CGPoint p = ccp(x, y);
    sprite.position = [[Common instance] ort2iso:p];
//    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    body->SetTransform(b2Vec2(x / PTM_RATIO, y / PTM_RATIO), 0);

    [[Common instance] getCheckpoint:1];
    
    angle = 180;
    
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"car2.png"];
    [sprite setTexture: tex];

    mach_angle = 315;
    
    emitter.position = [[Common instance] ort2iso:p];

    if (typ == CT_ME)
        mach.position = [[Common instance] ort2iso:p];

}

- (CGPoint) getGroundPosition {
    
//    NSLog(@"hh = %d", hh);
//    return ccp(sprite.position.x, sprite.position.y - ((hh<0)?0:(hh>hmax?hmax:hh)));
    
    return groundPosition;
}

- (void) update {
    
    float rot = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
    
    NSString* name = @"car1.png";
    float a = (rot < 0)?(360 + rot):rot;
    a = a + 22.5f;
    
    float b = 0;
    
    if (a < 360.0f) {
        if (a < 315.0f) {
            if (a < 270.0f) {
                if (a < 225.0f) {
                    if (a < 180.0f) {
                        if (a < 135.0f) {
                            if (a < 90.0f) {
                                if (a < 45.0f) {
                                    name = @"car4.png"; b = 45;
                                } else {name = @"car5.png"; b = 90;}
                            } else {name = @"car6.png"; b = 135;}
                        } else {name = @"car7.png"; b = 180;}
                    } else {name = @"car8.png"; b = 225;}
                } else {name = @"car1.png"; b = 270;}
            } else {name = @"car2.png"; b = 315;}
        } else {name = @"car3.png"; b = 0;}
    } else {name = @"car4.png"; b = 45;}
    
    
//    if(typ == CT_ME)
//        NSLog(@"angle = %f, %f, %@", rot, a, name);
    
//    CCSprite *eData = (CCSprite *)body->GetUserData();
    
    if(([Common instance].direction.x != 0) || ([Common instance].direction.y != 0) || (typ != CT_ME)) {
        
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:name];
//        [eData setTexture: tex];
        [sprite setTexture: tex];
        
        mach_angle = b;
    }
    

    
    //    CCSprite *eData = (CCSprite *)(body->GetUserData());
    CGPoint ep = ccp(body->GetPosition().x * PTM_RATIO,
                     body->GetPosition().y * PTM_RATIO);
    
//    if(typ == CT_ME)
//        NSLog(@"me x=%f, y=%f",ep.x, ep.y);
    
    CGPoint ep1 = [[Common instance] ort2iso:ep];
    
    groundPosition = ep1;
    
    if(self.jump) {
    
    ep1.y += hh;
    
        hh += (float)(hstep * hdir)/* * ((hdir > 0)?1:1.1f)*/;
        
    if((hh > hmax) && (hdir > 0))
        hdir = -hdir;
        
        if(hh < 0) {
            self.jump = NO;
            hdir = 1;
        }
    }
    
//    eData.position = ep1;
    sprite.position = ep1;
    emitter.position = ep1;
    //    eData.rotation = -1 * CC_RADIANS_TO_DEGREES(enemy.body->GetAngle());
    
    if (typ == CT_ME) {
        
        CGPoint f = ccpMult([Common instance].direction, 1.0f);
        //        b2Vec2 ff1 = b2Vec2(f.x, -f.y);
        float32 ang = CC_DEGREES_TO_RADIANS(-45);
        
        if(self.oil) {
        
            ang = 4;
        }
        
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
        
        
//        CGPoint p1 = eData.position;
        CGPoint p1 = sprite.position;
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
        
        mach.position = ep1;
//        mach.rotation = CC_RADIANS_TO_DEGREES(desiredAngle) - 90;
        mach.rotation = mach_angle;
        if([Common instance].machinegun != prev_mach) {
            
            if ([Common instance].machinegun)
                [mach resetSystem];
            else
                [mach stopSystem];
            
        }
        prev_mach = [Common instance].machinegun;
        
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
