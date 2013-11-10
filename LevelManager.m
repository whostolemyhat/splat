//
//  LevelManager.m
//  Splat
//
//  Created by James Tease on 03/11/2013.
//
//

#import "LevelManager.h"

@implementation LevelManager {
    NSArray *_levels;
    int _curLevelIdx;
}

+(LevelManager *) sharedInstance {
    static dispatch_once_t once;
    static LevelManager *sharedInstance; dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id) init {
    if(self = [super init]) {
        _curLevelIdx = 0;
        Level *level1 = [[[Level alloc] initWithLevelNum:1 secsPerSpawn:2 asteroidSpawn:2
                                        backgroundColour:ccc3(255, 255, 255)
                                               nextLevel:10] autorelease];
        Level *level2 = [[[Level alloc] initWithLevelNum:2 secsPerSpawn:1 asteroidSpawn: 4
                                        backgroundColour:[self randomColour]
                                        nextLevel:30] autorelease];
        _levels = [@[level1, level2] retain];
    }
    
    return self;
}

-(Level *) curLevel {
    if(_curLevelIdx >= _levels.count) {
        return nil;
    }
    return _levels[_curLevelIdx];
}

-(void) nextLevel {
    _curLevelIdx++;
}

-(void) reset {
    _curLevelIdx = 0;
}

-(void) dealloc {
    [_levels release];
    _levels = nil;
    [super dealloc];
}

-(ccColor3B) randomColour {
    int red = arc4random() % 256;
    int green = arc4random() % 256;
    int blue = arc4random() % 256;
    
    ccColor3B randomColour = ccc3(red, green, blue);
    return randomColour;
}

@end
