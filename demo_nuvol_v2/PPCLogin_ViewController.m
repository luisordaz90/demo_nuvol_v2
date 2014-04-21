//
//  PPCLogin_ViewController.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCLogin_ViewController.h"
#import "iOSRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface PPCLogin_ViewController ()
@end
NSString *errorDesc = nil;
NSString *id_for_nuvol;
NSString *device_name;

@implementation PPCLogin_ViewController

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
    // Do any additional setup after loading the view from its nib.
    [self setNeedsStatusBarAppearanceUpdate];
    errorDesc = nil;
    id_for_nuvol = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    device_name = [[UIDevice currentDevice] name];
    device_name = [device_name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    [[PPCCommon_Methods getDefaults] setObject:[PPCCommon_Methods getPath:1] forKey:@"plistPath"];
    _buttonLogin.layer.cornerRadius = 3;
    _buttonLogin.layer.borderWidth = 0;
    UIView *userContainer =[[UIView alloc] initWithFrame: CGRectMake(0, 500, 250, 50)];
    userContainer.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
    _buttonLogin.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO];
    _buttonLogin.layer.borderColor = [[PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
    [_buttonLogin.layer setBorderWidth:1.0f];
    [_buttonLogin setTitle:@"Ingresar" forState:UIControlStateNormal];
    [_buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _buttonLogin.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    _buttonLogin.layer.sublayerTransform = CATransform3DMakeTranslation(1, 0, 0);
    [_buttonLogin addTarget:self action:@selector(changeBackground:) forControlEvents:UIControlStateHighlighted];
    _imageViewUser.layer.borderColor = [[PPCCommon_Methods colorFromHexString:@"#4B89D0" andAlpha:NO]CGColor];
    _imageViewUser.layer.borderWidth = 1.0f;
    _imageViewPassword.layer.borderColor = [[PPCCommon_Methods colorFromHexString:@"#4B89D0" andAlpha:NO]CGColor];
    _imageViewPassword.layer.borderWidth = 1.0f;
    _userName.textColor = [UIColor grayColor];
    _password.textColor = [UIColor grayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    _buttonLogin.hidden = NO;
}

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{

    CGRect viewFrame = self.buttonLogin.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.origin.y -= 59;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.buttonLogin setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect viewFrame = self.buttonLogin.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.origin.y += 59;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.buttonLogin setFrame:viewFrame];
    [UIView commitAnimations];
}

-(void)changeBackground:(UIButton *)sender{
    sender.backgroundColor = [UIColor colorWithRed:94 green:145 blue:234 alpha:0];
    sender.layer.borderColor = [[UIColor colorWithRed:94 green:145 blue:234 alpha:0] CGColor];
}

- (IBAction)resignResponders:(id)sender {
    [_password resignFirstResponder];
    [_userName resignFirstResponder];
}

- (IBAction)buttonPressed{
    [self loginWithUserName:_userName.text andPassword:_password.text];
}

-(void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password
{
    UIView *loading = [PPCCommon_Methods generateLoadingView:CGRectMake(0, 0, 320, 568) andIndicatorDimensions:CGRectMake(141.5, 335.5, 37, 37) andAlpha: NO];
    UIAlertView *vista_error = [UIAlertView alloc];
    [vista_error setTitle:@"Error"];
    [vista_error setCancelButtonIndex:[vista_error addButtonWithTitle:@"Cancel"]];
    _buttonLogin.hidden = YES;
    [self.view addSubview:loading];
    [iOSRequest loginWithUserName:userName andPassword:password andUID:id_for_nuvol andName: device_name onCompletion:^(NSDictionary *user){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([user count]>0){
                if(!user[@"error"]){
                    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:user[@"usuario"],user[@"token"],user[@"session_id"], nil] forKeys:[NSArray     arrayWithObjects: @"user_id", @"token",@"SID", nil]];
                    NSString *error = nil;
                    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
                    if(plistData)
                    {
                        [plistData writeToFile:[PPCCommon_Methods getPath:1] atomically:YES];
                    }
                    else
                    {
                        NSLog(@"Error in saveData: %@", error);
                    }
                    [iOSRequest generalRequest:user[@"session_id"] andUser:user[@"usuario"] andToken:user[@"token"] andAction:@"fetch_session" andController:@"Mobile_Controller" andParams:@"" onCompletion:^(NSDictionary *session){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [loading removeFromSuperview];
                            [defaultVals setValuesForKeysWithDictionary:session];
                            _password.text = nil;
                            _userName.text = nil;
                            [iOSRequest generalRequest:user[@"session_id"] andUser:user[@"usuario"] andToken:user[@"token"] andAction:@"resumen_dias_view" andController:@"Asistencia_Controller" andParams:@"" onCompletion:^(NSDictionary *session){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [defaultVals setValuesForKeysWithDictionary:session];
                                    _password.text = nil;
                                    _userName.text = nil;
                                    if([self.delegate respondsToSelector:@selector(dismissedSubviewLogin)])
                                    {
                                        [self.delegate dismissedSubviewLogin];
                                        _buttonLogin.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO];
                                        _buttonLogin.layer.borderColor = [[PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
                                    }
                                });
                            }];
                        });
                    }];

                }
                else{
                    [vista_error setMessage:@"Usuario y/o contraseña inválido"];
                    [loading removeFromSuperview];
                    [vista_error show];
                    _buttonLogin.hidden = NO;
                }
            }
            else{
                [vista_error setMessage:@"Sin comunicación"];
                [loading removeFromSuperview];
                [vista_error show];
                _buttonLogin.hidden = NO;
            }
        });
    }];
    _buttonLogin.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO];
    _buttonLogin.layer.borderColor = [[PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
}


@end
