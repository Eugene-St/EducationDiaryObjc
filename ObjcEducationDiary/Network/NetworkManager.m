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

+ (void)deleteRequest:(NSString *)path :(NSString *)identificator :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    
    NSURL *hostURL = [NSURL URLWithString:hostURLPath];
    NSURL *pathURL = [hostURL URLByAppendingPathComponent:path];
    NSURL *idURL = [pathURL URLByAppendingPathComponent:identificator];
    NSURL *url = [idURL URLByAppendingPathComponent:@".json"];
    
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
                    URLByAppendingPathComponent:@".json"];
    
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
    
    NSURL *url = [[[[NSURL
                    URLWithString:hostURLPath]
                    URLByAppendingPathComponent:path]
                    URLByAppendingPathComponent:identificator]
                    URLByAppendingPathComponent:@".json"];
    
    BOOL isValidURL = [NSURLConnection canHandleRequest:[NSURLRequest requestWithURL:url]];
    
    if (!isValidURL) {
        completionBlock(nil, [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Host url is invalid@"}]);
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
