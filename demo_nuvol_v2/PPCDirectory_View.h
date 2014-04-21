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
@protocol DirectoryProtocol <NSObject>
    -(void)requestPersonDetail: (NSDictionary *) personDetails;
@end
@interface PPCDirectory_View : UIViewController  <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewDirectory;
@property (weak, nonatomic) id<DirectoryProtocol> delegate;

@end
