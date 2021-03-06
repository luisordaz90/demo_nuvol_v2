//
//  PPCNotification_View.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/19/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "PPCCommon_Methods.h"
#import "PPCNotificationCell.h"
#import "PPCCustom_Cell_Spacer.h"

@protocol NotificationProtocol <NSObject>
    -(void)clickedButton;
    -(void)updateMessages: (NSMutableArray *) notifications;
@end
@interface PPCNotification_View : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
@property (strong,nonatomic) NSMutableArray *notifications;
@property (weak, nonatomic) IBOutlet UITableView *tableViewNot;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) id<NotificationProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIView *mainView;

- (IBAction)goBack:(id)sender;
@end
