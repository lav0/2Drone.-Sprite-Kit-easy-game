//
//  MainScene.h
//  XDrone2
//
//  Created by Andrey on 29.09.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol SceneDelegate <NSObject>
- (void) eventWasted;
@end

@interface MainScene : SKScene<SKPhysicsContactDelegate>

@property (unsafe_unretained, nonatomic) id<SceneDelegate> viewControllerDelegate;

@end
