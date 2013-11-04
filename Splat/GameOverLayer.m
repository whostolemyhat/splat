//
//  GameOverLayer.m
//  Splat
//
//  Created by James Tease on 02/11/2013.
//
//

#import "GameOverLayer.h"
#import "GameScene.h"
#import "LevelManager.h"

@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild:layer];
    return scene;
}

-(id) initWithWon:(BOOL)won {
    if(self == [super init]) {
        NSString *message;
        if(won) {
            [[LevelManager sharedInstance] nextLevel];
            Level *curLevel = [[LevelManager sharedInstance] curLevel];
            if(curLevel) {
                message = [NSString stringWithFormat:@"Get ready for level %d", curLevel.levelNum];
            } else {
                message = @"You win";
                [[LevelManager sharedInstance] reset];
            }
            
        } else {
            message = @"You lose";
            [[LevelManager sharedInstance] reset];
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(255,255,255);
        label.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:label];
        
        [self runAction: [CCSequence actions:
            [CCDelayTime actionWithDuration:3],
                          [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
        }],
                          nil]];
    }
    
    return self;
}

@end
