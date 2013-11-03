//
//  BackgroundLayer.m
//  Splat
//
//  Created by James Tease on 20/10/2013.
//
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

-(id) init {
    self = [super init];
    if(self != nil) {
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        // Bug: first launch only covers half the screen, so stretch width
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"starBackground.png"
                              rect:CGRectMake(0, 0, screenSize.width * 2, screenSize.height)];
        ccTexParams params = { GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT };
        [backgroundImage.texture setTexParameters:&params];
        backgroundImage.position = ccp(screenSize.width / 2, screenSize.height / 2);

        [self addChild:backgroundImage z:0 tag:0];
    }
    
    return self;
}

@end
