//
//  NetworkManager.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 25.03.2021.
//

#import "NetworkManager.h"

typedef void(^myCompletion)(NSObject*, NSError*);

@implementation NetworkManager

+ (void) fetchDataFromNetwork:(void(^)(NSData *dat, NSError *err))completionBlock {
    
    NSURL *url = [NSURL URLWithString:@"https://testapp-3135f-default-rtdb.firebaseio.com/bookmarks.json"];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completionBlock(nil, error);
            NSLog(@"fetch failed, %@", error);
            return;
        }
        
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(data, nil);
            });
            NSLog(@"fetch success %@", data);
        }
            
        }] resume];
}

@end
