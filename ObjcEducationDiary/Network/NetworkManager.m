//
//  NetworkManager.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 25.03.2021.
//

#import "NetworkManager.h"

typedef void(^myCompletion)(NSObject*, NSError*);

NSString *const hostURLPath = @"https://testapp-3135f-default-rtdb.firebaseio.com/";
//NSURL *hostURLfd = [NSURL URLWithString:hostURLPath];

@implementation NetworkManager

+ (void) getRequest : (NSString *) path
                    : (void(^)(NSData *dat, NSError *err))completionBlock {
    
    NSURL *hostURL = [NSURL URLWithString:hostURLPath];
    NSURL *url = [hostURL URLByAppendingPathComponent:path];
    
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

+ (void) deleteRequest:(NSString *)path
         identificator:(NSString *)identificator
                      :(void (^)(id, NSError*))completionBlock {

    NSURL *hostURL = [NSURL URLWithString:hostURLPath];
    NSURL *pathURL = [hostURL URLByAppendingPathComponent:path];
    NSURL *idURL = [pathURL URLByAppendingPathComponent:identificator];
    NSURL *url = [idURL URLByAppendingPathComponent:@".json"];
    
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"DELETE";
    
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error != nil)
                   {
                       NSLog(@"Error: error calling DELETE");
                       completionBlock(response, error);
                   }
                   else
                   {
                       completionBlock(response, nil);
                   }
    }] resume];
};

+ (void) putRequest: (NSString *) path
                   : (NSString *) identificator
                   : (NSDictionary *) body
                   : (void (^)(id, NSError*))completionBlock {
    
    NSURL *hostURL = [NSURL URLWithString:hostURLPath];
    NSURL *pathURL = [hostURL URLByAppendingPathComponent:path];
    NSURL *idURL = [pathURL URLByAppendingPathComponent:identificator];
    NSURL *url = [idURL URLByAppendingPathComponent:@".json"];
    
    
}

@end
