//
//  PPCDetail_View.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 4/14/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCDetail_View.h"
#import "PPCCommon_Methods.h"

@interface PPCDetail_View ()

@end
UIView *loading;

@implementation PPCDetail_View

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
    _backButton.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO];
    _backButton.layer.borderColor = [[PPCCommon_Methods colorFromHexString:@"#709D43" andAlpha:NO] CGColor];
    [_backButton.layer setBorderWidth:1.0f];
    [_backButton setTitle:@"Regresar" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    _backButton.layer.sublayerTransform = CATransform3DMakeTranslation(1, 0, 0);
    [_backButton addTarget:self action:@selector(changeBackground:) forControlEvents:UIControlStateHighlighted];
    _backButton.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    _viewContainer.hidden = YES;
    loading = [PPCCommon_Methods generateLoadingView:CGRectMake(0, 114, 320, 366) andIndicatorDimensions:CGRectMake(141.5, 164.5, 37, 37) andAlpha: NO];
    [self.view addSubview:loading];
}

-(void)viewDidAppear:(BOOL)animated{
    [loading removeFromSuperview];
    _viewContainer.hidden = NO;
    _backButton.hidden = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *stringAux = [_personDetails objectForKey:@"foto"];
    stringAux = [stringAux stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:stringAux]];
    _personImage.image = [UIImage imageWithContentsOfFile:imagePath];
    _personImage.contentMode = UIViewContentModeScaleAspectFit;
    _personName.text = [_personDetails objectForKey:@"nombre"];
    _email.text = [_personDetails objectForKey:@"email"];
    _phoneNumber.text = [_personDetails objectForKey:@"tel"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)changeBackground:(UIButton *)sender{
    sender.backgroundColor = [UIColor colorWithRed:94 green:145 blue:234 alpha:0];
    sender.layer.borderColor = [[UIColor colorWithRed:94 green:145 blue:234 alpha:0] CGColor];
}

- (IBAction)backToDirectory:(id)sender {
    if([self.delegate respondsToSelector:@selector(backToDirectory)])
    {
        [self.delegate backToDirectory];
    }
}


@end
