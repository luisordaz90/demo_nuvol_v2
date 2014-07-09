//
//  PPCNotification_View.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/19/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCNotification_View.h"


@interface PPCNotification_View ()

@end
NSDictionary *dictRoot;
NSUserDefaults *defaults;
NSString *plistPath;

@implementation PPCNotification_View

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
    _backButton.backgroundColor = [self colorFromHexString:@"#709D43" andAlpha:NO];
    _backButton.layer.borderColor = [[self colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
    [_backButton.layer setBorderWidth:1.0f];
    [_backButton setTitle:@"Regresar" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    _backButton.layer.sublayerTransform = CATransform3DMakeTranslation(1, 0, 0);
    [_backButton addTarget:self action:@selector(changeBackground:) forControlEvents:UIControlStateHighlighted];
    _mainView.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#555555" andAlpha:NO];
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

-(void)viewWillAppear:(BOOL)animated{
    defaults =  [NSUserDefaults standardUserDefaults];
    if (defaults){
        plistPath = [defaults objectForKey:@"plistPath"];
    }
    dictRoot = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"ENTRO AQUI: %lu", (unsigned long)[_notifications count]);
    _tableViewNot.backgroundColor = [UIColor clearColor];
    [_tableViewNot setShowsHorizontalScrollIndicator:NO];
    [_tableViewNot setShowsVerticalScrollIndicator:NO];
    [_tableViewNot reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    // It will not run this function !!
    return [_notifications count];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

-(void) setLabelDimension: (UILabel *)label andDict: (NSDictionary *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andIsBold: (BOOL) condition {
    CGFloat punt1 = label.frame.origin.x;
    CGFloat punt2 = label.frame.origin.y;
    CGFloat height = label.frame.size.height;
    label.frame = CGRectMake(punt1, punt2, 300, height);
    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];
    label.numberOfLines=0;
    //label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = [auxDict objectForKey:key];
    label.textColor = [self colorFromHexString:color];
    if(condition)
        [label setFont:[UIFont boldSystemFontOfSize:13]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
        PPCNotificationCell *cell = (PPCNotificationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCNotificationCell" owner:self options:nil];
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
        NSDictionary *auxDict = [_notifications objectAtIndex: indexPath.row/2];
        NSString *str_aux = [NSString stringWithFormat:@"Mensaje #%ld", indexPath.row/2+1];
        [PPCCommon_Methods setLabelDimension:cell.messageNumber andDict:[NSDictionary dictionaryWithObject:str_aux forKey:@"mensaje"] andKey:@"mensaje" andTextColor:@"#000000" andIsBold:NO andSize:14.0];
        cell.notificationText.text = [auxDict objectForKey:@"texto"];
        [cell.layer setMasksToBounds:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [self colorFromHexString:@"#FFFFFF"];
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 99.0;
}

-(void)changeBackground:(UIButton *)sender{
    sender.backgroundColor = [UIColor colorWithRed:94 green:145 blue:234 alpha:0];
    sender.layer.borderColor = [[UIColor colorWithRed:94 green:145 blue:234 alpha:0] CGColor];
}


- (IBAction)goBack:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickedButton)])
    {
        [self.delegate clickedButton];
        _backButton.backgroundColor = [self colorFromHexString:@"#709D43" andAlpha:NO];
        _backButton.layer.borderColor = [[self colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
        [_backButton.layer setBorderWidth:1.0f];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,304,95)];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *aux = [_notifications objectAtIndex: indexPath.row/2];
        if([_notifications count]==1){
            [_notifications removeObjectAtIndex: indexPath.row/2];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
            if(indexPath.row/2 == ([_notifications count]-1)){
                [_notifications removeObjectAtIndex: indexPath.row/2];
                NSIndexPath *indAux = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
                [tableView deleteRowsAtIndexPaths:@[indexPath,indAux] withRowAnimation: UITableViewRowAnimationFade];
            }
            else{
                [_notifications removeObjectAtIndex: indexPath.row/2];
                NSIndexPath *indAux = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
                [tableView deleteRowsAtIndexPaths:@[indexPath,indAux] withRowAnimation:UITableViewRowAnimationFade];
            }
        //elimCell++
        NSLog(@"ENTRO AQUI %@",aux);
        NSLog(@"%ld %ld %ld", (long)indexPath.row, (indexPath.row/2), [_notifications count] );
        
        NSString *params = @"notificacion_action_leida&id=";
        params = [params stringByAppendingString:[[aux objectForKey:@"id"] stringValue]];
        [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:params andController:@"Notificacion_Controller" andParams:@""  onCompletion:^(NSDictionary *session){
            dispatch_async(dispatch_get_main_queue(), ^{
                if([self.delegate respondsToSelector:@selector(updateMessages:)])
                {
                    [self.delegate updateMessages: _notifications];
                }
            });
        }];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
