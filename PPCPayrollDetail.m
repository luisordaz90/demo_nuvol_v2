//
//  PPCPayrollDetail.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 6/2/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCPayrollDetail.h"

@interface PPCPayrollDetail ()
@end

NSDictionary *dictRoot;
NSMutableArray *dictDetails;
NSMutableDictionary *dictionary;

@implementation PPCPayrollDetail

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
    _payrollDetailTable.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    dictRoot = [NSDictionary dictionaryWithContentsOfFile:[PPCCommon_Methods getPath:1]];
    UIView *loading = [PPCCommon_Methods  generateLoadingView:CGRectMake(80, 166, 160, 160) andIndicatorDimensions:CGRectMake(61.5, 61.5, 37, 37) andAlpha:NO];
    [self.view addSubview:loading];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"receipt_detail" andController:@"Mobile_Controller" andParams: _period onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            dictionary = [session objectForKey:@"recibo"];
            NSLog(@"%@",dictDetails);
            [_payrollDetailTable reloadData];
            [loading removeFromSuperview];
            _payrollDetailTable.hidden = NO;
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiptConfirmation{
    UIView *loading = [PPCCommon_Methods  generateLoadingView:CGRectMake(80, 166, 160, 160) andIndicatorDimensions:CGRectMake(61.5, 61.5, 37, 37) andAlpha:NO];
    [self.view addSubview:loading];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"confirmar_recibo" andController:@"Mobile_Controller" andParams: _period onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"%lu",section);
    NSString *sectionName;
    switch (section)
    {
        case 0:
            NSLog(@"%lu",section);
            sectionName = @"Datos personales";
            break;
        default:
            NSLog(@"%lu",section);
            sectionName = @"LOL";
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    switch (section) {
        case 0:
            return [[dictionary objectForKey:@"datos_personales"] count];
            break;
        case 1:
            return [[dictionary objectForKey:@"percepciones"] count];
            break;
        case 2:
            return [[dictionary objectForKey:@"deducciones"] count];
            break;
        default:
            return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    UILabel *labelPrueba = [[UILabel alloc] init];
    labelPrueba.text = [_payrollDetailTable.dataSource tableView:_payrollDetailTable titleForHeaderInSection:section];
    headerView.frame = CGRectMake(0, 0, 320, 80);
    labelPrueba.frame = CGRectMake(40, 40, 100, 20);
    [headerView addSubview:labelPrueba];
    [headerView setBackgroundColor: [UIColor redColor]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    PPCPayrollDetailCell *cell = (PPCPayrollDetailCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCPayrollDetailCell" owner:self options:nil];
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
    if(indexPath.section == 0){
        cell.cellTitle.text =  [[[[dictionary objectForKey:@"datos_personales"] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];//[[[dictionary objectForKey:@"datos_personales"] objectAtIndex:indexPath.row] objectForKey:[[[[dictionary objectForKey:@"datos_personales"] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]];
            //Sin orden
            //cell.cellTitle.text = [[dictionary objectForKey:@"datos_personales"] objectForKey:[[[dictionary objectForKey:@"datos_personales"] allKeys] objectAtIndex:indexPath.row]];
    }
    else
        if(indexPath.section == 1){
            cell.cellTitle.text = [[[[dictionary objectForKey:@"percepciones"] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
            
            //Para evitar tanto 'nesteo', puedo sacar el key y luego volver a accederlo.
            //NSString *prueba =[[[dictionary objectForKey:@"percepciones"] allKeys] objectAtIndex:indexPath.row];
        }
        else
            if(indexPath.section == 2){
                cell.cellTitle.text = [[[[dictionary objectForKey:@"deducciones"] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
            }
            else
                if(indexPath.section == 3){
                    UIButton *dismiss_button = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, 260, 40)];
                    dismiss_button.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO];
                    dismiss_button.layer.borderColor = [[PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
                    [dismiss_button.layer setBorderWidth:1.0f];
                    [dismiss_button setTitle:@"Confirmar" forState:UIControlStateNormal];
                    [dismiss_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [dismiss_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                    dismiss_button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
                    [dismiss_button addTarget:self action:@selector(receiptConfirmation) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:dismiss_button];
                }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

@end
