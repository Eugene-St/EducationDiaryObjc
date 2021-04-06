//
//  NetworkManager.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 25.03.2021.
//

#import "NetworkManager.h"

typedef void(^myCompletion)(NSObject*, NSError*);

NSString *const hostURLPath = @"https://testapp-3135f-default-rtdb.firebaseio.com/";

@implementation NetworkManager

+ (void) getRequest : (NSString *) path
                    : (void(^)(NSData *dat, NSError *err))completionBlock {
    
    NSURL *url = [[[NSURL URLWithString:hostURLPath]
                          URLByAppendingPathComponent:path]
                          URLByAppendingPathExtension:@"json"];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completionBlock(nil, error);
            NSLog(@"fetch failed, %@", error);
            return;
        }
        
        if (data) {
            completionBlock(data, nil);
        }
            
        }] resume];
}
// todo: host, path, query, body


+ (void)deleteRequest:(NSString *)path :(NSString *)identificator :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    
    NSURL *url = [[[[NSURL
                    URLWithString:hostURLPath]
                    URLByAppendingPathComponent:path]
                    URLByAppendingPathComponent:identificator]
                    URLByAppendingPathExtension:@"json"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod: @"DELETE"];
    
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error != nil) {
                       NSLog(@"Error: error calling DELETE");
                       completionBlock(nil, error);
                   } else {
                       completionBlock(response, nil);
                   }
    }] resume];
}

+ (void) putRequest: (NSString *) path
                   : (NSString *) identificator
                   : (NSDictionary *) body
                   : (void (^)(id, NSError*))completionBlock {
    
    NSURL *url = [[[[NSURL
                    URLWithString:hostURLPath]
                    URLByAppendingPathComponent:path]
                    URLByAppendingPathComponent:identificator]
                    URLByAppendingPathExtension:@"json"];
    
    NSDictionary *putData = body;
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    urlRequest.HTTPMethod = @"PUT";
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:putData options:NSJSONWritingPrettyPrinted error:&error];
    urlRequest.HTTPBody = data;
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [[NSURLSession.sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        if (error) {
            completionBlock(nil, error);
        }
        
        completionBlock(response, nil);
    
    }]resume];

}

+ (void)patchRequest:(NSString *)path :(NSString *)identificator :(NSDictionary *)body :(void (^)(id _Nullable, NSError * _Nullable ))completionBlock {
    
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
    
    NSDictionary *putData = body;
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    urlRequest.HTTPMethod = @"PATCH";
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:putData options:NSJSONWritingPrettyPrinted error:&error];
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
