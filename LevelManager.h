//
//  LevelManager.h
//  Splat
//
//  Created by James Tease on 03/11/2013.
//
//

#import <Foundation/Foundation.h>
#import "Level.h"

@interface LevelManager : NSObject

+(LevelManager *) sharedInstance;
-(Level *) curLevel;
-(void) nextLevel;
-(void) reset;

@end
