//
//  PPCVacation_Cell.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/31/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCVacationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *initialDate;
@property (weak, nonatomic) IBOutlet UILabel *finalDate;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UITextView *description;

@end
