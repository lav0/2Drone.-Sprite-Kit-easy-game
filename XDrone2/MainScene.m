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
@property (strong, nonatomic, nonnull) SKCameraNode * game_camera;

@end

@implementation MainScene
{
    SKShapeNode * boundaries;
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
        _body.physicsBody.categoryBitMask = bodyBitMask;
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
        _girder.physicsBody.contactTestBitMask = rotorBitMask;
        _girder.xScale = 3;
        _girder.yScale = 0.5;
        _girder.position = CGPointMake(100, 100);
    }
    return _girder;
}
-(SKCameraNode*)game_camera
{
    if (!_game_camera)
    {
        _game_camera = [[SKCameraNode alloc] init];
    }
    return _game_camera;
}

-(id)initWithSize:(CGSize)size
{
    CGSize big_size = CGSizeMake(2*size.width, 2*size.height);
    if (self = [super initWithSize:big_size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.backgroundColor = [UIColor grayColor];
        self.camera = self.game_camera;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = grndBitMask;
        self.physicsBody.contactTestBitMask = rotorBitMask;
        ready_to_play = NO;
        [self startGame];
    }
    return self;
}

-(void)startGame
{
    [self createBoundaries];
    [self createObstacles];
    [self createRotors];
    [self createBodyAndJoints];
    [self addChild:self.game_camera];
    
    self.camera.xScale = 1 / 2;
    self.camera.yScale = 1 / 2;
}

-(void)createBoundaries
{
    boundaries = [SKShapeNode shapeNodeWithRect:self.frame];
    [boundaries setStrokeColor:[UIColor redColor]];
    [self addChild:boundaries];
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

-(NSArray*)sidesTouched:(NSSet<UITouch*>*)touches
{
    BOOL left_side_pressed = NO;
    BOOL right_side_pressed = NO;
    
    for (UITouch * touch in touches)
    {
        NSLog(@"Touches : %lu", (unsigned long)touches.count);
        CGFloat x = [touch locationInNode:self].x;
        if (x > 20)
        {
            right_side_pressed = YES;
        }
        else if (x < -20)
        {
            left_side_pressed = YES;
        }
        
    }
    return @[[NSNumber numberWithBool:left_side_pressed], [NSNumber numberWithBool:right_side_pressed]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray * sides_touched = [self sidesTouched:touches];
    BOOL left = [[sides_touched objectAtIndex:0] boolValue];
    BOOL right = [[sides_touched objectAtIndex:1] boolValue];
    
    if (left)
        [self.rotor_0 on];
    
    if (right)
        [self.rotor_1 on];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray * sides_touched = [self sidesTouched:touches];
    BOOL left = [[sides_touched objectAtIndex:0] boolValue];
    BOOL right = [[sides_touched objectAtIndex:1] boolValue];
    
    if (left)
        [self.rotor_0 off];
    
    if (right)
        [self.rotor_1 off];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray * sides_touched = [self sidesTouched:touches];
    BOOL left = [[sides_touched objectAtIndex:0] boolValue];
    BOOL right = [[sides_touched objectAtIndex:1] boolValue];
    
    if (left)
        [self.rotor_0 off];
    
    if (right)
        [self.rotor_1 off];
}

-(void)update:(NSTimeInterval)currentTime
{
    if (!ready_to_play)
        return;
    
    [self.rotor_0 update:currentTime];
    [self.rotor_1 update:currentTime];
    if (self.camera.xScale < 1) {
        self.camera.xScale += 0.01;
        self.camera.yScale += 0.01;
    }
}

-(void)didSimulatePhysics
{
    if (!ready_to_play)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -5.0);
        ready_to_play = YES;
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contacted");
    id bodyA = contact.bodyA.node;
    id bodyB = contact.bodyB.node;
    if (self.rotor_0 == bodyA || (id)self.rotor_0 == bodyB)
    {
        [self.rotor_0 removeFromParent];
        NSLog(@"Left rotor hit");
    }
    if (self.rotor_1 == bodyA || self.rotor_1 == bodyB)
    {
        [self.rotor_1 removeFromParent];
        NSLog(@"Right rotor hit");
        if ([self.viewControllerDelegate respondsToSelector:@selector(eventWasted)])
            [self.viewControllerDelegate eventWasted];
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
