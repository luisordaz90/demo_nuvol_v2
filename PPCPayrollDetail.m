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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    dictRoot = [NSDictionary dictionaryWithContentsOfFile:[PPCCommon_Methods getPath:1]];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"receipt_detail" andController:@"Mobile_Controller" andParams: _period onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            dictDetails = [[session objectForKey:@"recibo"] objectForKey:@"datos_personales"];
            NSLog(@"%@",dictDetails);
            [_payrollDetailTable reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Datos personales";
            break;
        default:
            sectionName = @"LOL";
            break;
    }
    return sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    if(section == 0)
        return 5;
    else
        return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    UILabel *labelPrueba = [[UILabel alloc] init];
    labelPrueba.text = @"Datos personales";
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
        cell.cellTitle.text = [[[dictDetails objectAtIndex: indexPath.row] allKeys] objectAtIndex:0];
        NSLog(@"%@ %lu",cell.cellTitle.text, indexPath.row);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


@end
