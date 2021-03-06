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
@property (strong, nonatomic) MainScene *main_scene;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
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
    
    skView.multipleTouchEnabled = YES;
    [self.resetButton addTarget:self
                         action:@selector(buttonClick)
               forControlEvents:UIControlEventTouchUpInside];
    
    //self.gameOverView.backgroundColor = [UIColor brownColor];
    [self initMainScene];
}

- (void)initMainScene
{
    MainScene *scene0 = [MainScene sceneWithSize:self.view.bounds.size];
    scene0.scaleMode = SKSceneScaleModeAspectFill;
    scene0.viewControllerDelegate = self;
    
    self.main_scene = scene0;
    [(SKView*)self.view presentScene:self.main_scene];
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

-(void)eventWasted
{
    [self shakeFrame];
}

-(void)buttonClick
{
    [self initMainScene];
}

- (void) shakeFrame
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.view  center].x - 4.0f, [self.view  center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.view  center].x + 4.0f, [self.view  center].y)]];
    [[self.view layer] addAnimation:animation forKey:@"position"];
}

@end
