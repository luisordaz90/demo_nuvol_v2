//
// MSMenuView.h
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



#import <UIKit/UIKit.h>
@protocol MSMenuViewDelegate<NSObject>
@required
-(void)welcomeTabClick;
-(void)vacationTabClick;
-(void)directoryTabClick;
-(void)infoCenterTabClick;
-(void)preferencesTabClick;
@end
@interface MSMenuView : UIView{
    UIButton *welcomeTab;
    UIButton *vacationTab;
    UIButton *directoryTab;
    UIButton *infoCenterTab;
    UIButton *preferencesTab;
    id <MSMenuViewDelegate> delegate;
}
@property(nonatomic,strong)id <MSMenuViewDelegate> delegate;
@property(nonatomic,strong) UIButton *welcomeTab;
@property(nonatomic,strong) UIButton *vacationTab;
@property(nonatomic,strong) UIButton *directoryTab;
@property(nonatomic,strong) UIButton *infoCenterTab;
@property(nonatomic,strong) UIButton *preferencesTab;

-(void)tabClickAction:(id)sender;
@end