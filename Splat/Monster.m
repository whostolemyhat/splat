//
//  Monster.m
//  Splat
//
//  Created by James Tease on 27/10/2013.
//
//

#import "Monster.h"

@implementation Monster

-(id) initWithFile:(NSString *)filename hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration {
    if(self = [super initWithFile:filename]) {
        self.hp = hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
    }
    
    return self;
}

@end


@implementation SlowMonster

-(id) init {
    self = [super initWithFile:@"enemyShip.png" hp:2 minMoveDuration:5 maxMoveDuration:10];
    return self;
}

@end

@implementation FastMonster

-(id) init {
    self = [super initWithFile:@"enemyUFO.png" hp:1 minMoveDuration:3 maxMoveDuration:5];
    return self;
}

@end

@implementation Asteroid

-(id) init {
    self = [super initWithFile:@"meteorSmall.png" hp:1 minMoveDuration:5 maxMoveDuration:8];
    return self;
}

@end