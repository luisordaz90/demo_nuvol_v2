//
//  PPCWelcome_ViewController.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCWelcomeCell.h"
#import "iOSRequest.h"
#import "PPCCommon_Methods.h"
#import "PPCNotification_View.h"

@protocol WelcomeProtocol <NSObject>
    -(void)openMenu: (UIViewController *) view;
@end

@interface PPCWelcome_View : UIViewController <UITableViewDelegate, UITableViewDataSource, WelcomeCellProtocol,UINavigationControllerDelegate, UIScrollViewDelegate>
@property (strong,nonatomic) NSMutableArray *arrayNotifications;
@property (weak, nonatomic) IBOutlet UITableView *welcomeTable;

@property (strong,nonatomic) PPCNotification_View *notificationView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) id<WelcomeProtocol> delegate;
-(void)dismissVariables;

@end
