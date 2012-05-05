//
//  Common.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCALE 0.4f

@interface Common : NSObject

+ (Common*) instance;

@property (assign, readwrite) CGPoint direction;

@end
