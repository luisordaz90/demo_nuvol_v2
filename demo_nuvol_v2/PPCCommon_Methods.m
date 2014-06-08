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

+(NSString *) getPlistPath{
    return [[self getDefaults] objectForKey:@"plistPath"];
}

+(NSString *) getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(NSString *) getPathToImage: (NSString *) photoName{
    NSString *stringAux = photoName;
    stringAux = [stringAux stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithString:stringAux]];
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

+(void)downloadImagesWithArray: (NSArray *) imageArray andDict:(NSMutableDictionary *)docDict{
    for(int i=0; i< [imageArray count]; i++){
        NSDictionary *auxDict = [imageArray objectAtIndex: i];
        NSString *photoName = [auxDict objectForKey:@"foto"];
        photoName = [photoName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
    }
}

+(BOOL)textView:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = textView.text;
    //text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    NSLog(@"TAMANIO: %f<%f", textSize.width, textView.bounds.size.width);
    return (textSize.width < textView.bounds.size.width) ? YES : NO;
}

+(void) setLabelDimension: (UILabel *)label andDict: (NSDictionary *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andIsBold: (BOOL) condition andSize: (NSInteger) size {
    CGFloat punt1 = label.frame.origin.x;
    CGFloat punt2 = label.frame.origin.y;
    CGFloat height = label.frame.size.height;
    CGSize textSize;
    label.text =[auxDict objectForKey:key];
    NSLog(@"ANTES: %f", label.frame.size.width);
    if(size){
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
        textSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    }
    else{
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        textSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    }
    NSLog(@"DESP: %f", textSize.width);
    label.frame = CGRectMake(punt1, punt2, textSize.width, height);
    label.numberOfLines=2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [self colorFromHexString:color andAlpha:NO];
}

+(void) setTextView: (UITextView *)textView andDict: (NSDictionary *) auxDict andKey: (NSString *)key andTextColor: (NSString *) color andIsBold: (BOOL) condition {
    textView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    textView.text = [auxDict objectForKey:key];
    textView.textColor = [self colorFromHexString:color andAlpha:NO];
    if(condition)
        [textView setFont:[UIFont boldSystemFontOfSize:13]];
    BOOL sino = [PPCCommon_Methods textView:textView shouldChangeCharactersInRange:NSMakeRange(0, 10) replacementString:[auxDict objectForKey:key]];
    NSLog(sino ? @"YES":@"NO");
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.scrollEnabled = NO;
}

+(void) setTextViewPlain: (UITextView *)textView andString: (NSString *) string andTextColor: (NSString *) color andIsBold: (BOOL) condition andSize: (NSInteger) size andType: (NSString *) type{
    NSString *font_name = [@"HelveticaNeue" stringByAppendingString:type];
    textView.font = [UIFont fontWithName:font_name size: size];
    textView.text = string;
    textView.textColor = [self colorFromHexString:color andAlpha:NO];
    if(condition)
        [textView setFont:[UIFont fontWithName:font_name size:size]];
    BOOL sino = [PPCCommon_Methods textView:textView shouldChangeCharactersInRange:NSMakeRange(0, 10) replacementString:string];
    NSLog(sino ? @"YES":@"NO");
    textView.editable = NO;
    textView.scrollEnabled = NO;
}

@end
