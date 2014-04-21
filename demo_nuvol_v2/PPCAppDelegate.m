//
//  PPCAppDelegate.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCAppDelegate.h"

@implementation PPCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.logController = [[PPCLogin_ViewController alloc] initWithNibName:@"PPCLogin_ViewController" bundle:nil];
    self.window.rootViewController = self.logController;
    self.window.backgroundColor = [UIColor whiteColor];
    self.logController.delegate = self;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //self.welcomeController = [[PPCWelcome_ViewController alloc] initWithNibName:@"Welcome_View" bundle:nil];
    //self.pruebaMenu = [[PPCViewController_PruebaMenu alloc] initWithNibName:@"PPCViewController_PruebaMenu" bundle:nil];
    //self.confController.delegate = self;

}

-(void)dismissedSubviewLogin
{
    [self.logController.view removeFromSuperview];
    self.baseController = [[PPCController_Base alloc] initWithNibName:@"PPCController_Base" bundle:nil];
    self.window.rootViewController = self.baseController;
    self.baseController.delegate = self;
    //PRIMERA VERSION:
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    /*self.confController = [[PPCConfiguration_ViewController alloc] initWithNibName:@"Configuration_View" bundle:nil];
    [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    self.window.rootViewController = self.tabController;
    float tabSize = self.tabController.tabBar.frame.size.width / [self.tabController.tabBar.items count];
    float height = self.tabController.tabBar.frame.size.height;
    self.tabController.tabBar.tintColor = [UIColor whiteColor];
    //[[self.tabController.tabBar.items objectAtIndex:4] setTitle:@"HOLA"];
    UITabBarItem *item = [self.tabController.tabBar.items objectAtIndex:4];
    [item setSelectedImage:[[UIImage imageNamed:@"64x49px.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    item.image = [UIImage imageNamed:@"clockicon.png"];
    item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //[self.tabController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    NSLog(@"TABSIZE: %lf %lf", tabSize,height);
    //[tabBarItem setSelectedImage:[UIImage imageNamed:@"64x64dos.png"]];
    NSArray *nuevo = [self.tabController viewControllers];
    //self.window.rootViewController = self.confController;
    //UIViewController *vista_prueba = [nuevo objectAtIndex:4];
    PPCConfiguration_ViewController *vista_prob = [nuevo objectAtIndex:4];
    vista_prob.delegate = self;
    //[vista_prueba setValue:self forKey:@"delegate"];
    //self.confController.delegate = self;*/

}

-(void)logoutMain
{
    NSLog(@"ENTRO");
    self.baseController = nil;
    self.window.rootViewController = self.logController;
    //[self.tabController.view removeFromSuperview];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
