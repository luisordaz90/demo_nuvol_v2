//
//  PPCDirectory_View.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/24/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "PPCDetail_View.h"
#import "PPCDirectoryCell.h"
#import "PPCCommon_Methods.h"

@protocol DirectoryProtocol <NSObject>
    -(void)openMenu: (UIViewController *) view;
@end

@interface PPCDirectory_View : UIViewController  <UITableViewDelegate, UITableViewDataSource, DirectoryCellProtocol, UIScrollViewDelegate, UINavigationControllerDelegate>
@property (strong,nonatomic) PPCDetail_View *detailView;
@property (weak, nonatomic) id<DirectoryProtocol> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableViewDirectory;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end
