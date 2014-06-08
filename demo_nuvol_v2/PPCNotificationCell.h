//
//  PPCCell_Notification.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/19/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCNotificationCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UITextView *notificationText;
@property (weak, nonatomic) IBOutlet UILabel *messageNumber;

@end
