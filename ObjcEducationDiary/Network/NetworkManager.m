//
//  NetworkManager.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 25.03.2021.
//

#import "NetworkManager.h"

typedef void(^myCompletion)(NSData * _Nullable, NSError * _Nullable);
NSString *const hostURLPath = @"https://testapp-3135f-default-rtdb.firebaseio.com/";

@implementation NetworkManager

#pragma mark - GET request
+ (void) getRequest:(NSString *)path :(myCompletion)completionBlock {
    NSURL *url = [[[NSURL URLWithString:hostURLPath]
                   URLByAppendingPathComponent:path]
                  URLByAppendingPathExtension:@"json"];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url
                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
        } else {
            completionBlock(data, nil);
        }
    }] resume];
}

#pragma mark - DELETE request
+ (void)deleteRequest:(NSString *)path :(NSString *)identificator :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    NSURL *url = [[[[NSURL
                     URLWithString:hostURLPath]
                    URLByAppendingPathComponent:path]
                   URLByAppendingPathComponent:identificator]
                  URLByAppendingPathExtension:@"json"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"DELETE"];
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completionBlock(nil, error);
        } else {
            completionBlock(response, nil);
        }
    }] resume];
}

#pragma mark - PUT request
+ (void)putRequest:(NSString *)path :(NSString *)identificator :(NSData *)data :(completion)completionBlock {
    NSURL *url = [[[[NSURL
                     URLWithString:hostURLPath]
                    URLByAppendingPathComponent:path]
                   URLByAppendingPathComponent:identificator]
                  URLByAppendingPathExtension:@"json"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"PUT";
    urlRequest.HTTPBody = data;
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [[NSURLSession.sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
        }
        completionBlock(response, nil);
        
    }]resume];
}

#pragma mark - PATCH request

+ (void)patchRequest:(NSString *)path :(NSString *)identificator :(NSData *)data :(completion)completionBlock {
    NSURL *url;
    
    if (identificator) {
        url = [[[[NSURL
                  URLWithString:hostURLPath]
                 URLByAppendingPathComponent:path]
                URLByAppendingPathComponent:identificator]
               URLByAppendingPathExtension:@"json"];
        
    } else {
        completionBlock(nil, [NSError errorWithDomain:@"Host url is invalid" code:0 userInfo:nil]);
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"PATCH";
    urlRequest.HTTPBody = data;
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [[NSURLSession.sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
        }
        completionBlock(response, nil);
    }]resume];
}

@end
