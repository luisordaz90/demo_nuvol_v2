//
//  PPCCell_Directory.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/5/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCCell_Directory : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameCard;
@property (weak, nonatomic) IBOutlet UILabel *jobPosition;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UITextView *email2;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumber2;

@property (weak, nonatomic) IBOutlet UITextView *nameCard2;
@property (weak, nonatomic) IBOutlet UITextView *jobPosition2;

@end
