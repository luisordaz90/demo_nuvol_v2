//
// MSMenuView.m
// MSMenuView
//
// Copyright (c) 2013 Selvam Manickam (https://github.com/selvam4274)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "MSMenuView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MSMenuView
@synthesize  welcomeTab,vacationTab,directoryTab,infoCenterTab,preferencesTab,delegate;


- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"%lf %lf",frame.origin.x,frame.origin.y);
    CGRect frame1=CGRectMake(frame.origin.x, frame.origin.y, 320, 76);
    self = [super initWithFrame:frame1];
    if (self) {
        UIView *vistaDel = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 4, 71)];
        [vistaDel setBackgroundColor: [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5f]];
        welcomeTab=[UIButton buttonWithType:UIButtonTypeCustom];
        [welcomeTab setFrame:CGRectMake(0, 0, 80, 71)];
        [welcomeTab setSelected:YES];
        [welcomeTab setTag:1];
        [welcomeTab setTitle:@"Inicio" forState:UIControlStateNormal];
        NSString *myString = vacationTab.titleLabel.text;
        CGSize maximumSize = CGSizeMake(80, 10);
        UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:14];
        CGRect myStringSize =  [myString boundingRectWithSize: maximumSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:myFont} context:nil];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40-12, (71-16.1)/2-12, 24, 24)];
        imgView.autoresizesSubviews = NO;
        imgView.autoresizingMask = 0;
        imgView.image = [UIImage imageNamed:@"48x48_4.png"];
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imgView setTintColor:[UIColor whiteColor]];
        [welcomeTab.titleLabel setFont:[UIFont systemFontOfSize:10]];
        //move text 10 pixels down and right
        [welcomeTab setTitleEdgeInsets:UIEdgeInsetsMake(45.0f, 0.0f, 0.0f, 0.0f)];
        [welcomeTab setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        welcomeTab.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        //[welcomeTab setBackgroundImage:[UIImage imageNamed:@"TabBarBG.png"] forState:UIControlStateNormal];
        //[welcomeTab setBackgroundImage:[UIImage imageNamed:@"TabBarBG.png"] forState:UIControlStateSelected];
        [welcomeTab setBackgroundColor:[UIColor colorWithRed:94.0f/255.0f green:145.0f/255.0f blue:234.0f/255.0f alpha:1.0f]];
        [welcomeTab addTarget:self action:@selector(tabClickAction:) forControlEvents:UIControlEventTouchUpInside];
        //[welcomeTab addSubview:vistaDel];
        [welcomeTab addSubview:imgView];
        [self addSubview:welcomeTab];
        

        vacationTab=[UIButton buttonWithType:UIButtonTypeCustom];
        [vacationTab setFrame:CGRectMake(80, 5, 80, 71)];
        [vacationTab setTag:2];
        [vacationTab setTitle:@"Vacaciones" forState:UIControlStateNormal];
        maximumSize = CGSizeMake(80, 10);
        myString = vacationTab.titleLabel.text;
        myFont = [UIFont fontWithName:@"Helvetica" size:14];
        myStringSize = [myString boundingRectWithSize: maximumSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:myFont} context:nil];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40-12, (71-myStringSize.size.height)/2-12, 24, 24)];
        NSLog(@"HEIGHT %lf",myStringSize.size.height);
        imgView.image = [UIImage imageNamed:@"24x24_2.png"];
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imgView setTintColor:[UIColor whiteColor]];
        [vacationTab setTitleEdgeInsets:UIEdgeInsetsMake(45.0f, 0.0f, 0.0f, 0.0f)];
        [vacationTab.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [vacationTab setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        vacationTab.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        [vacationTab setBackgroundColor:[UIColor colorWithRed:94.0f/255.0f green:145.0f/255.0f blue:234.0f/255.0f alpha:1.0f]];
        [vacationTab addTarget:self action:@selector(tabClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [vacationTab addSubview:imgView];
        [self addSubview:vacationTab];

        directoryTab=[UIButton buttonWithType:UIButtonTypeCustom];
        [directoryTab setFrame:CGRectMake(160, 5, 80, 71)];
        [directoryTab setTag:3];
        [directoryTab setTitle:@"Directorio" forState:UIControlStateNormal];
        maximumSize = CGSizeMake(80, 10);
        myString = directoryTab.titleLabel.text;
        myFont = [UIFont fontWithName:@"Helvetica" size:14];
        myStringSize = [myString boundingRectWithSize: maximumSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:myFont} context:nil];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40-12, (71-myStringSize.size.height)/2-12, 24, 24)];
        imgView.image = [UIImage imageNamed:@"24x24_3.png"];
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imgView setTintColor:[UIColor whiteColor]];
        [directoryTab setTitleEdgeInsets:UIEdgeInsetsMake(45.0f, 0.0f, 0.0f, 0.0f)];
        [directoryTab.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [directoryTab setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        directoryTab.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        [directoryTab setBackgroundColor:[UIColor colorWithRed:94.0f/255.0f green:145.0f/255.0f blue:234.0f/255.0f alpha:1.0f]];
        [directoryTab addTarget:self action:@selector(tabClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [directoryTab addSubview:imgView];
        [self addSubview:directoryTab];

        /*infoCenterTab=[UIButton buttonWithType:UIButtonTypeCustom];
        [infoCenterTab setFrame:CGRectMake(192, 5, 64, 71)];
        [infoCenterTab setTag:4];
        [infoCenterTab setTitle:@"Nómina" forState:UIControlStateNormal];
        maximumSize = CGSizeMake(64, 10);
        myString = infoCenterTab.titleLabel.text;
        myFont = [UIFont fontWithName:@"Helvetica" size:14];
        myStringSize = [myString sizeWithFont:myFont
                            constrainedToSize:maximumSize
                                lineBreakMode:NO];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(32-12, (71-myStringSize.height)/2-12, 24, 24)];
        imgView.image = [UIImage imageNamed:@"24x24_4.png"];
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imgView setTintColor:[UIColor whiteColor]];
        [infoCenterTab setTitleEdgeInsets:UIEdgeInsetsMake(45.0f, 0.0f, 0.0f, 0.0f)];
        [infoCenterTab.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [infoCenterTab setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        infoCenterTab.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        [infoCenterTab setBackgroundColor:[UIColor colorWithRed:94.0f/255.0f green:145.0f/255.0f blue:234.0f/255.0f alpha:1.0f]];
        [infoCenterTab addTarget:self action:@selector(tabClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [infoCenterTab addSubview: imgView];
        [self addSubview:infoCenterTab];*/

        
        preferencesTab=[UIButton buttonWithType:UIButtonTypeCustom];
        [preferencesTab setFrame:CGRectMake(240, 5, 80, 71)];
        [preferencesTab setTag:5];
        [preferencesTab setTitle:@"Ajustes" forState:UIControlStateNormal];
        maximumSize = CGSizeMake(80, 10);
        myString = preferencesTab.titleLabel.text;
        myFont = [UIFont fontWithName:@"Helvetica" size:14];
        myStringSize = [myString boundingRectWithSize: maximumSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:myFont} context:nil];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40-12, (71-myStringSize.size.height)/2-12, 24, 24)];
        imgView.image = [UIImage imageNamed:@"24x24_6.png"];
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imgView setTintColor:[UIColor whiteColor]];
        [preferencesTab setTitleEdgeInsets:UIEdgeInsetsMake(45.0f, 0.0f, 0.0f, 0.0f)];
        [preferencesTab.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [preferencesTab setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
         preferencesTab.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        [preferencesTab setBackgroundColor:[UIColor colorWithRed:94.0f/255.0f green:145.0f/255.0f blue:234.0f/255.0f alpha:1.0f]];
        preferencesTab.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [preferencesTab addTarget:self action:@selector(tabClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [preferencesTab addSubview:imgView];
        [self addSubview:preferencesTab];
        UIView *inferiorDelimeter = [[UIView alloc] initWithFrame:CGRectMake(0, 71, 320, 5)];
        [inferiorDelimeter setBackgroundColor: [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5f]];
        [self addSubview:inferiorDelimeter];
        
        
    }
    
  
    return self;
    
    
}
//Need to add tag
-(void)checkSelectedTab:(UIButton *)sender{
    int buttonTag=(int)sender.tag;
    
    if (welcomeTab.selected && welcomeTab.tag!=buttonTag) {
        CGRect TempFrame=welcomeTab.frame;
        [UIView animateWithDuration:0.3 animations:^{
        [welcomeTab setFrame:CGRectMake(TempFrame.origin.x, TempFrame.origin.y+5, TempFrame.size.width, TempFrame.size.height)];
         }completion:^(BOOL finished) {
            
        }];
        welcomeTab.selected=NO;
            
        
    }
    else if (vacationTab.selected && vacationTab.tag!=buttonTag) {
        CGRect TempFrame=vacationTab.frame;
         [UIView animateWithDuration:0.3 animations:^{
        [vacationTab setFrame:CGRectMake(TempFrame.origin.x, TempFrame.origin.y+5, TempFrame.size.width, TempFrame.size.height)];
         }completion:^(BOOL finished) {
             
         }];
        vacationTab.selected=NO;
    }
   else if (directoryTab.selected && directoryTab.tag!=buttonTag) {
       CGRect TempFrame=directoryTab.frame;
       [UIView animateWithDuration:0.3 animations:^{
       [directoryTab setFrame:CGRectMake(TempFrame.origin.x, TempFrame.origin.y+5, TempFrame.size.width, TempFrame.size.height)];
       }completion:^(BOOL finished) {
           
       }];
       directoryTab.selected=NO;
    }
   else if (infoCenterTab.selected && infoCenterTab.tag!=buttonTag) {
       CGRect TempFrame=infoCenterTab.frame;
       [UIView animateWithDuration:0.3 animations:^{
       [infoCenterTab setFrame:CGRectMake(TempFrame.origin.x, TempFrame.origin.y+5, TempFrame.size.width, TempFrame.size.height)];
       }completion:^(BOOL finished) {
           
       }];
       infoCenterTab.selected=NO;
   }
   else if (preferencesTab.selected &&preferencesTab.tag!=buttonTag) {
       CGRect TempFrame=preferencesTab.frame;
        [UIView animateWithDuration:0.3 animations:^{
       [preferencesTab setFrame:CGRectMake(TempFrame.origin.x, TempFrame.origin.y+5, TempFrame.size.width, TempFrame.size.height)];
        }completion:^(BOOL finished) {
            
        }];
       preferencesTab.selected=NO;
   }

}
-(void)callTabAction:(UIButton *)sender{
    int value=(int)sender.tag;
    if (value==1) {
        [self.delegate welcomeTabClick];
    }
    if (value==2) {
        [self.delegate vacationTabClick];
      }
    if (value==3) {
        [self.delegate directoryTabClick];
    }
    if (value==4) {
        [self.delegate infoCenterTabClick];
    }
    if (value==5) {
        [self.delegate preferencesTabClick];
     }
}

-(void)tabClickAction:(id)sender{
        UIButton *btn=(UIButton *)sender;
        CGRect rec=btn.frame;
        if (!btn.selected) {
           [UIView animateWithDuration:0.3 animations:^{
                [btn setFrame:CGRectMake(rec.origin.x, rec.origin.y-5, rec.size.width, rec.size.height)];
           } completion:^(BOOL finished) {
               
    
            }];
            btn.selected=YES;
            [self checkSelectedTab:btn];
            [self  callTabAction:btn];
       }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
