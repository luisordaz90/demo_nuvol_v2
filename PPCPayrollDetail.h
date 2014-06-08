//
//  PPCPayrollDetail.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 6/2/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCPayrollDetailCell.h"
#import "iOSRequest.h"
#import "PPCCommon_Methods.h"

@protocol PayrollDetailProtocol <NSObject>
    -(void)returnToPayroll;
@end
@interface PPCPayrollDetail : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) NSString *period;
@property (weak, nonatomic) IBOutlet UITableView *payrollDetailTable;
@property (weak, nonatomic) id<PayrollDetailProtocol> delegate;
@end
