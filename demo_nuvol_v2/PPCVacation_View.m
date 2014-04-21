//
//  PPCVacation_View.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCVacation_View.h"
#import "iOSRequest.h"
#import "PPCVacation_Cell.h"
#import "PPCCustom_Cell_Spacer.h"

@interface PPCVacation_View ()

@end

NSUserDefaults *defaults;
NSMutableArray *vacationArray;
NSString *imagePath;
UIView *loading;
UIView *requestDialog;
NSMutableDictionary *docDict;
NSMutableArray *titles;
UITextView *textDescription;
NSMutableDictionary *arr;
NSMutableArray *final_titles;
NSMutableArray *index_number;
NSString *plistPath;
NSDictionary *dictRoot;

@implementation PPCVacation_View

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
    titles = [[NSMutableArray alloc] initWithObjects:@"Vacaciones",@"Permiso", @"Falta",@"Incapacidad",@"Permiso Especial", nil];
}

-(void)viewDidAppear:(BOOL)animated{
    plistPath = [PPCCommon_Methods getPlistPath];
    dictRoot = [NSDictionary dictionaryWithContentsOfFile: plistPath];
    loading = [PPCCommon_Methods generateLoadingView:CGRectMake(80, 166, 160, 160) andIndicatorDimensions:CGRectMake(61.5, 61.5, 37, 37) andAlpha:NO];
    [self.view addSubview:loading];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"empleado_action_datatable_registros" andController:@"Asistencia_Controller" andParams:@"" onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            vacationArray = [session objectForKey:@"datos"];
            [_vacationTable reloadData];
            [loading removeFromSuperview];
            _vacationTable.hidden = NO;
        });
    }];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"adicion_view" andController:@"Asistencia_Controller" andParams:@"" onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            arr = [session objectForKey:@"registros"];
            final_titles = [[NSMutableArray alloc] init];
            index_number = [[NSMutableArray alloc] init];
            for(NSString *key in [arr allKeys]){
                NSLog(@"%@",key);
                [final_titles addObject:[titles objectAtIndex:[key integerValue]-1]];
                [index_number addObject:key];
                NSLog(@"INDICE %@",[index_number objectAtIndex:0]);
            }
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    _vacationTable.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // in your case, there are 3 cells
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:    (NSInteger)section
{
    return [vacationArray count]*2-1;
}

-(void) setLabelDimension: (UILabel *)label andDict: (NSDictionary *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andWidth: (NSInteger) width andIsBold: (BOOL) condition {
    NSString *str;
    if([key isEqualToString:@"fecha_fin"]){
        str = @"Fecha final: ";
        str = [str stringByAppendingString:[auxDict objectForKey:key]];
    }
    else
        if([key isEqualToString:@"fecha_ini"]){
            str = @"Fecha inicial: ";
            str = [str stringByAppendingString:[auxDict objectForKey:key]];
        }
        else
            str = [auxDict objectForKey:key];
    CGFloat punt1 = label.frame.origin.x;
    CGFloat punt2 = label.frame.origin.y;
    CGFloat height = label.frame.size.height;
    if(condition)
        [label setFont:[UIFont boldSystemFontOfSize:13]];
    else
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];
    label.numberOfLines=2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.frame = CGRectMake(punt1, punt2, width, height);
    label.text = str;
    if([[auxDict objectForKey:key] isEqualToString:@"Rechazado"]){
        color = @"#FF0000";
    }
    if([[auxDict objectForKey:key] isEqualToString:@"Autorizado"]){
        color = @"#01DF01";
    }
    label.textColor = [PPCCommon_Methods colorFromHexString:color andAlpha:NO];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *simpleTableIdentifierSpacer = @"SpacerItem";
    if(indexPath.row % 2 == 0){
        PPCVacation_Cell *cell = (PPCVacation_Cell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCVacation_Cell" owner:self options:nil];
            for (id eachObject in nib) {
                if ([eachObject isKindOfClass:[UITableViewCell class]]) {
                    cell = eachObject;
                    break;
                }
                else{
                    NSLog(@"NO");
                }
            }
        }
        
        NSDictionary *auxDict = [vacationArray objectAtIndex: indexPath.row/2];
        [self setLabelDimension:cell.initialDate andDict:auxDict andKey:@"fecha_ini" andTextColor:@"#000000" andWidth: 80 andIsBold:false];
        [self setLabelDimension:cell.finalDate andDict:auxDict andKey:@"fecha_fin" andTextColor:@"#000000" andWidth: 80
            andIsBold:false];
        [self setLabelDimension:cell.type andDict:auxDict andKey:@"tipo" andTextColor:@"#515967" andWidth: 210  andIsBold:true];
        cell.description.text = [auxDict objectForKey:@"descripcion"];
        cell.description.textColor = [PPCCommon_Methods colorFromHexString:@"#000000" andAlpha:NO];
        cell.description.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];
        cell.description.textAlignment = NSTextAlignmentLeft;
        [self setLabelDimension:cell.status andDict:auxDict andKey:@"status" andTextColor:@"#FF8000" andWidth: 90 andIsBold:false];
        [cell.layer setMasksToBounds:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#FFFFFF" andAlpha:NO];
        return cell;
    }
    else{
        PPCCustom_Cell_Spacer *cell = (PPCCustom_Cell_Spacer *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierSpacer];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCCustom_Cell_Spacer" owner:self options:nil];
            for (id eachObject in nib) {
                if ([eachObject isKindOfClass:[UITableViewCell class]]) {
                    cell = eachObject;
                    break;
                }
                else{
                    NSLog(@"NO");
                }
            }
        }
        cell.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#5EAEEA" andAlpha:NO];
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row % 2 ==0)
        return 120;
    else
        return 3;
}


- (IBAction)addLayOffRequest:(id)sender {
    if([self.delegate respondsToSelector:@selector(requestAssitanceView:andIndexes:)])
    {
        [self.delegate requestAssitanceView:final_titles andIndexes:index_number];
    }
}

-(void)addRequest{
    [requestDialog removeFromSuperview];
    requestDialog = nil;
    _requestButton.userInteractionEnabled = YES;
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return [final_titles count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
    return [final_titles objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [final_titles objectAtIndex:index];
	CGRect textSize = [text boundingRectWithSize: constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]} context:nil];
	return textSize.size.width + 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
}

- (void)resignResponder{
    [textDescription resignFirstResponder];
}


@end
