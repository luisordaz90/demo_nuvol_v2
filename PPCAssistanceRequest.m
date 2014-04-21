//
//  PPCAssistanceRequest.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 4/4/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCAssistanceRequest.h"
#import "iOSRequest.h"

@interface PPCAssistanceRequest ()

@end
NSDictionary *dictRoot;
UIView *requestDialog;
UIDatePicker *picker;
NSString *selectedIndex;
NSString *plistPath;

@implementation PPCAssistanceRequest

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectedIndex = [_indexes objectAtIndex:0];
    UIButton *dismiss_button = [[UIButton alloc] initWithFrame:CGRectMake(20, 320, 280, 40)];
    [dismiss_button.layer setBorderWidth:0.5];
    [dismiss_button setTitle:@"Confirmar" forState:UIControlStateNormal];
    dismiss_button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];
    [dismiss_button addTarget:self action:@selector(addRequest) forControlEvents:UIControlEventTouchUpInside];
    dismiss_button.backgroundColor = [self colorFromHexString:@"#709D43" andAlpha:NO];
    dismiss_button.layer.borderColor = [[self colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
    [dismiss_button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [dismiss_button setTitleColor:[UIColor grayColor] forState: UIControlStateHighlighted];
    _descriptionText.backgroundColor = [self colorFromHexString:@"#FFFFFF" andAlpha:NO];
    _descriptionText.layer.borderColor = [[self colorFromHexString:@"#CCCCCC" andAlpha:NO] CGColor];
    _descriptionText.layer.borderWidth = 1.0f;
    _descriptionText.autocorrectionType = NO;
    _descriptionText.autocapitalizationType = NO;
    _initialDateField.layer.borderColor = [[self colorFromHexString:@"#CCCCCC" andAlpha:NO] CGColor];
    _initialDateField.layer.borderWidth = 1.0f;
    _finalDateField.layer.borderColor = [[self colorFromHexString:@"#CCCCCC" andAlpha:NO] CGColor];
    _finalDateField.layer.borderWidth = 1.0f;
    [self.principalView addSubview:dismiss_button];
    _backButton.backgroundColor = [self colorFromHexString:@"#709D43" andAlpha:NO];
    _backButton.layer.borderColor = [[self colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
    [_backButton.layer setBorderWidth:1.0f];
    [_backButton setTitle:@"Regresar" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    _backButton.layer.sublayerTransform = CATransform3DMakeTranslation(1, 0, 0);
    [_backButton addTarget:self action:@selector(changeBackground:) forControlEvents:UIControlStateHighlighted];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    if (defaults){
        plistPath = [defaults objectForKey:@"plistPath"];
    }
    dictRoot = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
	_pickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(20, 39, 280, 40)];//(self.view.bounds.size.width - (margin * 2.0f)+20)
	_pickerView.backgroundColor   = [self colorFromHexString:@"#FFFFFF" andAlpha:NO];
    _pickerView.layer.borderColor = [[self colorFromHexString:@"#CCCCCC" andAlpha:NO] CGColor];
    _pickerView.layer.borderWidth = 1.0f;
	_pickerView.selectedTextColor = [UIColor blackColor];
	_pickerView.textColor   = [UIColor grayColor];
	_pickerView.delegate    = self;
	_pickerView.dataSource  = self;
	_pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
	_pickerView.selectionPoint = CGPointMake(60, 0);
	_pickerView.selectionIndicatorView = indicator;
    [self.pickerView scrollToElement:0 animated:NO];
    [self.principalView addSubview:_pickerView];
}

-(void)viewDidAppear:(BOOL)animated{

}

- (UIColor *)colorFromHexString:(NSString *)hexString andAlpha: (BOOL) alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    if(!alpha)
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    else
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:0.9];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissFirstResponder:(id)sender {
    [_descriptionText resignFirstResponder];
}
- (IBAction)returnView:(id)sender {
    if([self.delegate respondsToSelector:@selector(returnToVacation)])
    {
        [self.delegate returnToVacation];
    }
}

- (IBAction)initialDate:(id)sender {
    requestDialog = [[UIView alloc] initWithFrame:CGRectMake(10, 123, 300, 356)];
    requestDialog.backgroundColor = [self colorFromHexString:@"#FFFFFF" andAlpha:YES];
    UIButton *dismiss_button = [[UIButton alloc] initWithFrame:CGRectMake(20, 277, 260, 40)];
    dismiss_button.backgroundColor = [self colorFromHexString:@"#709D43" andAlpha:NO];
    dismiss_button.layer.borderColor = [[self colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
    [dismiss_button.layer setBorderWidth:1.0f];
    [dismiss_button setTitle:@"Confirmar" forState:UIControlStateNormal];
    [dismiss_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismiss_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    dismiss_button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];
    [dismiss_button addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 55, 100, 100)];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker addTarget:self action:@selector(dateChanged:)forControlEvents:UIControlEventValueChanged];
    [requestDialog addSubview:picker];
    [requestDialog addSubview:dismiss_button];
    [self.view addSubview:requestDialog];
}

-(void)dateChanged:(id)sender{
    NSDate *myDate = picker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM Y"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"%@",prettyVersion);
    
}

- (IBAction)finalDate:(id)sender {
    NSLog(@"ENTRO");
    requestDialog = [[UIView alloc] initWithFrame:CGRectMake(10, 123, 300, 356)];
    requestDialog.backgroundColor = [self colorFromHexString:@"#FFFFFF" andAlpha:YES];
    UIButton *dismiss_button = [[UIButton alloc] initWithFrame:CGRectMake(20, 277, 260, 40)];
    dismiss_button.backgroundColor = [self colorFromHexString:@"#709D43" andAlpha:NO];
    dismiss_button.layer.borderColor = [[self colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
    [dismiss_button.layer setBorderWidth:1.0f];
    [dismiss_button setTitle:@"Confirmar" forState:UIControlStateNormal];
    [dismiss_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismiss_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    dismiss_button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];
    [dismiss_button addTarget:self action:@selector(removeFinalView) forControlEvents:UIControlEventTouchUpInside];
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 55, 100, 100)];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker addTarget:self action:@selector(dateChanged:)forControlEvents:UIControlEventValueChanged];
    [requestDialog addSubview:picker];
    [requestDialog addSubview:dismiss_button];
    [self.view addSubview:requestDialog];
}

-(void)addRequest{
    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(20, 134, 280, 326)];
    loading.opaque = NO;
    UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinning.frame = CGRectMake(110, 123, 50, 50);
    spinning.backgroundColor = [self colorFromHexString:@"#000000" andAlpha:YES];
    spinning.layer.cornerRadius = 15;
    [spinning startAnimating];
    [loading addSubview:spinning];
    [self.view addSubview:loading];
    NSDate *current_date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"Y-MM-dd"];
    NSString *curr_date_string = [df stringFromDate:current_date];
    NSString *initial_date = [_initialDateField.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *final_date = [_finalDateField.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *params = @"descripcion=";
    params = [params stringByAppendingString:[_descriptionText.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    params = [params stringByAppendingString:@"&fecha_inicial="];
    params = [params stringByAppendingString:initial_date];
    params = [params stringByAppendingString:@"&fecha_final="];
    params = [params stringByAppendingString:final_date];
    params = [params stringByAppendingString:@"&id=0"];
    params = [params stringByAppendingString:@"&id_asistencia_registro_tipo="];
    params = [params stringByAppendingString:selectedIndex];
    params = [params stringByAppendingString:@"&fecha_solicitud="];
    params = [params stringByAppendingString:curr_date_string];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"adicion_action_guardar" andController:@"Asistencia_Controller" andParams:params  onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",session);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Mensaje" message:[session objectForKey:@"mensaje"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            NSLog(@"%@",[session objectForKey:@"mensaje"]);
            [loading removeFromSuperview];
            [alert show];
        });
    }];
}

-(void)removeView{
    NSDate *myDate = picker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/Y"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    _initialDateField.text = prettyVersion;
    _initialDateField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [requestDialog removeFromSuperview];
    requestDialog = nil;
}

-(void)removeFinalView{
    NSDate *myDate = picker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/Y"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    _finalDateField.text = prettyVersion;
    _finalDateField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [requestDialog removeFromSuperview];
    requestDialog = nil;
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return [_types_titles count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
    return [_types_titles objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [_types_titles objectAtIndex:index];
	CGRect textSize = [text boundingRectWithSize: constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f] } context:nil];

	return textSize.size.width + 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    selectedIndex = [_indexes objectAtIndex:index];
}

-(void)changeBackground:(UIButton *)sender{
    sender.backgroundColor = [UIColor colorWithRed:94 green:145 blue:234 alpha:0];
    sender.layer.borderColor = [[UIColor colorWithRed:94 green:145 blue:234 alpha:0] CGColor];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 0) {
        if([self.delegate respondsToSelector:@selector(clickedButtonAssistance)])
        {
            [self.delegate clickedButtonAssistance];
        }
    }
}


@end
