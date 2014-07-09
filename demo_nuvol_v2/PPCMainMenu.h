//
//  PPCMainMenu.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 6/9/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol menuProtocol <NSObject>
    -(void)setNewCentralPane: (NSInteger) panel;
@end
@interface PPCMainMenu : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) id<menuProtocol> delegate;
@property BOOL showing;
@end
