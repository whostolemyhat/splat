//
//  Level.m
//  Splat
//
//  Created by James Tease on 03/11/2013.
//
//

#import "Level.h"

@implementation Level

-(id) initWithLevelNum:(int)levelNum secsPerSpawn:(int)secsPerSpawn
      backgroundColour:(ccColor4B)backgroundColour {
    if(self = [super init]) {
        self.levelNum = levelNum;
        self.secsPerSpawn = secsPerSpawn;
        self.backgroundColour = backgroundColour;
    }
    
    return self;
}

@end