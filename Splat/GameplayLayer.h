//
//  GameplayLayer.h
//  Splat
//
//  Created by James Tease on 26/10/2013.
//
//

#import "cocos2d.h"

@interface GameplayLayer : CCLayer {
    int _monstersDestroyed;

}

@property (nonatomic, retain) CCParticleSystem *emitter;

@end
