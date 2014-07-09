//
//  PPCViewController_PruebaMenu.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/23/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMenuView.h"
#import "PPCWelcome_ViewController.h"
#import "PPCConfiguration_ViewController.h"
@protocol RootProtocol <NSObject>
    -(void)logoutMain;
@end

@interface PPCViewController_PruebaMenu : UIViewController <MSMenuViewDelegate,ConfigurationProtocol>
@property (strong,nonatomic) PPCWelcome_ViewController *welcomeView;
@property (strong,nonatomic) PPCConfiguration_ViewController *confView;
@property (weak, nonatomic) id<RootProtocol> delegate;


@end
