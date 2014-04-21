//
//  PPCConfiguration_ViewController.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ConfigurationProtocol <NSObject>
    -(void)logout;
@end
@interface PPCConfiguration_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *dismiss_button;
- (IBAction)logoutButton:(id)sender;
@property (weak, nonatomic) id<ConfigurationProtocol> delegate;
@end
