//
//  GameOverLayer.h
//  Splat
//
//  Created by James Tease on 02/11/2013.
//
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayer

+(CCScene *) sceneWithWon:(BOOL)won;
-(id) initWithWon:(BOOL)won;

@end
