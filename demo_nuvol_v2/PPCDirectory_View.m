//
//  PPCDirectory_View.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCDirectory_View.h"
#import "PPCCell_Directory.h"
#import "PPCCustom_Cell_Spacer.h"


@interface PPCDirectory_View ()

@end
NSUserDefaults *defaults;
NSMutableArray *contactArray;
NSString *imagePath;
UIView *loading;
NSMutableDictionary *docDict;
NSDictionary *dictRoot;

@implementation PPCDirectory_View

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
    _tableViewDirectory.hidden = YES;
    NSString *plistPath;
    defaults =  [NSUserDefaults standardUserDefaults];
    if (defaults){
        plistPath = [defaults objectForKey:@"plistPath"];
    }
    dictRoot = [NSDictionary dictionaryWithContentsOfFile: plistPath];
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"directorio_empleados" andController:@"Empleado_Controller" andParams:@"" onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            contactArray = [session objectForKey:@"contenido"];
        });
    }];
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    NSString *plistPath;
    defaults =  [NSUserDefaults standardUserDefaults];
    if (defaults){
        plistPath = [defaults objectForKey:@"plistPath"];
    }
    dictRoot = [NSDictionary dictionaryWithContentsOfFile: plistPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    docDict = [[NSMutableDictionary alloc] init];
    dispatch_queue_t imageQueue = dispatch_queue_create("Array Docs",NULL);
    dispatch_async(imageQueue, ^{
        int i;
        for (i=0; i<[directoryContent count]; i++) {
            NSString *newString = [directoryContent objectAtIndex: i];
            newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
            [docDict setObject:@"1" forKey:newString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            for( NSString *aKey in [docDict allKeys] )
            {
                NSLog(@"%@",aKey);
            }
        });
        
    });
}

-(void)viewDidAppear:(BOOL)animated{
    loading = [[UIView alloc] initWithFrame:CGRectMake(80, 166, 160, 160)];
    loading.opaque = NO;
    UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinning.frame = CGRectMake(61.5, 61.5, 37, 37);
    [spinning startAnimating];
    [loading addSubview:spinning];
    [self.view addSubview:loading];
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        [self downloadImages:contactArray];
        dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
               [_tableViewDirectory reloadData];
               [loading removeFromSuperview];
               _tableViewDirectory.hidden = NO;
        });
            
    });
}

-(void)downloadImages: (NSArray *) contactArray{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    int i;
    for(i=0; i< [contactArray count]; i++){
        NSDictionary *auxDict = [contactArray objectAtIndex: i];
        NSString *photoName = [auxDict objectForKey:@"foto"];
        photoName = [photoName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *aux = [photoName stringByReplacingOccurrencesOfString:@"%20" withString:@""];
        if(![docDict objectForKey:aux]){
            imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:aux]];
            NSString *imageURL = @"http://demo.people-cloud.com/uploads/personas/";
            imageURL =[imageURL stringByAppendingString:photoName];
            NSLog(@"%@",imageURL);
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL     URLWithString:imageURL]]];
            if(image != NULL)
            {
                //Store the image in Document
                NSData *imageData = UIImagePNGRepresentation(image);
                [imageData writeToFile: imagePath atomically:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // in your case, there are 3 cells
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:    (NSInteger)section
{
    return [contactArray count]*2-1;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

-(void) setLabelDimension: (UITextView *)label andDict: (NSDictionary *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andIsBold: (BOOL) condition {
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    label.text = [auxDict objectForKey:key];
    label.textColor = [self colorFromHexString:color];
    if(condition)
        [label setFont:[UIFont boldSystemFontOfSize:13]];
    BOOL sino = [PPCCommon_Methods textView:label shouldChangeCharactersInRange:NSMakeRange(0, 10) replacementString:[auxDict objectForKey:key]];
    NSLog(sino ? @"YES":@"NO");
    label.editable = NO;
    label.dataDetectorTypes = UIDataDetectorTypeAll;
    label.scrollEnabled = NO;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *simpleTableIdentifierSpacer = @"SpacerItem";
    if(indexPath.row % 2 == 0){
        PPCCell_Directory *cell = (PPCCell_Directory *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCCell_Directory" owner:self options:nil];
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

            NSDictionary *auxDict = [contactArray objectAtIndex: indexPath.row/2];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *stringAux = [auxDict objectForKey:@"foto"];
            stringAux = [stringAux stringByReplacingOccurrencesOfString:@" " withString:@""];
            imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:stringAux]];
            cell.cardImage.image = [UIImage imageWithContentsOfFile:imagePath];
            cell.cardImage.contentMode = UIViewContentModeScaleAspectFit;
            [self setLabelDimension:cell.nameCard2 andDict:auxDict andKey:@"nombre" andTextColor:@"#9AB4CB" andIsBold:false];
            [self setLabelDimension:cell.jobPosition2 andDict:auxDict andKey:@"puesto" andTextColor:@"#000000" andIsBold:true];
            [cell.layer setMasksToBounds:YES];
            cell.backgroundColor = [self colorFromHexString:@"#FFFFFF"];
        
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
        cell.backgroundColor = [self colorFromHexString:@"#5EAEEA"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *auxDict = [contactArray objectAtIndex: indexPath.row/2];
    if([self.delegate respondsToSelector:@selector(requestAssitanceView:andIndexes:)])
    {
        [self.delegate requestPersonDetail:auxDict];
    }
    NSLog(@"%@",auxDict);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row % 2 ==0)
        return 90;
    else
        return 3;
}

@end
