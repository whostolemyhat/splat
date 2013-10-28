//
//  GameScene.m
//  Splat
//
//  Created by James Tease on 22/10/2013.
//
//

#import "GameScene.h"

@implementation GameScene

-(id) init {
    self = [super init];

    if(self != nil) {
        BackgroundLayer *background = [BackgroundLayer node];
        [self addChild:background z: 0];
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z: 1];
    }
    
    return self;
}


@end
