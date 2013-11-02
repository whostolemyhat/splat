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
#import "GameOverLayer.h"

@implementation GameplayLayer


NSMutableArray *_monsters;
int _monstersDestroyed = 0;

-(id) init {
    if(self = [super init]) {
        _monsters = [[NSMutableArray alloc] init];
        [self setIsTouchEnabled:YES];
        [self schedule:@selector(gameLogic:) interval:1.0];
    }
    
    return self;
}


-(void) addMonster {
//    Monster *monster = [Monster spriteWithFile:@"enemyShip.png"];
    Monster *monster = nil;
    if(arc4random() % 2 ==0) {
        monster = [[[FastMonster alloc] init] autorelease];
    } else {
        monster = [[[SlowMonster alloc] init] autorelease];
    }
    
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
    int minDuration = monster.minMoveDuration; //8.0;
    int maxDuration = monster.maxMoveDuration; //10.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // actions!
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration
                                               position:ccp(endX, actualY)];
    CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [_monsters removeObject:node];
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
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
        
        // shake

        
//        id particleSystem = [[CCParticleSystemQuad alloc] initWithTotalParticles:30];
//        [particleSystem setEmitterMode: kCCParticleModeGravity];
        
        [self showParticles:location.x y:location.y];
        [self removeChild:monster cleanup:YES];
        _monstersDestroyed++;
        if(_monstersDestroyed > 30) {
            CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
    }
    [monstersToDelete release];
}

-(void) update: (ccTime) dt {
    
}

-(void) showParticles:(float)x y:(float)y {
    self.emitter = [[CCParticleExplosion alloc] init];
    [self.emitter setScaleX:0.5];
    [self.emitter setScaleY:0.5];
    
    [self.emitter resetSystem];
    self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"confetti.png"];
    self.emitter.duration = 0.5;
    //gravity: how fast the particles fall
//    self.emitter.gravity = ccp(x, y);
    
//    self.emitter.angle = 90;
//    self.emitter.angleVar = 360;
    
    self.emitter.speed = 160;
    self.emitter.speedVar = 20;
    
//    self.emitter.radialAccel = -120;
//    self.emitter.radialAccelVar = 120;
    
//    self.emitter.tangentialAccel = 30;
//    self.emitter.tangentialAccelVar = 60;
    
    self.emitter.life = 1;
    self.emitter.lifeVar = 3;
    
//    self.emitter.startSpin = 15;
//    self.emitter.startSpinVar = 5;
//    self.emitter.endSpin = 360;
//    self.emitter.endSpinVar = 180;
    
    // colours
    ccColor4F startColour = { 171.0f, 26.0f, 37.0f, 1.0f };
    self.emitter.startColor = startColour;
    ccColor4F startColourVar = { 245.0f, 255.0f, 72.0f, 1.0f };
    self.emitter.startColorVar = startColourVar;
    ccColor4F endColour = { 255.0f, 223.0f, 85.0f, 1.0f };
    self.emitter.endColor = endColour;
    ccColor4F endColourVar = { 255.0f, 131.0f, 62.0f, 1.0f };
    self.emitter.endColorVar = endColourVar;
    
    // size
    self.emitter.startSize = 10.0f;
    self.emitter.startSizeVar = 20.0f;
    self.emitter.endSize = kParticleStartSizeEqualToEndSize;
    
    // rate of new particles
    self.emitter.totalParticles = 150;
    self.emitter.emissionRate = self.emitter.totalParticles / self.emitter.life;
    
    // startPos
    self.emitter.position = ccp(x,y);
    self.emitter.posVar = ccp(3, 3);
    
    // blend the background
    self.emitter.blendAdditive = YES;
    
    [self addChild: self.emitter z:10];
    self.emitter.autoRemoveOnFinish = YES;
    
    // call function once particlesystem has completed
//    [self scheduleOnce:@selector(removeEnemy) delay:3];
    
}

-(void) shakeScreen {
    CCShaky3D *shake = [CCShaky3D actionWithRange:5 shakeZ:NO grid:ccg(1,1) duration:0.5];
    [self.parent runAction:shake];
}

@end
