//
//  PPCPayRoll_View.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "PPCCommon_Methods.h"
#import "PPCPayrollCell.h"
#import "PPCPayrollDetail.h"

@protocol PayrollProtocol <NSObject>
    -(void)openMenu: (UIViewController *) view;
@end

@interface PPCPayRoll_View : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *payrollTable;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong,nonatomic) PPCPayrollDetail *payrollDetailView;
@property (weak, nonatomic) id<PayrollProtocol> delegate;
@end
