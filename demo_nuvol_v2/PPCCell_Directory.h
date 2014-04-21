//
//  PPCCell_Directory.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/5/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCCell_Directory : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UITextView *cardName;
@property (weak, nonatomic) IBOutlet UITextView *jobPosition;

@end
