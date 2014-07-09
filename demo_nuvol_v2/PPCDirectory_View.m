//
//  PPCDirectory_View.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCDirectory_View.h"
#import "PPCCustom_Cell_Spacer.h"


@interface PPCDirectory_View ()

@end
NSMutableArray *contactArray;
UIView *loading;
NSMutableDictionary *docDict;
NSDictionary *dictRoot;
NSString *plistPath;
UINavigationController *navController;

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
    [super viewDidLoad];
    plistPath = [PPCCommon_Methods getPlistPath];
    dictRoot = [NSDictionary dictionaryWithContentsOfFile: plistPath];
    UIImageView *logo_container = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
    logo_container.image = [UIImage imageNamed:@"logo_120x120.jpg"];
    UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithImage:logo_container.image style:UIBarButtonItemStylePlain target:self action:@selector(returnToMenu:)];
    [self.navigationItem setLeftBarButtonItem:logo];
    [self.view addSubview:navController.view];
    _mainView.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#555555" andAlpha:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[PPCCommon_Methods getDocumentsPath] error:NULL];
    _tableViewDirectory.hidden = YES;
    plistPath = [PPCCommon_Methods getPlistPath];
    dictRoot = [NSDictionary dictionaryWithContentsOfFile: plistPath];
    docDict = [[NSMutableDictionary alloc] init];
    dispatch_queue_t imageQueue = dispatch_queue_create("Array Docs",NULL);
    dispatch_async(imageQueue, ^{
        for (int i=0; i<[directoryContent count]; i++) {
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
    loading = [PPCCommon_Methods generateLoadingView:CGRectMake(80, 166, 160, 160) andIndicatorDimensions:CGRectMake(61.5, 61.5, 37, 37) andAlpha:NO];
    [self.view addSubview:loading];
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    [iOSRequest generalRequest:[dictRoot objectForKey:@"SID"] andUser:[dictRoot objectForKey:@"user_id"] andToken:[dictRoot objectForKey:@"token"] andAction:@"directorio_empleados" andController:@"Empleado_Controller" andParams:@"" onCompletion:^(NSDictionary *session){
        dispatch_async(dispatch_get_main_queue(), ^{
            contactArray = [session objectForKey:@"contenido"];
            dispatch_async(imageQueue, ^{
                [PPCCommon_Methods downloadImagesWithArray:contactArray andDict:docDict];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableViewDirectory reloadData];
                    [loading removeFromSuperview];
                    _tableViewDirectory.hidden = NO;
                });
                
            });
        });
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:    (NSInteger)section
{
    NSLog(@"%lu", [contactArray count]);
    return [contactArray count]*2-1;
}

-(void)clickedCell:(NSIndexPath *)pathToCell{
    [_tableViewDirectory selectRowAtIndexPath:pathToCell animated:YES scrollPosition:UITableViewScrollPositionNone];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(animateSelectionTimer:) userInfo:pathToCell repeats:NO];

}

-(void)animateSelectionTimer:(NSTimer *)timer;
{
    [self performSelectorOnMainThread:@selector(animateSelection:) withObject:(NSIndexPath *)timer.userInfo waitUntilDone:NO];
    [timer invalidate];
}

-(void)animateSelection:(NSIndexPath *)pathToCell
{
    if ([_tableViewDirectory.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        [_tableViewDirectory.delegate tableView:_tableViewDirectory willSelectRowAtIndexPath:pathToCell];
    }
    
    if ([_tableViewDirectory.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_tableViewDirectory.delegate tableView:_tableViewDirectory didSelectRowAtIndexPath:pathToCell];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *simpleTableIdentifierSpacer = @"SpacerItem";
    if(indexPath.row % 2 == 0){
        PPCDirectoryCell *cell = (PPCDirectoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPCDirectoryCell" owner:self options:nil];
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
        cell.pathToCell = indexPath;
        cell.principalTable = tableView;
        cell.delegate = self;
        cell.cardImage.image = [UIImage imageWithContentsOfFile: [PPCCommon_Methods getPathToImage:[auxDict objectForKey:@"foto"]]];
        cell.cardImage.contentMode = UIViewContentModeScaleAspectFit;
        /*UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   500,
                                                                   25)];

        
        label.text = @"HOLA COMO ESTAMOS EL DIA DE HOY HOLA COMO ESTAMOS EL DIA DE HOY HOLA COMO ESTAMOS EL DIA DE HOY HOLA COMO ESTAMOS EL DIA DE HOY";
        label.font = [UIFont fontWithName:@"Arial" size:12];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor redColor];
        CGSize tamano = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        label.frame = CGRectMake(0, 0, tamano.width, tamano.height);*/
        //[cell addSubview:label];
        //[cell.scrollContent addSubview:label];
        //[cell.scrollContent setContentSize:CGSizeMake(tamano.width, tamano.height)];
        [PPCCommon_Methods setTextView:cell.cardName andDict:auxDict andKey:@"nombre" andTextColor:@"#9AB4CB" andIsBold:false];
        [PPCCommon_Methods setTextView:cell.jobPosition andDict:auxDict andKey:@"puesto" andTextColor:@"#000000" andIsBold:true];
        [cell.layer setMasksToBounds:YES];
        cell.backgroundColor = [PPCCommon_Methods colorFromHexString:@"#FFFFFF" andAlpha:NO];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *auxDict = [contactArray objectAtIndex: indexPath.row/2];
    self.detailView = [[PPCDetail_View alloc] initWithNibName:@"PPCDetail_View" bundle:nil];
    self.detailView.view.frame = CGRectMake(0, 0, 320, 492);
    self.detailView.personDetails = auxDict;
    [self.navigationController pushViewController:self.detailView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row % 2 ==0)
        return 90;
    else
        return 3;
}

- (void)returnToMenu:(id)sender {
    if([self.delegate respondsToSelector:@selector(openMenu:)])
    {
        [self.delegate openMenu: self.navigationController];
    }
}

@end
