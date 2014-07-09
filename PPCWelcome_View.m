//
//  PPCWelcome_ViewController.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCWelcome_View.h"

@interface PPCWelcome_View ()
@end

NSString *imagePathWelcome;
NSInteger numberOfNotifications = 0;
NSMutableDictionary *docDict;
NSString *aux;
NSDictionary *dictRoot;
CGFloat previousScrollViewYOffset;

@implementation PPCWelcome_View

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
    //UIImageView *logo_container = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
    //logo_container.image = [UIImage imageNamed:@"logo_120x120.jpg"];
    UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"24x24_5.png"] style:UIBarButtonItemStylePlain target:self action:@selector(returnToMenu:)];
    [self.navigationItem setLeftBarButtonItem:logo];
    imagePathWelcome = @"";
    self.navigationController.navigationBar.tintColor = [PPCCommon_Methods colorFromHexString:@"#FFFFFF" andAlpha:NO];
    self.navigationController.navigationBar.barTintColor = [PPCCommon_Methods colorFromHexString:@"#000000" andAlpha:NO];
     _mainView.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#555555" andAlpha:NO];

}

-(void)viewDidAppear:(BOOL)animated{
    dictRoot = [NSDictionary dictionaryWithContentsOfFile:[PPCCommon_Methods getPath:1]];
    UIView *loading = [PPCCommon_Methods  generateLoadingView:CGRectMake(80, 166, 160, 160) andIndicatorDimensions:CGRectMake(61.5, 61.5, 37, 37) andAlpha:NO];
    [self.view addSubview:loading];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"acceso_rapido_notificaciones_view" andController:@"Notificacion_Controller" andParams: @"" onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            _arrayNotifications = [session objectForKey:@"notificaciones"];
            numberOfNotifications = [[session objectForKey:@"cantidad"] integerValue];
            [_welcomeTable reloadData];
            [loading removeFromSuperview];
            _welcomeTable.hidden = NO;
            
        });
    }];
    NSString *photoName = [[PPCCommon_Methods getDefaults] objectForKey:@"foto"];
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        [PPCCommon_Methods downloadImages: photoName andDict: docDict];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            NSString *stringAux = photoName;
            stringAux = [stringAux stringByReplacingOccurrencesOfString:@" " withString:@""];
            imagePathWelcome = [[PPCCommon_Methods getPath:0] stringByAppendingPathComponent:[NSString stringWithString:stringAux]];
            [_welcomeTable reloadData];
        });
    });
    _welcomeTable.backgroundColor = [UIColor clearColor];

}

