//
//  PPCConfiguration_ViewController.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 1/27/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCConfiguration_ViewController.h"
#import "PPCCommon_Methods.h"

@interface PPCConfiguration_ViewController ()

@end
@implementation PPCConfiguration_ViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButton:(id)sender {
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"",@"",@"", nil] forKeys:[NSArray arrayWithObjects: @"user_id", @"token",@"SID", nil]];
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile: [PPCCommon_Methods getPath:1] atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
    if([self.delegate respondsToSelector:@selector(logout)])
    {
        [self.delegate logout];
    }
}
@end
