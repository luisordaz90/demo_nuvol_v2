//
//  PPCCustom_Cell_Welcome.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 2/11/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCWelcomeCell.h"

@implementation PPCWelcomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)touchedCell:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickedCell:)])
    {
        [self.delegate clickedCell: _pathToCell];
    }
}
@end
