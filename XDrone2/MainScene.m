//
//  MainScene.m
//  XDrone2
//
//  Created by Andrey on 29.09.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import "DroneRotor.h"
#import "MainScene.h"

#define SCALE_SCENE_FACTOR 0.6

#define ROTOR_DISPLACE_X 40
#define ROTOR_DISPLACE_Y 15

@interface MainScene ()

@property (strong, nonatomic, nonnull) DroneRotor * rotor_0;
@property (strong, nonatomic, nonnull) DroneRotor * rotor_1;
@property (strong, nonatomic, nonnull) SKSpriteNode * body;
@property (strong, nonatomic, nonnull) SKSpriteNode * girder;

@end

@implementation MainScene
{
    BOOL ready_to_play;
}

-(DroneRotor*)rotor_0
{
    if (!_rotor_0)
    {
        _rotor_0 = [DroneRotor new];
    }
    return _rotor_0;
}
-(DroneRotor*)rotor_1
{
    if (!_rotor_1)
    {
        _rotor_1 = [DroneRotor new];
    }
    return _rotor_1;
}
-(SKSpriteNode*)body
{
    if (!_body)
    {
        _body = [SKSpriteNode spriteNodeWithImageNamed:@"sprite1.png"];
        _body.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_body.frame.size center:CGPointZero];
        _body.physicsBody.mass = 3;
    }
    return _body;
}
-(SKSpriteNode*)girder
{
    if (!_girder)
    {
        _girder = [SKSpriteNode spriteNodeWithImageNamed:@"sprite0.png"];
        _girder.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_girder.frame.size center:CGPointZero];
        _girder.physicsBody.dynamic = NO;
        _girder.xScale = 3;
        _girder.yScale = 0.5;
        _girder.position = CGPointMake(100, 100);
    }
    return _girder;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.backgroundColor = [UIColor grayColor];
        ready_to_play = NO;
        [self startGame];
    }
    return self;
}

-(void)startGame
{
    [self createObstacles];
    [self createRotors];
    [self createBodyAndJoints];
}

-(void)createObstacles
{
    [self addChild:self.girder];
}
-(void)createRotors
{
    [self configureRotor:self.rotor_0 ForPosition:CGPointMake(-ROTOR_DISPLACE_X, ROTOR_DISPLACE_Y)];
    [self configureRotor:self.rotor_1 ForPosition:CGPointMake(ROTOR_DISPLACE_X, ROTOR_DISPLACE_Y)];
    [self addChild:self.rotor_0];
    [self addChild:self.rotor_1];
}
-(void)createBodyAndJoints
{
    [self addChild:self.body];
    
    SKPhysicsJoint* joint_0 = [SKPhysicsJointFixed jointWithBodyA:self.rotor_0.physicsBody
                                                            bodyB:self.body.physicsBody
                                                           anchor:CGPointZero];
    SKPhysicsJoint* joint_1 = [SKPhysicsJointFixed jointWithBodyA:self.rotor_1.physicsBody
                                                            bodyB:self.body.physicsBody
                                                           anchor:CGPointZero];
    [self.physicsWorld addJoint:joint_0];
    [self.physicsWorld addJoint:joint_1];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"rotor1 size: (%f, %f)", self.rotor_1.frame.size.width, self.rotor_1.frame.size.height);
    NSLog(@"rotor0 size: (%f, %f)", self.rotor_0.frame.size.width, self.rotor_0.frame.size.height);
    
    NSLog(@"rotor1: (%f, %f)", self.rotor_1.frame.origin.x, self.rotor_1.frame.origin.y);
    NSLog(@"rotor0: (%f, %f)", self.rotor_0.frame.origin.x, self.rotor_0.frame.origin.y);
    NSLog(@"body: (%f, %f)", self.body.frame.origin.x, self.body.frame.origin.y);
    [self.rotor_0 on];
    [self.rotor_1 on];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.rotor_0 off];
    [self.rotor_1 off];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.rotor_0 off];
    [self.rotor_1 off];
}

-(void)update:(NSTimeInterval)currentTime
{
    if (!ready_to_play)
        return;
    
    [self.rotor_0 update:currentTime];
    [self.rotor_1 update:currentTime];
}

-(void)didSimulatePhysics
{
    if (!ready_to_play)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -5.0);
        ready_to_play = YES;
    }
}


#pragma mark - aux functions

-(void)configureRotor:(DroneRotor*)rotor ForPosition:(CGPoint)position
{
    rotor.xScale = SCALE_SCENE_FACTOR;
    rotor.yScale = 0.75 * SCALE_SCENE_FACTOR;
    rotor.position = position;
}

@end
