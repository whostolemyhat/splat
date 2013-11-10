//
//  Monster.h
//  Splat
//
//  Created by James Tease on 27/10/2013.
//
//

#import "cocos2d.h"

@interface Monster : CCSprite  

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;
@property (nonatomic, assign) NSString *type;

-(id) initWithFile:(NSString *)filename hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration;

@end

@interface FastMonster : Monster

@end

@interface SlowMonster : Monster

@end

@interface Asteroid : Monster

@end

@interface LargeAsteroid : Monster

@end