//
//  GameScene.m
//  Splat
//
//  Created by James Tease on 22/10/2013.
//
//

#import "GameScene.h"

@implementation GameScene

+(id) scene {
    CCScene *scene = [CCScene node];
    
    GameScene *layer = [GameScene node];
    [scene addChild:layer];
    
    return scene;
}

-(id) init {

    if(self = [super init]) {
//        _hud = hud;
        
        BackgroundLayer *background = [BackgroundLayer node];
        [self addChild:background z: 0];
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z: 2];
//        HudLayer *hud = [HudLayer node];
//        [self addChild:hud z: 3];

    }
    
    return self;
}



@end
