//
//  PPCVacation_View.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCVacation_View.h"


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
UINavigationController *navController;

@implementation PPCVacation_View

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *logo_container = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
    logo_container.image = [UIImage imageNamed:@"logo_120x120.jpg"];
    UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithImage:logo_container.image style:UIBarButtonItemStylePlain target:self action:@selector(returnToMenu:)];
    [self.navigationItem setLeftBarButtonItem:logo];
    [self.view addSubview:navController.view];
    _mainView.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#555555" andAlpha:NO];
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
    _vacationTable.backgroundColor = [UIColor clearColor];

}

-(void)viewWillAppear:(BOOL)animated{
    _vacationTable.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addLayOffRequest:(id)sender {
   /* if([self.delegate respondsToSelector:@selector(requestAssitanceView:andIndexes:)])
    {
        [self.delegate requestAssitanceView:final_titles andIndexes:index_number];
    }*/
    self.assistanceView = [[PPCAssistanceRequest alloc] initWithNibName:@"PPCAssistanceRequest" bundle:nil];
    self.assistanceView.view.frame = CGRectMake(0, 44, 320, 492);
    self.assistanceView.types_titles = [final_titles mutableCopy];
    self.assistanceView.indexes = [index_number mutableCopy];
    [self.navigationController pushViewController:self.assistanceView animated:YES];
}

-(void)addRequest{
    [requestDialog removeFromSuperview];
    requestDialog = nil;
    _requestButton.userInteractionEnabled = YES;
}

- (void)resignResponder{
    [textDescription resignFirstResponder];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:    (NSInteger)section
{
    return [vacationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    PPCVacationCell *cell = (PPCVacationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCVacationCell" owner:self options:nil];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,304,120)];
    whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    //whiteRoundedCornerView.layer.cornerRadius = 3.0;
    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    whiteRoundedCornerView.layer.shadowOpacity = 0.5;
    whiteRoundedCornerView.tag = 10;
    if(![cell.contentView viewWithTag:10]){
        [cell.contentView addSubview:whiteRoundedCornerView];
        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
    }
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}

- (void)returnToMenu:(id)sender {
    if([self.delegate respondsToSelector:@selector(openMenu:)])
    {
        [self.delegate openMenu: self.navigationController];
    }
}
@end
