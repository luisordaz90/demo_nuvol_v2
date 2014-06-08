//
//  PPCPayrollCell.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 5/30/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCPayrollCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *dateTextView;
@property (weak, nonatomic) IBOutlet UITextView *earningTextView;
@property (weak, nonatomic) IBOutlet UITextView *deductionTextView;
@property (weak, nonatomic) IBOutlet UITextView *totalTextView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
