//
//  Mediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Mediator.h"
#import "NetworkManager.h"
#import "Model.h"

#pragma mark - Implementation
@implementation Mediator

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
    NSMutableArray<Model> *objects = [[NSMutableArray<Model> alloc] init];
    
    for ( NSString *key in [objectJson allKeys]) {
        id modelClass = [[_modelClass alloc]initWithDictionary:objectJson[key]];
        [objects addObject:modelClass];
    }
    if (errr) {
        return nil;
    }
    return objects;
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
    NSData *data = [model mapJSONToDataWithError: &dataError];
    
    if (dataError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, dataError);
        });
    }
    
    [NetworkManager putRequest:_path :model.sid :data :^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(response, nil);
            });
        }
    }];
}

#pragma mark - Update data
- (void)updateData:(id<Model>)model :(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    NSError *dataError = nil;
    NSData *data = [model mapJSONToDataWithError: &dataError];
    
    if (dataError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, dataError);
        });
    }
    
    [NetworkManager patchRequest:_path :model.sid :data :^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(response, nil);
            });
        }
    }];
}

@end


