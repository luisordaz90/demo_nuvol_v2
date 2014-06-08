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
+(void)downloadImagesWithArray: (NSArray *) imageArray andDict:(NSMutableDictionary *)docDict;
+(BOOL)textView:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+(void)setLabelDimension: (UILabel *)label andDict: (NSDictionary *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andIsBold: (BOOL) condition andSize: (NSInteger) size;
+(void) setTextView: (UITextView *)textView andDict: (NSDictionary *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andIsBold: (BOOL) condition;
+(void)setTextViewPlain: (UITextView *)textView andString: (NSString *) string andTextColor: (NSString *) color andIsBold: (BOOL) condition andSize: (NSInteger) size andType: (NSString *) type;
+(NSString *) getPlistPath;
+(NSString *) getDocumentsPath;
+(NSString *) getPathToImage: (NSString *) photoName;
@end


