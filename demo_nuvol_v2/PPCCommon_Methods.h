//
//  PPCCommon_Methods.h
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/23/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import <Foundation/Foundation.h>
NSUserDefaults *defaultVals;
NSString *rootPath;
NSString *plistPath;
//NSString *basePath = @"http://10.20.20.247/proxy?controller=";
@interface PPCCommon_Methods : NSObject
+ (UIColor *)colorFromHexString:(NSString *)hexString andAlpha: (BOOL) alpha;
+ (UIView *)generateLoadingView: (CGRect) dimensions andIndicatorDimensions: (CGRect) indicator_dimensions andAlpha: (BOOL) alpha;
+ (NSString *) getPath: (NSInteger) path;
+ (NSUserDefaults *) getDefaults;
+(void)downloadImages: (NSString *) imageName andDict: (NSMutableDictionary *) docDict;
+(BOOL)textView:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+(void)setLabelDimension: (UILabel *)label andWidth: (NSInteger) width andDict: (NSUserDefaults *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andIsBold: (BOOL) condition andSize: (NSInteger) size;
+(NSString *) getPlistPath;
@end


