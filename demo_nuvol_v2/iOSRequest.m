//
//  iOSRequest.m
//  WebServiceDemo
//
//  Created by Andrew Barba on 10/14/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "iOSRequest.h"
#import "NSString+WebService.h"

NSString *basePath =@"http://10.20.20.249/codiad/workspace/people-cloud/controller/"; //@"http://demo.people-cloud.com/controller/";

@implementation iOSRequest
+(void)requestPath:(NSString *)path onCompletion:(RequestCompletionHandler)complete
{
    // Background Queue
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    // URL Request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: path]
                                                  cachePolicy:0
                                              timeoutInterval:10];
    // Send Request
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               if (complete) complete(result,error);
                           }];
}

+(void)loginWithUserName:(NSString *)userName
             andPassword:(NSString *)password andUID: (NSString *)UID andName:(NSString *)name
            onCompletion:(RequestDictionaryCompletionHandler)complete
{
    // Encode ARGS for URL
    userName = [userName URLEncode];
    password = [password URLEncode];
    name = [name URLEncode];
    NSString *deviceType = [UIDevice currentDevice].model;
    deviceType = [deviceType stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    //NSString *fullPath = [basePath stringByAppendingFormat:@"%@?mobile=1&usuarios=%@&password=%@&UID=%@&name=%@&device_type=%@",@"Mobile_Controller",userName,password,UID,name,deviceType,nil];
    NSString *fullPath = [basePath stringByAppendingFormat:@"%@?&mobile=1&usuarios=%@&password=%@&UID=%@&name=%@&device_type=%@",@"Mobile_Controller",userName,password,UID,name,deviceType,nil];
    NSLog(@"%@",fullPath);
    [iOSRequest requestPath:fullPath onCompletion:^(NSString *result, NSError *error){
        if (error || [result isEqualToString:@""]) {
            if (complete) complete(nil);
        } else {
            NSDictionary *user = [result JSON];
            if (complete) complete(user);
        }
    }];
}

+(void)generalRequest:(NSString *)SID andUser: (NSString *)user andToken: (NSString *)token andAction: (NSString *)action andController:(NSString *)controller andParams: (NSString *) params onCompletion:(RequestDictionaryCompletionHandler)complete{
    
    SID = [SID URLEncode];
    user = [user URLEncode];
    token = [token URLEncode];
    //NSString *fullPath = [basePath stringByAppendingFormat:@"%@?mobile=1&usuarios=%@&SID=%@&token=%@&accion=%@&%@",controller,user,SID,token,action,params];
    NSString *fullPath = [basePath stringByAppendingFormat:@"%@?&mobile=1&usuarios=%@&SID=%@&token=%@&accion=%@&%@",controller,user,SID,token,action,params];
    NSLog(@"%@",fullPath);
    [iOSRequest requestPath:fullPath onCompletion:^(NSString *result, NSError *error){
        if (error || [result isEqualToString:@""]) {
            if (complete) complete(nil);
        } else {
            NSDictionary *user = [result JSON];
            if (complete) complete(user);
        }
    }];
}

+(void)imageRequest:(NSString *)SID andUser: (NSString *)user andToken: (NSString *)token andAction: (NSString *)action andController:(NSString *)controller onCompletion:(RequestDictionaryCompletionHandler)complete{
    SID = [SID URLEncode];
    user = [user URLEncode];
    token = [token URLEncode];
    NSString *fullPath = [basePath stringByAppendingFormat:@"%@?mobile=1&usuarios=%@&SID=%@&token=%@&accion=%@",controller,user,SID,token,action];
    NSLog(@"%@",fullPath);
    [iOSRequest requestPath:fullPath onCompletion:^(NSString *result, NSError *error){
        if (error || [result isEqualToString:@""]) {
            if (complete) complete(nil);
        } else {
            NSDictionary *user = [result JSON];
            if (complete) complete(user);
        }
    }];
}

@end
