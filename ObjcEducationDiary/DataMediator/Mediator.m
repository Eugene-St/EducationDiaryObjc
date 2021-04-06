//
//  Mediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Mediator.h"
#import "NetworkManager.h"
#import "Bookmark.h"

#pragma mark - Implementation
@implementation Mediator

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path modelCLass:(Class)modelCLass {
    self = [super init];
    if (self) {
        _path = path;
        _modelClass = modelCLass;
    }
    return self;
}

#pragma mark - Parse JSON
- (id)parseJSON:(NSData *)data {
    NSError *errr;
    NSDictionary *objectJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errr];
    
    id modelClass = [[_modelClass alloc]initWithDictionary:objectJson];
    
    
    if (errr) {
        return nil;
    }
    return objectJson;
};

#pragma mark - Fetch data
- (void)fetchData:(void (^)(id _Nonnull, NSError * _Nonnull))completionBlock {
    [self fetchDataFromNetwork:completionBlock];
}

#pragma mark - Fetch data from network
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

#pragma mark - Delete data
- (void)deleteData:(id<Model>)model :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    [NetworkManager deleteRequest:_path :model.sid :^(id _Nonnull object, NSError * _Nonnull error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
            return;
        }
        
        if (object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(object, nil);
            });
        }
    }];
}

#pragma mark - Create new data
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

#pragma mark - Update data
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


