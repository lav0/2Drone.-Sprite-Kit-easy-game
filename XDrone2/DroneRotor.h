//
//  DroneRotor.h
//  XDrone2
//
//  Created by Andrey on 03.10.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DroneRotor : SKSpriteNode

@property (nonatomic) CGFloat power;

-(void)on;
-(void)off;
-(void)update:(NSTimeInterval)interval;

@end
