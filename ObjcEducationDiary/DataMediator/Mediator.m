//
//  Mediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Mediator.h"
#import "NetworkManager.h"

@implementation Mediator

// init
- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

// parse
- (id)parseJSON:(NSData *)data {
    NSError *errr;
    
    NSDictionary *objectJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errr];
    
    if (errr) {
        NSLog(@"Failed to serialize into JSON, %@", errr);
        return nil;
    }
    
    return objectJson;
};

- (void)fetchData:(void (^)(id _Nonnull, NSError * _Nonnull))completionBlock {
    [self fetchDataFromNetwork:completionBlock];
}

// private Fetch from Network
- (void)fetchDataFromNetwork: (void(^)(id, NSError*))completionBlock {
    [NetworkManager getRequest:_path :^(NSData * _Nonnull dat, NSError * _Nonnull err) {
        [self recognizeResult:dat :err :^(NSData *dat, NSError *err) {
            completionBlock(dat,err);
        }];
    }];
}

- (void)recognizeResult: (NSData*)data :(NSError*)error :(void(^)(NSData *dat, NSError *err))completionBlock {
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
        return;
    }
    
    if (data) {
        NSData *decodedData;
        
        if ((decodedData = [self parseJSON:data])) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(decodedData, nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
    }
}

// deleteData
- (void)deleteData:(id<Model>)model :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    [NetworkManager deleteRequest:_path :model.sid :^(id _Nonnull obj, NSError * _Nonnull err) {
        
        if (err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, err);
            });
            return;
        }
        
        if (obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(obj, nil);
            });
        }
    }];
}

- (void)createNewData:(id<Model>)model :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    
    NSError *dataError = nil;
    
    NSData *data = [model jsonData];
    
    if (dataError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, dataError);
        });
    }
    
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (jsonError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, jsonError);
        });
    }
    
    [NetworkManager putRequest:_path :model.sid :json :^(id _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
            return;
        }
        
        if (response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(response, nil);
            });
        }
    }];
}

- (void)updateData:(id<Model>)model :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    NSError *dataError = nil;
    
    NSData *data = [model jsonData];
    
    if (dataError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, dataError);
        });
    }
    
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (jsonError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, jsonError);
        });
    }
    
    [NetworkManager putRequest:_path :model.sid :json :^(id _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
        
        if (response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(response, nil);
            });
        }
    }];
}

@end


