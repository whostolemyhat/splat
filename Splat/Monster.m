//
//  Monster.m
//  Splat
//
//  Created by James Tease on 27/10/2013.
//
//

#import "Monster.h"

@implementation Monster

-(CGRect) rect {
    CGSize size = [self.texture contentSize];
    return CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
}

-(BOOL) containsTouchLocation:(UITouch *)touch {
    return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpaceAR:touch]);
}

//-(void) onEnter {
//    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
//                                                     priority:0 swallowsTouches:YES];
//    [super onEnter];
//}
//
//-(void) onExit {
//    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
//    [super onExit];
//}
//
//-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    if(![self containsTouchLocation:touch]) {
//        return NO;
//    }
//    CCLOG(@"Touched!");
//    // somme sort of explosion
//    return YES;
//}
//
//-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
//    CCLOG(@"Touch moved");
//}
//
//-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
//    CCLOG(@"Touch end");
//}

@end
