//
//  MachParticleSystem.m
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MachParticleSystem.h"

@implementation MachParticleSystem

- (void)updateQuadWithParticle:(tCCParticle*)particle newPosition:(CGPoint)pos {
    
    /* use pos */
    CGPoint p = ccpSub(self.position, particle->startPos);
    NSLog(@"Pos = %f, %f", p.x, p.y);
    
    [super updateQuadWithParticle:particle newPosition:pos];
}

- (void)update:(ccTime)dt {
    
    /* implement as cocos2d/CCParticleSystem.m -update: */
    
    [super update:dt];
}

@end