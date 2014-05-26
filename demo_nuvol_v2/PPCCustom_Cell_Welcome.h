//
//  PPCCustom_Cell_Welcome.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/11/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WelcomeCellProtocol <NSObject>
    -(void)clickedCell: (NSIndexPath *) pathToCell;
@end
@interface PPCCustom_Cell_Welcome : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *firstTextView;
@property (weak, nonatomic) IBOutlet UITextView *secondTextView;
@property (weak, nonatomic) IBOutlet UIImageView *custom_imageView;
@property (weak, nonatomic) IBOutlet UITextView *thirdTextView;
@property (nonatomic) BOOL allowed;
- (IBAction)touchedCell:(id)sender;
@property (weak, nonatomic) id<WelcomeCellProtocol> delegate;
@property (weak,nonatomic) NSIndexPath *pathToCell;
@property (weak, nonatomic) IBOutlet UITextView *fourthTextView;

@end
