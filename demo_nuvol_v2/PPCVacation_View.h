//
//  PPCVacation_View.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "PPCCommon_Methods.h"
#import "PPCVacationCell.h"
#import "PPCAssistanceRequest.h"

@protocol VacationProtocol <NSObject>
    -(void)openMenu: (UIViewController *) view;
@end

@interface PPCVacation_View : UIViewController <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *vacationTable;
- (IBAction)addLayOffRequest:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic, strong) V8HorizontalPickerView *pickerView;
@property (strong,nonatomic) PPCAssistanceRequest *assistanceView;
@property (nonatomic, retain) UIPickerView *languageSelect;
@property (nonatomic, retain)  NSMutableArray *pickerData;
@property (weak, nonatomic) id<VacationProtocol> delegate;


@end