-(void)viewWillAppear:(BOOL)animated{
    self.welcomeTable.delegate = self;
    aux = @"";
    _welcomeTable.hidden = YES;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [PPCCommon_Methods getPath:0] error:NULL];
    docDict = [[NSMutableDictionary alloc] init];
    dispatch_queue_t imageQueue = dispatch_queue_create("Array Docs",NULL);
    dispatch_async(imageQueue, ^{
        for (int i=0; i<[directoryContent count]; i++) {
            NSString *newString = [directoryContent objectAtIndex: i];
            newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
            [docDict setObject:@"1" forKey:newString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)dismissVariables{
    imagePathWelcome = nil;
    numberOfNotifications = 0;
    docDict = nil;
    aux = nil;
    imagePathWelcome = @"";
}

-(void)clickedCell:(NSIndexPath *)pathToCell{
    [_welcomeTable selectRowAtIndexPath:pathToCell animated:YES scrollPosition:UITableViewScrollPositionNone];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(animateSelectionTimer:) userInfo:pathToCell repeats:NO];
    
}

-(void)animateSelectionTimer:(NSTimer *)timer;
{
    [self performSelectorOnMainThread:@selector(animateSelection:) withObject:(NSIndexPath *)timer.userInfo waitUntilDone:NO];
    [timer invalidate];
}

-(void)animateSelection:(NSIndexPath *)pathToCell
{
    if ([_welcomeTable.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        [_welcomeTable.delegate tableView:_welcomeTable willSelectRowAtIndexPath:pathToCell];
    }
    
    if ([_welcomeTable.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_welcomeTable.delegate tableView:_welcomeTable didSelectRowAtIndexPath:pathToCell];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    PPCWelcomeCell *cell = (PPCWelcomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.custom_imageView.image = nil;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCWelcomeCell" owner:self options:nil];
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
    if(indexPath.row == 0){
        UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        loading.layer.cornerRadius = 15;
        [loading setBackgroundColor:[PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO]];
        if([imagePathWelcome isEqualToString:@""]){
            UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                spinning.frame = CGRectMake(8, 8, 64, 64);
                [spinning startAnimating];
                [loading addSubview:spinning];
                [cell.custom_imageView addSubview: loading];
        }
        else{
            cell.custom_imageView.image = [UIImage imageWithContentsOfFile:imagePathWelcome];
            cell.custom_imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        [PPCCommon_Methods setTextViewPlain:cell.firstTextView andString:[[PPCCommon_Methods getDefaults] objectForKey:@"nombrecuenta"] andTextColor:@"#000000" andIsBold:NO andSize:19 andType:@"-light"];
        [PPCCommon_Methods setTextViewPlain:cell.secondTextView andString:[[PPCCommon_Methods getDefaults] objectForKey:@"nombre_puesto"] andTextColor:@"#000000" andIsBold:NO andSize:14 andType:@"-thin"];
        [PPCCommon_Methods setTextViewPlain:cell.thirdTextView andString:[[PPCCommon_Methods getDefaults] objectForKey:@"nombre_empresa"] andTextColor:@"#000000" andIsBold:NO andSize:14 andType:@"-thin"];
    }
        
    else
        if(indexPath.row == 1){
            cell.custom_imageView.image= [UIImage imageNamed:@"64x64.png"];
            cell.custom_imageView.image = [cell.custom_imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.custom_imageView setTintColor:[UIColor grayColor]];
            [PPCCommon_Methods setTextViewPlain:cell.firstTextView andString:@"Vacaciones"andTextColor:@"#000000" andIsBold:YES andSize:14 andType:@""];
            cell.secondTextView.text =@"Dias correspondientes: ";
            cell.secondTextView.text = [cell.secondTextView.text stringByAppendingString:[NSString stringWithString:[[[PPCCommon_Methods getDefaults]objectForKey:@"dias_correspondientes"] stringValue]]];
            cell.thirdTextView.text = @"Días consumidos: ";
            cell.thirdTextView.text = [cell.thirdTextView.text stringByAppendingString:[NSString stringWithString:[[[PPCCommon_Methods getDefaults] objectForKey:@"dias_consumidos"] stringValue]]];
            cell.fourthTextView.text = @"Días restantes: ";
            cell.fourthTextView.text = [cell.fourthTextView.text stringByAppendingString:[NSString stringWithString:[[[PPCCommon_Methods getDefaults] objectForKey:@"dias_restantes"] stringValue]]];
        }
        else
            if (indexPath.row == 2){
                cell.delegate = self;
                cell.pathToCell = indexPath;
                cell.custom_imageView.image= [UIImage imageNamed:@"64x64_notificacion.png"];
                cell.custom_imageView.image = [cell.custom_imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [cell.custom_imageView setTintColor:[UIColor grayColor]];
                NSString *strAux = @"";
                if(numberOfNotifications){
                    if([_arrayNotifications count]>0){
                        NSDictionary *aux = [_arrayNotifications objectAtIndex:0];
                        strAux = [aux objectForKey:@"texto"];//[[NSString stringWithString:[auxobjectForKey:@"texto"]] substringToIndex:25];
                    }
                    strAux = [strAux stringByAppendingString:@"..."];
                }
                cell.thirdTextView.text = [NSString stringWithFormat:@"%ld", (long)numberOfNotifications];//@"# ";
                [PPCCommon_Methods setTextViewPlain:cell.firstTextView andString:@"Notificaciones"andTextColor:@"#000000" andIsBold:YES andSize:14 andType:@""];
                cell.secondTextView.text = strAux;
            }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        self.notificationView = [[PPCNotification_View alloc] initWithNibName:@"PPCNotification_View" bundle:nil];
        self.notificationView.view.frame = CGRectMake(0, 0, 320, 492);
        self.notificationView.notifications = _arrayNotifications;
        [self.navigationController pushViewController:self.notificationView animated:YES];
    }
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
    return 130.0;
}

- (void)returnToMenu:(id)sender {
    NSLog(@"HEIGHT: %f, POS: %f %f",self.navigationController.navigationBar.frame.size.height,self.navigationController.navigationBar.frame.origin.x, self.navigationController.navigationBar.frame.origin.y);
    if([self.delegate respondsToSelector:@selector(openMenu:)])
    {
        [self.delegate openMenu: self.navigationController];
    }
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frame.origin.y = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frame.origin.y = -size;
    } else {
        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
    }
    
    [self.navigationController.navigationBar setFrame:frame];
    [self updateBarButtonItems:(1 - framePercentageHidden)];
    previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}
- (void)stoppedScrolling
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y < 20) {
        [self animateNavBarTo:-(frame.size.height - 21)];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.navigationBar setFrame:frame];
        [self updateBarButtonItems:alpha];
    }];
}
*/
@end
