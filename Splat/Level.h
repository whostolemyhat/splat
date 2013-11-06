//
//  Level.h
//  Splat
//
//  Created by James Tease on 03/11/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level : NSObject

@property (nonatomic, assign) int levelNum;
@property (nonatomic, assign) int secsPerSpawn;
@property (nonatomic, assign) ccColor4B backgroundColour;
@property (nonatomic, assign) int nextLevel; // number enemies to kill to trigger next level
// array of enemy types

-(id) initWithLevelNum:(int)levelNum secsPerSpawn:(int)secsPerSpawn
backgroundColour:(ccColor4B)backgroundColour nextLevel:(int)nextLevel;

@end
