//
//  PPCLogin_ViewController.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCCommon_Methods.h"

@protocol LoginProtocol <NSObject>
    -(void)dismissedSubviewLogin;
@end
@interface PPCLogin_ViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (nonatomic, weak) id<LoginProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUser;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPassword;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *loginFields;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
- (IBAction)resignResponders:(id)sender;
- (IBAction)buttonPressed;
@end
