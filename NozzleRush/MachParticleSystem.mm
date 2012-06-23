//
//  MachParticleSystem.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import "MachParticleSystem.h"

@implementation MachParticleSystem

- (void)updateQuadWithParticle:(tCCParticle*)particle newPosition:(CGPoint)pos {
    
    /* use pos */
//    CGPoint p = ccpSub(self.position, particle->startPos);
//    CGPoint p = pos;
//    NSLog(@"Pos = %f, %f", p.x, p.y);


    [super updateQuadWithParticle:particle newPosition:pos];
}

- (void)update:(ccTime)dt {
    
    /* implement as cocos2d/CCParticleSystem.m -update: */
    particleIdx = 0;
    while (particleIdx <particleCount) {        
    
        tCCParticle *p = &particles[particleIdx];
        if([[Common instance] bum:ccpAdd(position_, p->pos)])
            p->color = (ccColor4F) {0.0f, 0.0f, 0.0f, 0.0f};
        
//        p->pos = [[Common instance] ort2iso:p->pos];
        
        particleIdx++;
    }

    
    [super update:dt];
}

@end