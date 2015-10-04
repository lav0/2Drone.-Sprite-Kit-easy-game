//
//  GameViewController.m
//  XDrone2
//
//  Created by Andrey on 28.09.15.
//  Copyright (c) 2015 Andrey. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MainScene.h"

@interface GameViewController ()
@property (strong, nonatomic) GameScene *main_scene;
@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    
    // Block for unarchiving from previously saved file
    /*
    NSString *saved_path = [[self applicationDocumentsPath]
                            stringByAppendingPathComponent:@"SceneSaved.sks"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:saved_path]) {
        nodePath = saved_path;
    }
    */
    
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

+ (void)archiveToFile:(SKScene*)scene
{
    NSString *path = [[self applicationDocumentsPath] stringByAppendingPathComponent:@"SceneSaved.sks"];
    
    BOOL saved = [NSKeyedArchiver archiveRootObject:scene toFile:path];
    
    if (saved) {
        NSLog(@"File saved");
        NSLog(path);
    }
}

+(NSString *) applicationDocumentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    MainScene *scene0 = [MainScene sceneWithSize:skView.bounds.size];
    scene0.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene0];
    
    self.main_scene = scene;
}

- (void)viewWillDisappear:(BOOL)animated
{
    /*
    NSArray * nodes = [self.main_scene children];
    SKLabelNode *label = [nodes objectAtIndex:0];
    for (SKNode *node in nodes)
    {
        if ([node.name  isEqual:@"label"]) {
            label = (SKLabelNode*)node;
            break;
        }
    }
    label.text = @"Buy buy";
    [GameScene archiveToFile:self.main_scene];
     */
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
