//
//  GameplayLayer.h
//  Splat
//
//  Created by James Tease on 26/10/2013.
//
//

#import "cocos2d.h"
#import "HudLayer.h"

@interface GameplayLayer : CCLayer {
    int _monstersDestroyed;
    HudLayer *_hud;
}

@property (nonatomic, retain) CCParticleSystem *emitter;
@property (nonatomic, retain) HudLayer *_hud;

+(CCScene *) scene;

@end
