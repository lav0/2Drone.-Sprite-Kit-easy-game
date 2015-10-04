//
//  DroneRotor.m
//  XDrone2
//
//  Created by Andrey on 03.10.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import "DroneRotor.h"

#define MAGIC_NUM 150

@implementation DroneRotor
{
    BOOL forced;
    bool l;
    SKAction * animation;
}

-(id)init
{
    if (self = [super init])
    {
        SKTexture *txure0 = [SKTexture textureWithImageNamed:@"sprite0.png"];
        SKTexture *txure1 = [SKTexture textureWithImageNamed:@"sprite1.png"];
        SKTexture *txure2 = [SKTexture textureWithImageNamed:@"sprite3_opacity.png"];
        
        self = [DroneRotor spriteNodeWithTexture:txure0];
        self.position = CGPointMake(0, 0);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];// center:CGPointZero];
        
        animation = [SKAction repeatActionForever:
                            [SKAction animateWithTextures:@[txure0, txure1, txure2] timePerFrame:0.2]
                            ];
        
        forced = NO;
        self.power = 13;
        self.physicsBody.mass = 1;
    }
    return self;
}

-(void)on
{
    forced = YES;
    [self runAction:animation];
}
-(void)off
{
    forced = NO;
    [self removeAllActions];
}

-(CGVector)forceAlongDirection
{
    CGFloat angle = self.zRotation + M_PI_2;
    CGFloat coef = MAGIC_NUM * self.power;
    return CGVectorMake(coef * cos(angle), coef * sin(angle));
}

-(void)update:(NSTimeInterval)interval
{
    if (forced)
    {
        [self.physicsBody applyForce:[self forceAlongDirection]];
    }
}


@end
