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
#import "LevelManager.h"

@implementation GameplayLayer

@synthesize _hud;

NSMutableArray *_monsters;
NSMutableArray *_asteroids;
NSMutableArray *_smallAsteroids;

+(CCScene *)scene {
    CCScene *scene = [CCScene node];
    
    HudLayer *hud = [HudLayer node];
    [scene addChild: hud z: 1];
    
    GameplayLayer *layer = [GameplayLayer node];
    [scene addChild:layer];
    
    return scene;
}

-(id) init {
    CCLOG(@"Here");
    if(self = [super init]) {
        _hud = [[[HudLayer alloc] init] autorelease];
        [self addChild:_hud];
        
        _monsters = [[NSMutableArray alloc] init];
        _asteroids = [[NSMutableArray alloc] init];
        _smallAsteroids = [[NSMutableArray alloc] init];
        [self setIsTouchEnabled:YES];

        [self schedule:@selector(addMonster) interval:[LevelManager sharedInstance].curLevel.secsPerSpawn];
        int asteroidInterval = (arc4random() % 10) + [LevelManager sharedInstance].curLevel.asteroidSpawn;
        [self schedule:@selector(addAsteroid) interval:asteroidInterval];
        _monstersDestroyed = 0;
    }
    
    return self;
}


-(void) addMonster {
    int num = arc4random() % 3;
    for(int i = 0; i < num; i++) {
        Monster *monster = nil;
        if(arc4random() % 2 == 0) {
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
        
        [self addChild:monster z:1];
        
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
            
            // losing
            //        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
            //        [[CCDirector sharedDirector] replaceScene:gameOverScene];
            [_hud showRestartMenu:NO withMessage:@"You lose!"];
            
        }];
        [monster runAction:[CCSequence actions: actionMove, actionMoveDone, nil]];
        
        [_monsters addObject:monster];
    }

}

-(void) addAsteroid {
    LargeAsteroid *asteroid = [[[LargeAsteroid alloc] init] autorelease];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // scale down on phones
        [asteroid setScaleX:winSize.width / 1024.0f];
        [asteroid setScaleY:winSize.height / 768.0f];
    }
    
    int minY = asteroid.contentSize.height / 2;
    int maxY = winSize.height - asteroid.contentSize.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    int startX = 0;
    int endX = 0;
    if(arc4random() % 2 != 1) {
        startX = winSize.width + asteroid.contentSize.width / 2;
        endX = -asteroid.contentSize.width / 2;
        
    } else {
        startX = -asteroid.contentSize.width / 2;
        endX = winSize.width + asteroid.contentSize.width / 2;
    }
    asteroid.position = ccp(startX, actualY);
    
    [self addChild:asteroid z:3];
    
    // speed
    int minDuration = asteroid.minMoveDuration; //8.0;
    int maxDuration = asteroid.maxMoveDuration; //10.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // actions!
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration
                                               position:ccp(endX, actualY)];
    CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [_asteroids removeObject:node];
        
        // losing
        //        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
        //        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }];
    
    // spin asteroid
    int randomSpin = arc4random() % 6;
    CCAction *spin = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:randomSpin angle:360]];
    [asteroid runAction:[CCSequence actions: actionMove, actionMoveDone, nil]];
    [asteroid runAction: spin];
    
    [_asteroids addObject:asteroid];
}

