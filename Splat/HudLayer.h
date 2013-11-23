//
//  HudLayer.h
//  Splat
//
//  Created by James Tease on 18/11/2013.
//
//

#import "CCLayer.h"

@interface HudLayer : CCLayer

-(void) showRestartMenu:(BOOL)won withMessage:(NSString *)message;

@end
