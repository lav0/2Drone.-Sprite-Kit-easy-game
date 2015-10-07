//
//  DroneRotor.h
//  XDrone2
//
//  Created by Andrey on 03.10.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint32_t rotorBitMask = 0x1 << 1;
static const uint32_t bodyBitMask  = 0x1 << 3;
static const uint32_t obstBitMask  = 0x1 << 4;
static const uint32_t grndBitMask  = 0x1 << 5;

@interface DroneRotor : SKSpriteNode

@property (nonatomic) CGFloat power;

-(void)on;
-(void)off;
-(void)update:(NSTimeInterval)interval;

@end
