//
//  PPCPayRoll_View.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCPayRoll_View.h"


@interface PPCPayRoll_View ()
@end

NSDictionary *dictRoot;
NSMutableArray *receipts;

@implementation PPCPayRoll_View

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    _payrollTable.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    _backgroundView.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#555555" andAlpha:NO];
    NSLog(@"@%lf @%lf", _payrollTable.frame.size.width, _payrollTable.frame.size.height);
    dictRoot = [NSDictionary dictionaryWithContentsOfFile:[PPCCommon_Methods getPath:1]];
    UIView *loading = [PPCCommon_Methods  generateLoadingView:CGRectMake(80, 166, 160, 160) andIndicatorDimensions:CGRectMake(61.5, 61.5, 37, 37) andAlpha:NO];
    [self.view addSubview:loading];
    _payrollTable.backgroundColor = [UIColor clearColor];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"recibos_historial_registros" andController:@"Mobile_Controller" andParams: @"" onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            [loading removeFromSuperview];
            receipts = [session objectForKey:@"recibos"];
            if(![receipts count])
                NSLog(@"EMPTY");
            else{
                [_payrollTable reloadData];
                _payrollTable.hidden = NO;
            }
            
            NSLog(@"%lu",(unsigned long)[receipts count]);
            [_payrollTable setShowsHorizontalScrollIndicator:NO];
            [_payrollTable setShowsVerticalScrollIndicator:NO];
        });
    }];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [receipts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    PPCPayrollCell *cell = (PPCPayrollCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCPayrollCell" owner:self options:nil];
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
    NSDictionary *auxDict = [receipts objectAtIndex: indexPath.row];
    cell.dateTextView.text = [[auxDict objectForKey:@"periodo"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [cell.dateTextView setContentInset:UIEdgeInsetsMake(-8, -5, 0,0)];
    cell.earningTextView.text = [auxDict objectForKey:@"percepcion"];
    [cell.earningTextView setContentInset:UIEdgeInsetsMake(-8, 10, 0,0)];
    cell.earningTextView.textAlignment = NSTextAlignmentRight;
    cell.deductionTextView.text = [auxDict objectForKey:@"deduccion"];
    [cell.deductionTextView setContentInset:UIEdgeInsetsMake(-8, 0, 0,0)];
    cell.deductionTextView.textAlignment = NSTextAlignmentRight;
    cell.totalTextView.text = [auxDict objectForKey:@"total"];
    [cell.totalTextView setContentInset:UIEdgeInsetsMake(-8, -5, 0,0)];
    cell.totalTextView.textAlignment = NSTextAlignmentLeft;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([[auxDict objectForKey:@"estatus"] integerValue] == 1){
        cell.statusImage.image = [UIImage imageNamed:@"checkmark@2x.png"];
        cell.statusImage.image = [cell.statusImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.statusImage setTintColor:[UIColor greenColor]];
    }
    else{
        cell.statusImage.image = [UIImage imageNamed:@"cancel@2x.png"];
        cell.statusImage.image = [cell.statusImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.statusImage setTintColor:[UIColor redColor]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PPCPayrollCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,304,90)];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [receipts objectAtIndex:indexPath.row];
    NSString *period = [@"idperiodo=" stringByAppendingString:[dict objectForKey:@"recibo"]];
    if([self.delegate respondsToSelector:@selector(requestPayrollDetail:)])
    {
        [self.delegate requestPayrollDetail: period];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end
