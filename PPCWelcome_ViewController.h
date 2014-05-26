//
//  PPCWelcome_ViewController.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCCustom_Cell_Welcome.h"

@protocol WelcomeProtocol <NSObject>
    -(void)addNotificationView: (NSMutableArray *) notifications;
@end
@interface PPCWelcome_ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WelcomeCellProtocol>
@property (strong,nonatomic) NSMutableArray *arrayNotifications;
@property (weak, nonatomic) IBOutlet UITableView *tableVista;
@property (weak, nonatomic) id<WelcomeProtocol> delegate;
-(void)dismissVariables;

@end
