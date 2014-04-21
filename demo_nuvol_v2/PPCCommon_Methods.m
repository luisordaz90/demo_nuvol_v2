//
//  PPCCommon_Methods.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 3/23/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCCommon_Methods.h"

@implementation PPCCommon_Methods


+ (UIColor *)colorFromHexString:(NSString *)hexString andAlpha: (BOOL) alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    if(!alpha)
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    else
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:0.6];
}

+ (UIView *)generateLoadingView: (CGRect) dimensions andIndicatorDimensions:(CGRect)indicator_dimensions andAlpha: (BOOL) alpha{
    UIView *loadingView = [[UIView alloc] initWithFrame:dimensions];
    if(alpha)
        [loadingView setBackgroundColor:[self colorFromHexString:@"#000000" andAlpha:YES]];
    UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinning.frame = indicator_dimensions;
    [spinning startAnimating];
    [loadingView addSubview:spinning];
    return loadingView;
}

+(NSString *)getPath:(NSInteger)path{
    rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                    NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"infoPlist.plist"];
    if(path == 0)
        return rootPath;
    else
        return plistPath;
}

+(NSUserDefaults *) getDefaults{
    defaultVals = [NSUserDefaults standardUserDefaults];
    return defaultVals;
}

+(void)downloadImages: (NSString *) imageName andDict:(NSMutableDictionary *)docDict{
    NSLog(@"IMAGEN %@",imageName);
    NSString *photoName = imageName;
    NSString *aux = [photoName stringByReplacingOccurrencesOfString:@"%20" withString:@""];
    if(![docDict objectForKey:aux]){
        NSString *imageURL = @"http://demo.people-cloud.com/uploads/personas/";
        imageURL =[imageURL stringByAppendingString:photoName];
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        if(image != NULL)
        {
            NSData *imageData = UIImagePNGRepresentation(image);
            [imageData writeToFile:  [[PPCCommon_Methods getPath:0] stringByAppendingPathComponent:[NSString stringWithString:aux]] atomically:YES];
        }
    }
    else
        NSLog(@"NO ENTRO A BAJAR");
}


+(BOOL)textView:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = textView.text;
    //text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    NSLog(@"TAMANIO: %f<%f", textSize.width, textView.bounds.size.width);
    return (textSize.width < textView.bounds.size.width) ? YES : NO;
}

+(void) setLabelDimension: (UILabel *)label andWidth: (NSInteger) width andDict: (NSUserDefaults *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andIsBold: (BOOL) condition andSize: (NSInteger) size {
    CGFloat punt1 = label.frame.origin.x;
    CGFloat punt2 = label.frame.origin.y;
    CGFloat height = label.frame.size.height;
    label.frame = CGRectMake(punt1, punt2, width, height);
    if(size){
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
    }
    else{
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    }
    label.numberOfLines=2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    if(![key isEqualToString:@""])
        label.text = [auxDict objectForKey:key];
    label.textColor = [PPCCommon_Methods colorFromHexString:color andAlpha:NO];
}

@end
