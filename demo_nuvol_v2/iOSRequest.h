//
//  iOSRequest.h
//  WebServiceDemo
//
//  Created by Andrew Barba on 10/14/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPCCommon_Methods.h"

typedef void(^RequestCompletionHandler)(NSString*,NSError*);
typedef void(^RequestDictionaryCompletionHandler)(NSDictionary*);

@interface iOSRequest : NSObject

+(void)requestPath:(NSString *)path
      onCompletion:(RequestCompletionHandler)complete;

+(void)loginWithUserName:(NSString *)userName
             andPassword:(NSString *)password andUID: (NSString *) UID
                 andName:(NSString *) name
            onCompletion:(RequestDictionaryCompletionHandler)complete;
+(void)generalRequest:(NSString *)SID
             andUser:(NSString *)user
           andToken: (NSString *)token
          andAction: (NSString *) action
        andController: (NSString *)controller
            andParams: (NSString *) params
            onCompletion:(RequestDictionaryCompletionHandler)complete;
@end
