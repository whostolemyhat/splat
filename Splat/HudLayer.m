//
//  HudLayer.m
//  Splat
//
//  Created by James Tease on 18/11/2013.
//
//

#import "cocos2d.h"
#import "HudLayer.h"

@implementation HudLayer

-(id) init {
    if((self = [super init])) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Score" fontName:@"Arial" fontSize:16];
        CGSize size = [CCDirector sharedDirector].winSize;
        label.position = ccp(size.width/2, size.height/2);
        [self addChild:label z: 1];
    }
    return self;
}

-(void) showRestartMenu:(BOOL)won withMessage:(NSString *)message {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
//    NSString *message;
//    if(won) {
//        message = @"You win!";
//    } else {
//        message = @"You lose!";
//    }
    
//    CCLabelBMFont *label;
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
//    } else {
//        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
//    }
    CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:16];
    label.scale = 0.1;
    label.position = ccp(winSize.width / 2, winSize.height * 0.6);
    [self addChild:label];
    
//    CCLabelBMFont *restartLabel;
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];
//    } else {
//        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];
//    }
    
    CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"Restart" fontName:@"Arial" fontSize:16];
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width / 2, winSize.height * 0.4);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:10];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
}

@end
