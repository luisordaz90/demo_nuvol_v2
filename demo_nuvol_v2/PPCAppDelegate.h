//
//  PPCAppDelegate.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCLogin_ViewController.h"
#import "PPCWelcome_View.h"
#import "PPCController_Base.h"

@interface PPCAppDelegate : UIResponder <UIApplicationDelegate,LoginProtocol,RootProtocol>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *tabController;
@property (strong, nonatomic) PPCLogin_ViewController *logController;
@property (strong,nonatomic) PPCController_Base *baseController;


@end
