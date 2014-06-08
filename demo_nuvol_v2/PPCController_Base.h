//
//  PPCController_Base.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/23/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMenuView.h"
#import "PPCWelcome_View.h"
#import "PPCConfiguration_View.h"
#import "PPCVacation_View.h"
#import "PPCPayRoll_View.h"
#import "PPCDirectory_View.h"
#import "PPCNotification_View.h"
#import "PPCAssistanceRequest.h"
#import "PPCDetail_View.h"
#import "PPCPayrollDetail.h"

@protocol RootProtocol <NSObject>
    -(void)logoutMain;
@end
@interface PPCController_Base : UIViewController <MSMenuViewDelegate,ConfigurationProtocol, WelcomeProtocol, NotificationProtocol, VacationProtocol, AssistanceProtocol,DirectoryProtocol,DetailProtocol, PayrollProtocol,PayrollDetailProtocol>
@property (strong,nonatomic) PPCWelcome_View *welcomeView;
@property (strong,nonatomic) PPCConfiguration_View *confView;
@property (strong,nonatomic) PPCVacation_View *vacationView;
@property (strong, nonatomic) PPCPayRoll_View *payRollView;
@property (strong,nonatomic) PPCDirectory_View *directoryView;
@property (strong,nonatomic) PPCNotification_View *notificationView;
@property (strong,nonatomic) PPCAssistanceRequest *assistanceView;
@property (strong,nonatomic) PPCDetail_View *detailView;
@property (strong,nonatomic) PPCPayrollDetail *payrollDetailView;
@property (weak, nonatomic) id<RootProtocol> delegate;

@end
