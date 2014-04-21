//
//  PPCCell_Directory.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/5/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCCell_Directory.h"

@implementation PPCCell_Directory

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    //frame.origin.x += 10;
    //frame.origin.y -= 10;
    //frame.size.width -= 2 * 10;
    //frame.size.height += 50;
    [super setFrame:frame];
}

@end
