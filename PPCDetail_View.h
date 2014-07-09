//
//  PPCDetail_View.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 4/14/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCCommon_Methods.h"

@protocol DetailProtocol <NSObject>
    -(void)backToDirectory;
@end
@interface PPCDetail_View : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) NSDictionary *personDetails;
@property (strong,nonatomic) UIView *loading;
@property (weak, nonatomic) IBOutlet UIImageView *personImage;
@property (weak, nonatomic) IBOutlet UITextView *personName;
@property (weak, nonatomic) IBOutlet UITextView *email;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumber;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) id<DetailProtocol> delegate;
- (IBAction)backToDirectory:(id)sender;

@end
