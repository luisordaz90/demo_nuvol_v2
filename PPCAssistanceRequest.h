//
//  PPCAssistanceRequest.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 4/4/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"

@protocol AssistanceProtocol <NSObject>
    -(void)clickedButtonAssistance;
    -(void)returnToVacation;
@end
@interface PPCAssistanceRequest : UIViewController <V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) id<AssistanceProtocol> delegate;
@property (strong,nonatomic) NSMutableArray *types_titles;
@property (strong,nonatomic) NSMutableArray *indexes;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) V8HorizontalPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *initialDateField;
@property (weak, nonatomic) IBOutlet UITextField *finalDateField;

@property (weak, nonatomic) IBOutlet UIView *principalView;
- (IBAction)returnView:(id)sender;
- (IBAction)initialDate:(id)sender;
- (IBAction)finalDate:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
- (IBAction)dismissFirstResponder:(id)sender;

@end
