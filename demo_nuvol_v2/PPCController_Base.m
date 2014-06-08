//
//  PPCController_Base.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/23/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCController_Base.h"

@interface PPCController_Base ()

@end

NSInteger condition = 0;
NSInteger condition_vacation = 0;
NSInteger condition_detail = 0;
NSInteger condition_payroll_detail = 0;
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
    MSMenuView *menu = [[MSMenuView alloc] initWithFrame:CGRectMake(0,492,0,0)];
    [menu setDelegate:self];
    menu.tag = 1000;
    [self.view addSubview:menu];
    self.welcomeView = [[PPCWelcome_View alloc] initWithNibName:@"Welcome_View" bundle:nil];
    self.welcomeView.delegate = self;
    self.welcomeView.view.tag = 0;
    self.confView = [[PPCConfiguration_View alloc] initWithNibName:@"Configuration_View" bundle:nil];
    self.confView.delegate = self;
    self.confView.view.tag = 4;
    self.vacationView = [[PPCVacation_View alloc] initWithNibName:@"PPCVacation_View" bundle:nil];
    self.vacationView.delegate = self;
    self.vacationView.view.tag = 1;
    //self.directoryView = [[PPCDirectory_View alloc] initWithNibName:@"PPCDirectory_View" bundle:nil];
    //self.directoryView.delegate = self;
    self.notificationView = [[PPCNotification_View alloc] initWithNibName:@"PPCNotification_View" bundle:nil];
    self.notificationView.delegate = self;
    self.payRollView = [[PPCPayRoll_View alloc] initWithNibName:@"PPCPayRoll_View" bundle:nil ];
    self.payRollView.delegate = self;
    self.welcomeView.view.frame = CGRectMake(0, 0, 320, 492);
    self.confView.view.frame = CGRectMake(0, 0, 320, 492);
    self.vacationView.view.frame = CGRectMake(0, 0, 320, 492);
    self.directoryView.view.frame = CGRectMake(0, 0, 320, 492);
    self.directoryView.view.tag = 2;
    self.payRollView.view.frame = CGRectMake(0, 0, 320, 492);
    self.payRollView.view.tag = 3;
    self.notificationView.view.frame = CGRectMake(0, 0, 320, 492);
    [self addChildViewController:self.welcomeView];
    [self.view addSubview:self.welcomeView.view];
    [self addChildViewController:self.confView];
    [self addChildViewController:self.vacationView];
    [self addChildViewController:self.payRollView];
    //[self addChildViewController:self.directoryView];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    MSMenuView *menu = [[MSMenuView alloc] initWithFrame:CGRectMake(0,492,0,0)];
    [menu setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout{
    [self.welcomeView.view removeFromSuperview];
    [self.welcomeView dismissVariables];
    [self.notificationView.view removeFromSuperview];
    [self.payRollView.view removeFromSuperview];
    [self.directoryView.view removeFromSuperview];
    [self.vacationView.view removeFromSuperview];
    if([self.delegate respondsToSelector:@selector(logoutMain)])
    {
        [self.delegate logoutMain];
    }
}

-(void)welcomeTabClick{
    [self removeSubviews];
    if(!condition){
        [self.view addSubview:self.welcomeView.view];
    }
    else{
        [self.view addSubview:self.notificationView.view];
    }
}
-(void)vacationTabClick{
    [self removeSubviews];
    if(!condition_vacation)
        [self.view addSubview:self.vacationView.view];
    else
        [self.view addSubview:self.assistanceView.view];
}
-(void)infoCenterTabClick{
    [self removeSubviews];
    if(!condition_payroll_detail)
        [self.view addSubview:self.payRollView.view];
    else
        [self.view addSubview:self.payrollDetailView.view];
}

-(void)preferencesTabClick{
    [self removeSubviews];
    [self.view addSubview:self.confView.view];
}

-(void)directoryTabClick{
    [self removeSubviews];
    if(!condition_detail)
        [self.view addSubview:self.directoryView.view];
    else
        [self.view addSubview:self.detailView.view];
}

-(void)removeSubviews{
    NSArray *arreglo = [self.view subviews];
    int i;
    for(i = 0; i < [arreglo count]; i++){
        if([[arreglo objectAtIndex:i] tag] != 1000)
            [[arreglo objectAtIndex:i] removeFromSuperview];
    }
        //NSLog(@"NUM: %ld",(long)[[arreglo objectAtIndex:i] tag]);
    NSLog(@"CANTIDAD: %lu",[arreglo count]);
}

-(UIView *)getRightView {
    // init view if it doesn't already exist
    if (self.directoryView == nil)
    {
        self.directoryView = [[PPCDirectory_View alloc] initWithNibName:@"PPCDirectory_View" bundle:nil];
        self.directoryView.delegate = self;
        
        [self.view addSubview:self.directoryView.view];
        [self addChildViewController:self.directoryView];
        [self.directoryView didMoveToParentViewController:self];
        
        self.directoryView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    //self.showingRightPanel = YES;
    
    // setup view shadows
    //[self showCenterViewWithShadow:YES withOffset:2];
    
    UIView *view = self.directoryView.view;
    return view;
}

-(void)addNotificationView: (NSMutableArray *) notifications{
    NSLog(@"ENTRO NT");
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.welcomeView.view.frame = CGRectMake(self.view.frame.size.width - 100, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {

                     }];
    /*[self.welcomeView.view removeFromSuperview];
    self.notificationView.notifications = [notifications mutableCopy];
    condition = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self.view addSubview:self.notificationView.view];
    [UIView commitAnimations];*/
}

-(void)requestAssitanceView:(NSMutableArray *)types andIndexes: (NSMutableArray *) indexes{
    [self.vacationView.view removeFromSuperview];
    self.assistanceView = [[PPCAssistanceRequest alloc] initWithNibName:@"PPCAssistanceRequest" bundle:nil];
    self.assistanceView.delegate = self;
    self.assistanceView.view.frame = CGRectMake(0, 0, 320, 492);
    self.assistanceView.types_titles = [types mutableCopy];
    self.assistanceView.indexes = [indexes mutableCopy];
    condition_vacation = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self.view addSubview:self.assistanceView.view];
    [UIView commitAnimations];
}
-(void)requestPersonDetail: (NSDictionary *) personDetails{
    condition_detail = 1;
    [self.directoryView.view removeFromSuperview];
    self.detailView = [[PPCDetail_View alloc] initWithNibName:@"PPCDetail_View" bundle:nil];
    self.detailView.delegate = self;
    self.detailView.view.frame = CGRectMake(0, 0, 320, 492);
    self.detailView.personDetails = personDetails;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self addChildViewController: self.detailView];
    [self.view addSubview:self.detailView.view];
    [UIView commitAnimations];
}

