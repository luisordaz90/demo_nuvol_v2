//
//  PPCVacation_View.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
@protocol VacationProtocol <NSObject>
-(void)requestAssitanceView: (NSMutableArray *) types andIndexes: (NSMutableArray *) index_number;
@end
@interface PPCVacation_View : UIViewController <UITableViewDelegate, UITableViewDataSource,V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *vacationTable;
- (IBAction)addLayOffRequest:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;
@property (nonatomic, strong) V8HorizontalPickerView *pickerView;
@property (nonatomic, retain) UIPickerView *languageSelect;
@property (nonatomic, retain)  NSMutableArray *pickerData;
@property (weak, nonatomic) id<VacationProtocol> delegate;


@end
