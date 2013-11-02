//
//  GameOverLayer.m
//  Splat
//
//  Created by James Tease on 02/11/2013.
//
//

#import "GameOverLayer.h"
#import "GameScene.h"

@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild:layer];
    return scene;
}

-(id) initWithWon:(BOOL)won {
    if(self == [super initWithColor:ccc4(255, 255, 255, 255)]) {
        NSString *message;
        if(won) {
            message = @"You win";
        } else {
            message = @"You lose";
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
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
