//
//  PPCViewController_PruebaMenu.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/23/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCViewController_PruebaMenu.h"

@interface PPCViewController_PruebaMenu ()

@end

@implementation PPCViewController_PruebaMenu

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
    // Do any additional setup after loading the view from its nib.
    MSMenuView *menu = [[MSMenuView alloc] initWithFrame:CGRectMake(0,492,0,0)];
    [menu setDelegate:self];
    [self.view addSubview:menu];
    self.welcomeView = [[PPCWelcome_ViewController alloc] initWithNibName:@"Welcome_View" bundle:nil];
    self.confView = [[PPCConfiguration_ViewController alloc] initWithNibName:@"Configuration_View" bundle:nil];
    self.confView.delegate = self;
    self.welcomeView.view.frame = CGRectMake(0, 0, 320, 492);
    self.confView.view.frame = CGRectMake(0, 0, 320, 492);
    [self.view addSubview:self.welcomeView.view];
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout{
    if([self.delegate respondsToSelector:@selector(logoutMain)])
    {
        [self.delegate logoutMain];
    }
    NSLog(@"ENTRO DENTRO");
}

-(void)PlaylistBtnClick{
    [self.view addSubview:self.welcomeView.view];
    
}
-(void)ArtistBtnClick{
    [self.view addSubview:self.confView.view];
}
-(void)AlbumBtnClick{
}
-(void)AllSongsBtnClick{
}
-(void)MoreBtnClick{
}

@end
