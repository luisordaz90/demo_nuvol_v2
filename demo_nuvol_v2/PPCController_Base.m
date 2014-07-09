//
//  PPCController_Base.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/23/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PPCController_Base.h"

@interface PPCController_Base ()

@end

NSInteger condition = 0;
NSInteger condition_vacation = 0;
NSInteger condition_detail = 0;
NSInteger condition_payroll_detail = 0;
UINavigationController *navControllerWelcome, *navControllerAttendance, *navControllerDirectory, *navControllerPayroll, *navControllerConfiguration;
UIViewController *viewAux;

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
#define CORNER_RADIUS 4

@implementation PPCController_Base

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.welcomeView = [[PPCWelcome_View alloc] initWithNibName:@"Welcome_View" bundle:nil];
    //self.welcomeView.view.frame = CGRectMake(0, 20, 320, 548);
    self.welcomeView.delegate = self;
    navControllerWelcome = [[UINavigationController alloc] initWithRootViewController:self.welcomeView];
    navControllerWelcome.view.frame = CGRectMake(0, 20, 320, 548);
    [self.view addSubview: navControllerWelcome.view];
    [self addChildViewController:navControllerWelcome];
    [navControllerWelcome didMoveToParentViewController:self];
    navControllerWelcome.view.tag = 0;
    //navControllerWelcome.navigationBar.tintColor = [PPCCommon_Methods colorFromHexString:@"#000000" andAlpha:NO];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)removeSubviews{
    NSArray *arreglo = [self.view subviews];
    int i;
    for(i = 0; i < [arreglo count]; i++){
        if([[arreglo objectAtIndex:i] tag] != 1000)
            [[arreglo objectAtIndex:i] removeFromSuperview];
    }
}

-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset withView: (UIView *)view{
	if (value) {
		[view.layer setCornerRadius:CORNER_RADIUS];
		[view.layer setShadowColor:[UIColor blackColor].CGColor];
		[view.layer setShadowOpacity:0.8];
		[view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
	} else {
		[view.layer setCornerRadius:0.0f];
		[view.layer setShadowOffset:CGSizeMake(offset, offset)];
	}
}

-(void)logout{
    [self removeSubviews];
    if([self.delegate respondsToSelector:@selector(logoutMain)])
    {
        [self.delegate logoutMain];
    }
}

-(void)configurationTabClick{
    [self removeSubviews];
    if(self.confView == nil){
        self.confView = [[PPCConfiguration_View alloc] initWithNibName:@"Configuration_View" bundle:nil];
        self.confView.view.frame = CGRectMake(0, 0, 320, 492);
        self.confView.delegate = self;
        self.confView.view.tag = 4;
        [self addChildViewController:self.confView];
    }
    [self.view addSubview:self.confView.view];
}

-(void)openMenu:(UIViewController *)viewControl{
    UIView *centerView = [[UIView alloc] init];
    centerView = viewControl.view;
    UIView *childView = [self getMenuView];
    if(!self.mainMenu.showing){
        [self.view addSubview:self.mainMenu.view];
        [self.view sendSubviewToBack:childView];
        //[self showCenterViewWithShadow:YES withOffset:-2 withView:viewControl.view];
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            centerView.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 20, self.view.frame.size.width, self.view.frame.size.height);
            [viewControl resignFirstResponder];
        }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.mainMenu.showing = YES;
                         }
                     }];
    }
    else{
        //[self showCenterViewWithShadow:NO withOffset:0 withView: viewControl.view];
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            centerView.frame = CGRectMake(0,20, self.view.frame.size.width, self.view.frame.size.height);
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [childView removeFromSuperview];
                                 self.mainMenu.showing = NO;
                             }
                         }];
    }
}

-(UIView *)getMenuView {
    if (self.mainMenu == nil)
    {
        self.mainMenu = [[PPCMainMenu alloc] initWithNibName:@"PPCMainMenu" bundle:nil];
        self.mainMenu.view.tag = 1000;
        [self addChildViewController:self.mainMenu];
        [self.mainMenu didMoveToParentViewController:self];
        self.mainMenu.view.frame = CGRectMake(0, 0, 260, self.view.frame.size.height);
        self.mainMenu.delegate = self;
    }
    UIView *view = self.mainMenu.view;
    return view;
}

-(void)addChildViewController:(UIViewController *)childController{
    if(childController.view.tag != 1000 && viewAux != childController){
        if(viewAux == nil){
            viewAux = childController;
        }
        else{
            [viewAux removeFromParentViewController];
            [viewAux.view removeFromSuperview];
            viewAux = childController;
        }
    }
}

-(void)setNewCentralPane: (NSInteger) panel{
    switch (panel) {
        case 0:
            [self addChildViewController:navControllerWelcome];
            [navControllerWelcome didMoveToParentViewController:self];
            navControllerWelcome.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:navControllerWelcome.view];
            [self openMenu:navControllerWelcome];
            break;
        case 1:
            if(self.vacationView == nil){
                self.vacationView = [[PPCVacation_View alloc] initWithNibName:@"PPCVacation_View" bundle:nil];
                self.vacationView.view.frame = CGRectMake(0, 44, 320, 504);
                self.vacationView.delegate = self;
                self.vacationView.view.tag = 1;
                navControllerAttendance = [[UINavigationController alloc] initWithRootViewController:self.vacationView];
            }
            [self addChildViewController:navControllerAttendance];
            [navControllerAttendance didMoveToParentViewController:self];
            navControllerAttendance.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview: navControllerAttendance.view];
            [self openMenu:navControllerAttendance];
            break;
        case 2:
            if(self.directoryView == nil){
                self.directoryView = [[PPCDirectory_View alloc] initWithNibName:@"PPCDirectory_View" bundle:nil];
                self.directoryView.view.frame = CGRectMake(0, 44, 320, 504);
                self.directoryView.delegate = self;
                self.directoryView.view.tag = 2;
                navControllerDirectory = [[UINavigationController alloc] initWithRootViewController:self.directoryView];
            }
            [self addChildViewController:navControllerDirectory];
            [navControllerDirectory didMoveToParentViewController:self];
            navControllerDirectory.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview: navControllerDirectory.view];
            [self openMenu:navControllerDirectory];
            break;
        case 3:
            if(self.payRollView == nil){
                self.payRollView = [[PPCPayRoll_View alloc] initWithNibName:@"PPCPayRoll_View" bundle:nil];
                self.payRollView.view.frame = CGRectMake(0, 44, 320, 504);
                self.payRollView.delegate = self;
                self.payRollView.view.tag = 3;
                navControllerPayroll = [[UINavigationController alloc] initWithRootViewController:self.payRollView];
            }
            [self addChildViewController:navControllerPayroll];
            [navControllerPayroll didMoveToParentViewController:self];
            navControllerPayroll.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview: navControllerPayroll.view];
            [self openMenu:navControllerPayroll];
            break;
        case 4:
            if(self.confView == nil){
                self.confView = [[PPCConfiguration_View alloc] initWithNibName:@"Configuration_View" bundle:nil];
                self.confView.view.frame = CGRectMake(0, 44, 320, 504);
                self.confView.delegate = self;
                self.confView.view.tag = 4;
                navControllerConfiguration = [[UINavigationController alloc] initWithRootViewController:self.confView];
            }
            [self addChildViewController:self.confView];
            navControllerConfiguration.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview: navControllerConfiguration.view];
            [self openMenu:navControllerConfiguration];            ;
            break;

    }
}
@end