-(void)backToDirectory{
    condition_detail = 0;
    self.detailView = nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self.detailView.view removeFromSuperview];
    [self.view addSubview:self.directoryView.view];
    [UIView commitAnimations];
}

-(void)clickedButtonAssistance{
    condition_vacation = 0;
    self.assistanceView = nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    
    [self.view addSubview:self.vacationView.view];
    [UIView commitAnimations];
}

-(void)returnToVacation{
    condition_vacation = 0;
    self.assistanceView = nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self.view addSubview:self.vacationView.view];
    [UIView commitAnimations];
}

-(void)clickedButton{
    condition = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self.notificationView.view removeFromSuperview];
    [self.view addSubview:self.welcomeView.view];
    [UIView commitAnimations];
}

-(void)updateMessages:(NSMutableArray *)notifications{
    self.welcomeView.arrayNotifications = [notifications mutableCopy];
}

-(void)requestPayrollDetail:(NSString *)receipt{
    condition_payroll_detail = 1;
    [self.payrollDetailView.view removeFromSuperview];
    self.payrollDetailView = [[PPCPayrollDetail alloc] initWithNibName:@"PPCPayrollDetail" bundle:nil];
    self.payrollDetailView.delegate = self;
    self.payrollDetailView.view.frame = CGRectMake(0, 0, 320, 492);
    self.payrollDetailView.period = receipt;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self.view addSubview:self.payrollDetailView.view];
    [UIView commitAnimations];
}



@end
