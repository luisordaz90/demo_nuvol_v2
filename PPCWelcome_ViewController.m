//
//  PPCWelcome_ViewController.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCWelcome_ViewController.h"
#import "PPCCustom_Cell_Welcome.h"
#import "PPCCustom_Cell_Spacer.h"
#import "iOSRequest.h"
#import "PPCCommon_Methods.h"

@interface PPCWelcome_ViewController ()

@end
NSString *imagePathWelcome;
NSInteger numberOfNotifications = 0;
NSMutableDictionary *docDict;
NSString *aux;
NSDictionary *dictRoot;

@implementation PPCWelcome_ViewController

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
    imagePathWelcome = @"";
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"SI ENTRO");
    dictRoot = [NSDictionary dictionaryWithContentsOfFile:[PPCCommon_Methods getPath:1]];
    UIView *loading = [PPCCommon_Methods  generateLoadingView:CGRectMake(80, 166, 160, 160) andIndicatorDimensions:CGRectMake(61.5, 61.5, 37, 37) andAlpha:NO];
    [self.view addSubview:loading];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"acceso_rapido_notificaciones_view" andController:@"Notificacion_Controller" andParams: @"" onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            _arrayNotifications = [session objectForKey:@"notificaciones"];
            numberOfNotifications = [[session objectForKey:@"cantidad"] integerValue];
            [_tableVista reloadData];
            [loading removeFromSuperview];
            _tableVista.hidden = NO;
            
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
            [_tableVista reloadData];
        });
    });
}

-(void)viewWillAppear:(BOOL)animated{
    self.tableVista.delegate = self;
    aux = @"";
    _tableVista.hidden = YES;
    _tableVista.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableVista.alwaysBounceVertical = NO;
    [_tableVista setSeparatorInset:UIEdgeInsetsZero];
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
    // Dispose of any resources that can be recreated.
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
    [_tableVista selectRowAtIndexPath:pathToCell animated:YES scrollPosition:UITableViewScrollPositionNone];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(animateSelectionTimer:) userInfo:pathToCell repeats:NO];
    
}

-(void)animateSelectionTimer:(NSTimer *)timer;
{
    [self performSelectorOnMainThread:@selector(animateSelection:) withObject:(NSIndexPath *)timer.userInfo waitUntilDone:NO];
    [timer invalidate];
}

-(void)animateSelection:(NSIndexPath *)pathToCell
{
    if ([_tableVista.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        [_tableVista.delegate tableView:_tableVista willSelectRowAtIndexPath:pathToCell];
    }
    
    if ([_tableVista.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_tableVista.delegate tableView:_tableVista didSelectRowAtIndexPath:pathToCell];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        // this is a container cell
        return 120.0;
    }
    else {
        // this is a "space" cell
        return 3.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *simpleTableIdentifierSpacer = @"SpacerItem";
    if(indexPath.row % 2 == 0){
        PPCCustom_Cell_Welcome *cell = (PPCCustom_Cell_Welcome *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.custom_imageView.image = nil;
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCCustom_Cell" owner:self options:nil];
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
                UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                spinning.frame = CGRectMake(8, 8, 64, 64);
                [spinning startAnimating];
                [loading addSubview:spinning];
                [cell.custom_imageView addSubview: loading];
            }
            else{
                UIImageView *new_image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePathWelcome]];
                new_image.contentMode = UIViewContentModeScaleAspectFit;
                new_image.frame = CGRectMake(8, 8, 64, 64);
                [loading addSubview:new_image];
                [cell.custom_imageView addSubview: loading];
            }
            cell.firstTextView.text = [[PPCCommon_Methods getDefaults] objectForKey:@"nombrecuenta"];
            cell.secondTextView.text = [[PPCCommon_Methods getDefaults] objectForKey:@"nombre_puesto"];
            cell.thirdTextView.text = [[PPCCommon_Methods getDefaults] objectForKey:@"nombre_empresa"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        else
            if(indexPath.row == 2){
                cell.custom_imageView.image= [UIImage imageNamed:@"64x64.png"];
                cell.custom_imageView.image = [cell.custom_imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [cell.custom_imageView setTintColor:[UIColor grayColor]];
                cell.firstTextView.text = @"Días de vacaciones:";
                cell.secondTextView.text = [NSString stringWithString:[[[PPCCommon_Methods getDefaults]objectForKey:@"dias_correspondientes"] stringValue]];
                cell.thirdTextView.text = @"Días consumidos: ";
                cell.thirdTextView.text = [cell.thirdTextView.text stringByAppendingString:[NSString stringWithString:[[[PPCCommon_Methods getDefaults] objectForKey:@"dias_consumidos"] stringValue]]];
                cell.fourthTextView.text = @"Días restantes: ";
                cell.fourthTextView.text = [cell.fourthTextView.text stringByAppendingString:[NSString stringWithString:[[[PPCCommon_Methods getDefaults] objectForKey:@"dias_restantes"] stringValue]]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else
                if (indexPath.row == 4){
                    cell.delegate = self;
                    cell.pathToCell = indexPath;
                    cell.custom_imageView.image= [UIImage imageNamed:@"64x64_notificacion.png"];
                    cell.custom_imageView.image = [cell.custom_imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    [cell.custom_imageView setTintColor:[UIColor grayColor]];
                    NSString *strAux = @"";
                    if(numberOfNotifications){
                        if([_arrayNotifications count]>0){
                            NSDictionary *aux = [_arrayNotifications objectAtIndex:0];
                            strAux = [[NSString stringWithString:[aux objectForKey:@"texto"]] substringToIndex:25];
                        }
                        strAux = [strAux stringByAppendingString:@"..."];
                    }
                    cell.thirdTextView.text = [NSString stringWithFormat:@"%ld", (long)numberOfNotifications];//@"# ";
                    cell.firstTextView.text = @"Notificaciones";
                    cell.secondTextView.text = strAux;
                }
        cell.backgroundColor = [UIColor whiteColor];
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 4){
        if([self.delegate respondsToSelector:@selector(addNotificationView:)])
        {
            [self.delegate addNotificationView: _arrayNotifications];
        }
    }
}




@end
