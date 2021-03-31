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
- (instancetype)initWithPathForUpdate:(NSString *)pathForUpdate pathForFetch:(NSString *)pathForFetch {
    self = [super init];
    
    if (self) {
        _pathForUpdate = pathForUpdate;
        _pathForFetch = pathForFetch;
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
    [NetworkManager getRequest:_pathForFetch :^(NSData * _Nonnull dat, NSError * _Nonnull err) {
        [self recognizeResult:dat :err :^(NSData *dat, NSError *err) {
            completionBlock(dat,err);
        }];
    }];
}

- (void)recognizeResult: (NSData*)data :(NSError*)error :(void(^)(NSData *dat, NSError *err))completionBlock {
    if (data != nil) {
        
        NSData *decodedData;
        
        if ((decodedData = [self parseJSON:data])) {
            completionBlock(decodedData, nil);
        } else {
            completionBlock(nil, error);
        }
    }
}

// deleteData
- (void)deleteData:(id<Model>)model :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    [NetworkManager deleteRequest:_pathForUpdate :model.sid :^(id _Nonnull obj, NSError * _Nonnull err) {
        
        if (obj != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(obj, nil);
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, err);
            });
        }
        
    }];
}

- (void)createNewData:(id<Model>)model :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    
    NSError *dataError = nil;
    
    NSData *data = [model jsonData];
    
    if (dataError) {
        completionBlock(nil, dataError);
        NSLog(@"Error while converting to data");
    }
    
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (jsonError) {
        completionBlock(nil, jsonError);
        NSLog(@"Error while converting to json");
    }
    
    [NetworkManager putRequest:_pathForUpdate :model.sid :json :^(id _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(response, nil);
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
    }];
}

- (void)updateData:(id<Model>)model :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    NSError *dataError = nil;
    
    NSData *data = [model jsonData];
    
    if (dataError) {
        completionBlock(nil, dataError);
        NSLog(@"Error while converting to data");
    }
    
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (jsonError) {
        completionBlock(nil, jsonError);
        NSLog(@"Error while converting to json");
    }
    
    [NetworkManager putRequest:_pathForUpdate :model.sid :json :^(id _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(response, nil);
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
    }];
}

    
@end


