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
    NSLog(@"ENTRO A DID LOAD BASE");
    // Do any additional setup after loading the view from its nib.
    MSMenuView *menu = [[MSMenuView alloc] initWithFrame:CGRectMake(0,492,0,0)];
    [menu setDelegate:self];
    [self.view addSubview:menu];
    self.welcomeView = [[PPCWelcome_ViewController alloc] initWithNibName:@"Welcome_View" bundle:nil];
    self.welcomeView.delegate = self;
    self.confView = [[PPCConfiguration_ViewController alloc] initWithNibName:@"Configuration_View" bundle:nil];
    self.confView.delegate = self;
    self.vacationView = [[PPCVacation_View alloc] initWithNibName:@"PPCVacation_View" bundle:nil];
    self.vacationView.delegate = self;
    self.directoryView = [[PPCDirectory_View alloc] initWithNibName:@"PPCDirectory_View" bundle:nil];
    self.directoryView.delegate = self;
    self.notificationView = [[PPCNotification_View alloc] initWithNibName:@"PPCNotification_View" bundle:nil];
    self.notificationView.delegate = self;
    self.welcomeView.view.frame = CGRectMake(0, 0, 320, 492); //492
    self.confView.view.frame = CGRectMake(0, 0, 320, 492);
    self.vacationView.view.frame = CGRectMake(0, 0, 320, 492);
    self.directoryView.view.frame = CGRectMake(0, 0, 320, 492);
    self.notificationView.view.frame = CGRectMake(0, 0, 320, 492);
    [self.view addSubview:self.welcomeView.view];
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
    if(!condition){
        [self.view addSubview:self.welcomeView.view];
    }
    else{
        [self.view addSubview:self.notificationView.view];
    }
}
-(void)vacationTabClick{
    if(!condition_vacation)
        [self.view addSubview:self.vacationView.view];
    else
        [self.view addSubview:self.assistanceView.view];
}
-(void)infoCenterTabClick{
    [self.view addSubview:self.payRollView.view];
}
-(void)preferencesTabClick{
    [self.view addSubview:self.confView.view];
}
-(void)directoryTabClick{
    if(!condition_detail)
        [self.view addSubview:self.directoryView.view];
    else
        [self.view addSubview:self.detailView.view];
}

-(void)addNotificationView: (NSMutableArray *) notifications{
    [self.welcomeView.view removeFromSuperview];
    self.notificationView.notifications = [notifications mutableCopy];
    condition = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self.view addSubview:self.notificationView.view];
    [UIView commitAnimations];
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

@end