-(void) addAsteroidsAtLocation:(CGPoint)location number:(int)amount {
    for(int i = 0; i <= amount; i++) {
        Asteroid *asteroid = [[[Asteroid alloc] init] autorelease];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            // scale down on phones
            [asteroid setScaleX:winSize.width / 1024.0f];
            [asteroid setScaleY:winSize.height / 768.0f];
        }
        
        int minY = asteroid.contentSize.height / 2;
        int maxY = winSize.height - asteroid.contentSize.height / 2;
        int rangeY = maxY - minY;
        int endX = 0;
        int endY = (arc4random() % rangeY) + minY;
        
        if(arc4random() % 2 != 1) {
            endX = -asteroid.contentSize.width / 2;
        } else {
            endX = winSize.width + asteroid.contentSize.width / 2;
        }
        
        asteroid.position = ccp(location.x, location.y);
        
        // speed
        int minDuration = asteroid.minMoveDuration; //8.0;
        int maxDuration = asteroid.maxMoveDuration; //10.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        // actions!
        CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                   position:ccp(endX, endY)];
        CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [node removeFromParentAndCleanup:YES];
            [_smallAsteroids removeObject:node];
        }];
        
        // spin asteroid
        int randomSpin = arc4random() % 6;
        CCAction *spin = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:randomSpin angle:360]];
        [asteroid runAction:[CCSequence actions: actionMove, actionMoveDone, nil]];
        [asteroid runAction: spin];
        
        
        [_smallAsteroids addObject:asteroid];

        [self addChild:asteroid z:3];
    }
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    BOOL monsterHit = FALSE;
    NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
    NSMutableArray *asteroidsToDelete = [[NSMutableArray alloc] init];
    
    for(Monster *monster in _monsters) {
        if(CGRectContainsPoint(monster.boundingBox, location)) {
            monsterHit = TRUE;
            monster.hp--;
            if(monster.hp <= 0) {
                [monstersToDelete addObject:monster];

            } else {
                monster.color = ccc3(255, 120, 100);
                [self.emitter = [CCParticleFire alloc] init];
                [self.emitter resetSystem];
                self.emitter.position = ccp(monster.boundingBox.size.width * 0.5,
                                            monster.boundingBox.size.height * 0.5);
                self.emitter.positionType = kCCPositionTypeRelative;
                self.emitter.life = 1;
                [monster addChild: self.emitter z:-1];
                self.emitter.autoRemoveOnFinish = YES;
            }
            break;
        }
    }
    
    for(Monster *monster in monstersToDelete) {
        [_monsters removeObject:monster];

        [self showParticles:location.x y:location.y];
        CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [node removeFromParentAndCleanup:YES];
            
            [_monsters removeObject:node];
        }];
        // TODO: random spin angle
        [monster runAction:[CCRotateBy actionWithDuration:0.3 angle:180]];
        [monster runAction:[CCSequence actions:
                            [CCScaleTo actionWithDuration:0.2 scale:0],
                            actionMoveDone, nil]];
//        [self removeChild:monster cleanup:YES];
        _monstersDestroyed++;
        if(_monstersDestroyed > [LevelManager sharedInstance].curLevel.nextLevel) {
//            CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
//            [[CCDirector sharedDirector] replaceScene:gameOverScene];

        }
    }
    [monstersToDelete release];
    
    for(LargeAsteroid *asteroid in _asteroids) {
//        if([asteroid isKindOfClass:[LargeAsteroid class]]) {
//            LargeAsteroid *largeAsteroid = (LargeAsteroid *) asteroid;
            if(CGRectContainsPoint(asteroid.boundingBox, location)) {
                int numberOfAsteroids = (arc4random() % 3) + 1;
                CCLOG(@"%d", numberOfAsteroids);
                [self addAsteroidsAtLocation:location number:numberOfAsteroids];
                [asteroidsToDelete addObject:asteroid];
            }
//        }

        break;
    }
    
    for(Asteroid *asteroid in _smallAsteroids) {
        CGRect asteroidBounds = CGRectMake(
                                    asteroid.boundingBox.origin.x - (asteroid.boundingBox.size.width * 0.25),
                                    asteroid.boundingBox.origin.y - (asteroid.boundingBox.size.height * 0.25),
                                    asteroid.boundingBox.size.width * 2,
                                    asteroid.boundingBox.size.height * 2);
        if(CGRectContainsPoint(asteroidBounds, location)) {
            [asteroidsToDelete addObject:asteroid];
        }
        break;
    }
    
    for(Monster *asteroid in asteroidsToDelete) {
        [_asteroids removeObject:asteroid];
        [_smallAsteroids removeObject:asteroid];
        [self removeChild:asteroid cleanup:YES];
        [self shakeScreen];
    }
    [asteroidsToDelete release];
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
    
    self.emitter.radialAccel = -120;
    self.emitter.radialAccelVar = 120;
    
    self.emitter.tangentialAccel = 30;
    self.emitter.tangentialAccelVar = 60;
    
    self.emitter.life = 1;
    self.emitter.lifeVar = 3;
    
    self.emitter.startSpin = 15;
    self.emitter.startSpinVar = 5;
    self.emitter.endSpin = 360;
    self.emitter.endSpinVar = 180;
    
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
    self.emitter.position = ccp(x + 2, y + 2);
//    self.emitter.posVar = ccp(10, 10);
    
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
