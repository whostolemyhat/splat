//
//  GameplayLayer.m
//  Splat
//
//  Created by James Tease on 26/10/2013.
//
//

#import "GameplayLayer.h"
#import "Monster.h"
#import "CCShake.h"

@implementation GameplayLayer

NSMutableArray *_monsters;

-(id) init {
    if(self = [super init]) {
        _monsters = [[NSMutableArray alloc] init];
        [self setIsTouchEnabled:YES];
        [self schedule:@selector(gameLogic:) interval:1.0];
    }
    
    return self;
}


-(void) addMonster {
    Monster *monster = [Monster spriteWithFile:@"enemyShip.png"];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // scale down on phones
        [monster setScaleX:winSize.width / 1024.0f];
        [monster setScaleY:winSize.height / 768.0f];
    }
    
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
        
    int startX = 0;
    int endX = 0;
    if(arc4random() % 2 != 1) {
        startX = winSize.width + monster.contentSize.width / 2;
        endX = -monster.contentSize.width / 2;
        
    } else {
        startX = -monster.contentSize.width / 2;
        endX = winSize.width + monster.contentSize.width / 2;
    }
    monster.position = ccp(startX, actualY);
    
    [self addChild:monster];
    
    // speed
    int minDuration = 8.0;
    int maxDuration = 10.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // actions!
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration
                                               position:ccp(endX, actualY)];
    CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [_monsters removeObject:node];
    }];
    [monster runAction:[CCSequence actions: actionMove, actionMoveDone, nil]];
    
    [_monsters addObject:monster];
}

-(void) gameLogic:(ccTime) dt {
    [self addMonster];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
    
    for(CCSprite *monster in _monsters) {
        if(CGRectContainsPoint(monster.boundingBox, location)) {
            [monstersToDelete addObject:monster];
        }
    }
    
    for(CCSprite *monster in monstersToDelete) {
        [_monsters removeObject:monster];
        [self removeChild:monster cleanup:YES];
        CCShaky3D *shake = [CCShaky3D actionWithRange:5 shakeZ:NO grid:ccg(1,1) duration:0.5];
        [self.parent runAction:shake];
    }
    [monstersToDelete release];
}

-(void) update: (ccTime) dt {
    
}

@end
