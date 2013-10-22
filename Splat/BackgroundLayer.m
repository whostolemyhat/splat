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
        CCSprite *backgroundImage;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        } else {
            backgroundImage = [CCSprite spriteWithFile:@"backgroundPhone.png"];
        }
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition:CGPointMake(screenSize.width / 2, screenSize.height / 2)];
        
        [self addChild:backgroundImage z:0 tag:0];
    }
    
    return self;
}

@end
